#include "WifiManager.h"

#include <QProcessEnvironment>
#include <QRegularExpression>
#include <QUuid>
#include <memory>

namespace {
QStringList fields(const QString &line)
{
    QStringList result;
    QString field;
    bool escaped = false;
    for (QChar ch : line) {
        if (escaped) { field += ch; escaped = false; }
        else if (ch == u'\\') escaped = true;
        else if (ch == u':') { result << field; field.clear(); }
        else field += ch;
    }
    result << field;
    return result;
}
}

WifiManager::WifiManager(QObject *parent) : QObject(parent)
{
    connect(&m_poll, &QTimer::timeout, this, [this] { scan(false); });
    m_poll.start(10000);
    scan(false);
}

void WifiManager::run(const QStringList &args, std::function<void(bool, QByteArray)> done)
{
    auto *process = new QProcess(this);
    auto environment = QProcessEnvironment::systemEnvironment();
    environment.insert(QStringLiteral("LC_ALL"), QStringLiteral("C"));
    process->setProcessEnvironment(environment);
    auto *timeout = new QTimer(process);
    timeout->setSingleShot(true);
    auto timedOut = std::make_shared<bool>(false);
    connect(timeout, &QTimer::timeout, process, [process, timedOut] {
        *timedOut = true;
        process->kill();
    });
    // Both failed startup and normal completion pass through a single callback.
    auto completed = std::make_shared<bool>(false);
    auto complete = [this, process, completed, timedOut, done](bool success) {
        if (*completed) return;
        *completed = true;
        QByteArray output = process->readAllStandardOutput();
        if (!success) {
            if (*timedOut)
                output = tr("Tempo di attesa di nmcli scaduto.").toUtf8();
            else if (process->error() == QProcess::FailedToStart)
                output = tr("Impossibile avviare nmcli: %1").arg(process->errorString()).toUtf8();
            else {
                output = process->readAllStandardError().trimmed();
                if (output.isEmpty())
                    output = tr("nmcli terminato con codice %1.").arg(process->exitCode()).toUtf8();
            }
        }
        done(success, output);
        process->deleteLater();
    };
    connect(process, &QProcess::finished, this, [complete](int code, QProcess::ExitStatus status) {
        complete(code == 0 && status == QProcess::NormalExit);
    });
    connect(process, &QProcess::errorOccurred, this, [complete](QProcess::ProcessError error) {
        if (error == QProcess::FailedToStart) complete(false);
    });
    process->start(QStringLiteral("nmcli"), args);
    timeout->start(40000);
}

void WifiManager::scan(bool rescan)
{
    if (m_scanning || m_connecting) return;
    m_scanning = true;
    emit changed();
    run({"--terse", "--escape", "yes", "--fields", "IN-USE,SSID,SECURITY,SIGNAL", "device", "wifi", "list", "--rescan", rescan ? "yes" : "no"},
        [this](bool success, const QByteArray &output) {
        m_scanning = false;
        m_error = success ? QString() : tr("Scansione non disponibile: %1").arg(QString::fromUtf8(output));
        if (success) {
            m_networks.clear();
            for (const QString &line : QString::fromUtf8(output).split(u'\n', Qt::SkipEmptyParts)) {
                const auto values = fields(line);
                if (values.size() != 4 || values[1].isEmpty()) continue;
                const bool connected = values[0] == "*";
                int existing = -1;
                for (int i = 0; i < m_networks.size(); ++i)
                    if (m_networks[i].toMap()["ssid"] == values[1]) { existing = i; break; }
                QVariantMap network{{"ssid", values[1]}, {"security", values[2]},
                                    {"signal", values[3].toInt()}, {"connected", connected}};
                if (existing < 0) m_networks << network;
                else if (connected || (!m_networks[existing].toMap()["connected"].toBool()
                         && values[3].toInt() > m_networks[existing].toMap()["signal"].toInt()))
                    m_networks[existing] = network;
            }
        } else m_networks.clear();
        if (success && m_networks.isEmpty()) {
            m_scanning = true;
            run({"radio", "wifi"}, [this](bool radioSuccess, const QByteArray &radio) {
                m_scanning = false;
                if (radioSuccess && radio.trimmed() == "disabled")
                    m_error = tr("La radio Wi-Fi è disabilitata. Abilitarla sul dispositivo con: nmcli radio wifi on");
                emit changed();
            });
            return;
        }
        emit changed();
    });
}

