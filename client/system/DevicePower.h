#pragma once

#include <QObject>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusError>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>

class DevicePower : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool pending READ pending NOTIFY pendingChanged)

public:
    explicit DevicePower(QObject *parent = nullptr) : QObject(parent) {}
    bool pending() const { return m_pending; }

    Q_INVOKABLE void powerOff()
    {
        if (m_pending)
            return;
        m_pending = true;
        emit pendingChanged();
        auto message = QDBusMessage::createMethodCall(
            QStringLiteral("org.freedesktop.login1"), QStringLiteral("/org/freedesktop/login1"),
            QStringLiteral("org.freedesktop.login1.Manager"), QStringLiteral("PowerOff"));
        message << true;
        auto *watcher = new QDBusPendingCallWatcher(
            QDBusConnection::systemBus().asyncCall(message), this);
        connect(watcher, &QDBusPendingCallWatcher::finished, this,
                [this](QDBusPendingCallWatcher *finished) {
            const QDBusPendingReply<> reply = *finished;
            m_pending = false;
            emit pendingChanged();
            if (reply.isError()) {
                const auto error = reply.error();
                if (error.type() == QDBusError::AccessDenied ||
                    error.name() == QStringLiteral("org.freedesktop.DBus.Error.InteractiveAuthorizationRequired")) {
                    emit failed(tr("L'utente del client non è autorizzato a spegnere il dispositivo. "
                                   "Installare la policy di spegnimento descritta nel README e riavviare la sessione.\n\n%1")
                                    .arg(error.message()));
                } else {
                    emit failed(error.message());
                }
            }
            finished->deleteLater();
        });
    }

signals:
    void pendingChanged();
    void failed(const QString &message);

private:
    bool m_pending = false;
};
