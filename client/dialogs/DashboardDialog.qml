import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0

Dialog {
    id: root
    property string iconName: "wifi"
    property color iconColor: DashboardColors.accent

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
                name: root.iconName
                strokeColor: root.iconColor
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
}