void WifiManager::connectNetwork(const QString &ssid, const QString &security, const QString &password)
{
    if (m_connecting || m_scanning) return;
    m_error.clear();
    if (ssid.isEmpty() || !QStringList{"open", "wep", "wpa-psk", "sae"}.contains(security)
        || password.contains(u'\n') || password.contains(u'\r')) {
        m_error = tr("Rete o credenziali non valide.");
    } else if (security == "wpa-psk" && !((password.size() >= 8 && password.size() <= 63)
               || QRegularExpression("^[0-9a-fA-F]{64}$").match(password).hasMatch())) {
        m_error = tr("WPA/WPA2 richiede 8–63 caratteri oppure 64 cifre esadecimali.");
    } else if (security == "sae" && password.isEmpty()) {
        m_error = tr("Inserire la password WPA3.");
    } else if (security == "wep" && !(password.toUtf8().size() == 5 || password.toUtf8().size() == 13
               || QRegularExpression("^([0-9a-fA-F]{10}|[0-9a-fA-F]{26})$").match(password).hasMatch())) {
        m_error = tr("WEP richiede 5 o 13 byte oppure 10 o 26 cifre esadecimali.");
    }
    if (!m_error.isEmpty()) { emit changed(); return; }
    m_secret = std::make_unique<QTemporaryFile>();
    if (!m_secret->open()) {
        m_error = tr("Impossibile preparare le credenziali Wi-Fi.");
        emit changed(); return;
    }
    if (security != "open") {
        const QByteArray key = security == "wep" ? "wep-key0" : "psk";
        m_secret->write("802-11-wireless-security." + key + ":" + password.toUtf8() + "\n");
        m_secret->flush();
    }
    m_connecting = true;
    m_attempt = 0;
    m_profile = QUuid::createUuid().toString(QUuid::WithoutBraces);
    emit changed();
    QStringList args{"connection", "add", "type", "wifi", "ifname", "*", "con-name", "Dashboard Wi-Fi " + ssid,
                     "connection.uuid", m_profile, "ssid", ssid, "connection.autoconnect", "no"};
    if (security != "open") {
        args << "wifi-sec.key-mgmt" << (security == "wep" ? "none" : security)
             << (security == "wep" ? "wifi-sec.wep-key-flags" : "wifi-sec.psk-flags") << "2";
        if (security == "wep") args << "wifi-sec.wep-key-type" << "1";
    }
    run(args, [this](bool success, const QByteArray &output) {
        if (success) activate();
        else {
            m_error = tr("Impossibile creare il profilo Wi-Fi: %1").arg(QString::fromUtf8(output));
            finish(false);
        }
    });
}

void WifiManager::activate()
{
    ++m_attempt;
    emit changed();
    run({"--wait", "30", "connection", "up", "uuid", m_profile, "passwd-file", m_secret->fileName()},
        [this](bool success, const QByteArray &output) {
        if (success) finish(true);
        else if (m_attempt < 3) QTimer::singleShot(1000, this, &WifiManager::activate);
        else {
            m_error = tr("Connessione non riuscita dopo tre tentativi: %1").arg(QString::fromUtf8(output));
            finish(false);
        }
    });
}

void WifiManager::finish(bool success)
{
    m_secret.reset();
    auto complete = [this, success](bool, const QByteArray &) {
        m_connecting = false;
        emit changed();
        if (!success) emit connectionFailed(m_error);
        scan(false);
    };
    // Failed profiles cannot reconnect in the background. Successful profiles
    // remain available for this session; secrets are never saved by the client.
    if (!success) run({"connection", "delete", "uuid", m_profile}, complete);
    else complete(true, {});
}
