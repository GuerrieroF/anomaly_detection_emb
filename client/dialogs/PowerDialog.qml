import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0

Dialog {
    id: root
    property string message: ""
    property bool confirmation: false
    property bool busy: false

    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(620, parent.width - 48)
    padding: 32
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape

    Overlay.modal: Rectangle {
        color: "#b3090c12"
    }
    background: Rectangle {
        color: DashboardColors.surface
        radius: DashboardSpacing.radiusMd * 2
        border.color: DashboardColors.borderStrong
    }
    header: Item {
        implicitHeight: 96
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            spacing: 16
            IconGlyph {
                name: "power"
                strokeColor: root.confirmation ? DashboardColors.warning : DashboardColors.danger
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
            }
            Label {
                text: root.title
                color: DashboardColors.textPrimary
                font.family: DashboardTypography.family
                font.pixelSize: 26
                font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
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
