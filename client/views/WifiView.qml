import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0
import "../dialogs"

ColumnLayout {
    id: root
    required property var wifi
    spacing: DashboardSpacing.md
    onVisibleChanged: if (visible) wifi.scan()

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: qsTr("Wi-Fi")
            color: DashboardColors.textPrimary
            font.pixelSize: DashboardTypography.title
            font.bold: true
            Layout.fillWidth: true
        }
        DashboardButton {
            objectName: "refreshWifiButton"
            iconName: "refresh"
            iconSize: 32
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            toolTip: root.wifi.scanning ? qsTr("Scansione…") : qsTr("Aggiorna reti")
            enabled: !root.wifi.scanning && !root.wifi.connecting
            onClicked: root.wifi.scan()
        }
    }
    Label {
        Layout.fillWidth: true
        text: root.wifi.connecting ? qsTr("Connessione in corso · tentativo %1 di 3").arg(root.wifi.attempt)
                                  : root.wifi.error || (root.wifi.networks.length ? qsTr("Seleziona una rete per configurarla") : qsTr("Nessuna rete visibile"))
        color: root.wifi.error ? DashboardColors.warning : DashboardColors.textSecondary
        wrapMode: Text.Wrap
    }
    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 8
        model: root.wifi.networks
        ScrollBar.vertical: ScrollBar {}
        delegate: ItemDelegate {
            required property var modelData
            width: ListView.view.width
            height: 72
            leftPadding: 24
            rightPadding: 24
            enabled: !root.wifi.connecting && !root.wifi.scanning
            background: Rectangle {
                radius: 8
                color: modelData.connected ? Qt.darker(DashboardColors.accent, 2.5) : DashboardColors.surface
                border.color: modelData.connected ? DashboardColors.accent : DashboardColors.borderStrong
            }
            contentItem: RowLayout {
                spacing: 24
                IconGlyph { Layout.preferredWidth: 32; Layout.preferredHeight: 32; name: "wifi"; signalBars: modelData.signal < 34 ? 1 : modelData.signal < 67 ? 2 : 3 }
                Label { text: modelData.ssid; color: DashboardColors.textPrimary; Layout.fillWidth: true; elide: Text.ElideRight; font.pixelSize: 20 }
                Label { text: modelData.connected ? qsTr("Connesso") : modelData.security || qsTr("Aperta"); color: modelData.connected ? DashboardColors.accent : DashboardColors.textSecondary }
                IconGlyph { name: "chevron-left"; strokeColor: DashboardColors.textSecondary; Layout.preferredWidth: 24; Layout.preferredHeight: 24 }
            }
            onClicked: {
                credentials.ssid = modelData.ssid
                var security = modelData.security
                encryption.currentIndex = security.indexOf("WPA3") >= 0 ? 3 : security.indexOf("WPA") >= 0 ? 2 : security.indexOf("WEP") >= 0 ? 1 : 0
                password.clear()
                credentials.open()
            }
        }
    }
    DashboardDialog {
        id: credentials
        property string ssid: ""
        contentHeight: encryptionLabel.implicitHeight + 56 + credentialsNote.implicitHeight + 24
                       + (encryption.currentIndex !== 0 ? passwordLabel.implicitHeight + 56 + 24 : 0)
        title: qsTr("Connetti a %1").arg(ssid)
        footer: Item {
            implicitHeight: 96
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 32
                anchors.rightMargin: 32
                spacing: 16
                DashboardButton {
                    text: qsTr("Annulla")
                    font.pixelSize: 20
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    onClicked: credentials.reject()
                }
                DashboardButton {
                    text: qsTr("Connetti")
                    iconName: "wifi"
                    font.pixelSize: 20
                    selected: true
                    enabled: !root.wifi.connecting && !root.wifi.scanning
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    onClicked: {
                        root.wifi.connectNetwork(credentials.ssid, ["open", "wep", "wpa-psk", "sae"][encryption.currentIndex], password.text)
                        credentials.close()
                    }
                }
            }
        }

        onClosed: password.clear()
        contentItem: ColumnLayout {
            spacing: 12
            Label { id: encryptionLabel; text: qsTr("Crittografia"); color: DashboardColors.textSecondary; font.pixelSize: 20; font.family: DashboardTypography.family }
            ComboBox {
                id: encryption
                Layout.fillWidth: true
                implicitHeight: 56
                font.family: DashboardTypography.family
                font.pixelSize: 20
                leftPadding: 16
                rightPadding: 40
                background: Rectangle {
                    color: DashboardColors.surfaceMuted
                    radius: DashboardSpacing.radiusMd
                    border.color: encryption.activeFocus ? DashboardColors.accent : DashboardColors.borderStrong
                }
                contentItem: Text {
                    text: encryption.displayText
                    font: encryption.font
                    color: DashboardColors.textPrimary
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                indicator: IconGlyph {
                    x: encryption.width - width - 16
                    y: (encryption.height - height) / 2
                    name: "chevron-left"
                    rotation: -90
                    strokeColor: DashboardColors.textSecondary
                }
                delegate: ItemDelegate {
                    required property int index
                    required property string modelData
                    width: encryption.width
                    height: 56
                    highlighted: encryption.highlightedIndex === index
                    contentItem: Text {
                        text: modelData
                        font: encryption.font
                        color: DashboardColors.textPrimary
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.highlighted ? DashboardColors.accentMuted : DashboardColors.surface
                    }
                }
                popup: Popup {
                    y: encryption.height + 4
                    width: encryption.width
                    padding: 4
                    implicitHeight: contentItem.implicitHeight + 8
                    background: Rectangle {
                        color: DashboardColors.surface
                        radius: DashboardSpacing.radiusMd
                        border.color: DashboardColors.borderStrong
                    }
                    contentItem: ListView {
                        implicitHeight: contentHeight
                        model: encryption.popup.visible ? encryption.delegateModel : null
                        currentIndex: encryption.highlightedIndex
                        clip: true
                    }
                }
                model: [qsTr("Nessuna (rete aperta)"), "WEP", "WPA / WPA2 Personal", "WPA3 Personal"]
            }
            Label { id: passwordLabel; color: DashboardColors.textSecondary; font.pixelSize: 20; font.family: DashboardTypography.family; text: qsTr("Password"); visible: encryption.currentIndex !== 0 }
            TextField {
                id: password
                readOnly: true
                TapHandler {
                    onTapped: {
                        passwordEditor.value = password.text
                        passwordEditor.open()
                    }
                }
                Keys.onReturnPressed: {
                    passwordEditor.value = password.text
                    passwordEditor.open()
                }
                Layout.fillWidth: true
                visible: encryption.currentIndex !== 0
                implicitHeight: 56
                font.family: DashboardTypography.family
                font.pixelSize: 20
                color: DashboardColors.textPrimary
                placeholderTextColor: DashboardColors.textSecondary
                leftPadding: 16
                rightPadding: 16
                background: Rectangle {
                    color: DashboardColors.surfaceMuted
                    radius: DashboardSpacing.radiusMd
                    border.color: password.activeFocus ? DashboardColors.accent : DashboardColors.borderStrong
                }
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                placeholderText: qsTr("Inserisci la password")
            }
            Label {
                id: credentialsNote
                Layout.fillWidth: true
                color: DashboardColors.textSecondary
                font.family: DashboardTypography.family
                font.pixelSize: 16
                text: qsTr("Le reti Enterprise (802.1X) richiedono una configurazione di sistema. Le credenziali valgono per questa sessione.")
                wrapMode: Text.Wrap
            }
        }
    }
    DashboardDialog {
        id: warning
        iconColor: DashboardColors.warning
        property string message: ""
        title: qsTr("Attenzione · connessione Wi-Fi non riuscita")
        contentItem: Label {
            text: warning.message
            color: DashboardColors.textSecondary
            font.family: DashboardTypography.family
            font.pixelSize: 20
            wrapMode: Text.Wrap
        }
        footer: Item {
            implicitHeight: 96
            DashboardButton {
                anchors.fill: parent
                anchors.leftMargin: 32
                anchors.rightMargin: 32
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                text: qsTr("Chiudi")
                font.pixelSize: 20
                onClicked: warning.accept()
            }
        }
    }
    PasswordDialog {
        id: passwordEditor
        onPasswordConfirmed: function(value) { password.text = value }
    }
    Connections {
        target: root.wifi
        function onConnectionFailed(message) {
            warning.message = message
            warning.open()
        }
    }
}
