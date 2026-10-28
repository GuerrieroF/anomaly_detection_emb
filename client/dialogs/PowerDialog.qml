import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0

DashboardDialog {
    id: root
    property string message: ""
    property bool confirmation: false
    property bool busy: false

    iconName: "power"
    iconColor: confirmation ? DashboardColors.warning : DashboardColors.danger

    contentItem: Item {
        implicitHeight: Math.max(100, messageLabel.implicitHeight)
        Label {
            id: messageLabel
            anchors.fill: parent
            text: root.message
            color: DashboardColors.textSecondary
            font.family: DashboardTypography.family
            font.pixelSize: 20
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
        }
    }
    footer: Item {
        implicitHeight: 96
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            spacing: 16
            DashboardButton {
                text: root.confirmation ? qsTr("Annulla") : qsTr("Chiudi")
                font.pixelSize: 20
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                onClicked: root.reject()
            }
            DashboardButton {
                visible: root.confirmation
                text: qsTr("Spegni")
                iconName: "power"
                iconSize: 28
                font.pixelSize: 20
                backgroundColor: DashboardColors.danger
                hoveredColor: Qt.lighter(DashboardColors.danger, 1.12)
                pressedColor: Qt.darker(DashboardColors.danger, 1.15)
                foregroundColor: DashboardColors.textPrimary
                enabled: !root.busy
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                onClicked: root.accept()
            }
        }
    }
}
