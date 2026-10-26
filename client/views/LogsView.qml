import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0

ColumnLayout {
    id: root

    required property var telemetry
    readonly property var gpsFields: {
        var message = telemetry.gpsMessage || ""
        var rows = []
        var lines = message.split("\n")
        for (var i = 0; i < lines.length; ++i) {
            var separator = lines[i].indexOf(":")
            if (separator > 0)
                rows.push({ field: lines[i].slice(0, separator).trim(),
                            value: lines[i].slice(separator + 1).trim() })
        }
        return rows
    }
    spacing: DashboardSpacing.md

    Text {
        Layout.fillWidth: true
        text: qsTr("Log")
        color: DashboardColors.textPrimary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.title
        font.bold: true
    }

    Text {
        Layout.fillWidth: true
        text: !root.telemetry.serverAvailable ? qsTr("Server disconnesso · Ultimi valori ricevuti")
              : qsTr("Ultimi valori ricevuti · Aggiornamento in tempo reale")
        color: DashboardColors.textSecondary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.caption
        wrapMode: Text.WordWrap
    }

    DashboardCard {
        Layout.fillWidth: true
        Layout.fillHeight: true
        title: qsTr("GPS")

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 40
                color: DashboardColors.surfaceRaised

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: DashboardSpacing.md
                    anchors.rightMargin: DashboardSpacing.md
                    spacing: DashboardSpacing.md
                    Repeater {
                        model: [qsTr("Nome campo"), qsTr("Valore")]
                        Text {
                            required property string modelData
                            Layout.fillWidth: true
                            Layout.preferredWidth: 1
                            text: modelData
                            color: DashboardColors.textSecondary
                            font.family: DashboardTypography.family
                            font.pixelSize: DashboardTypography.caption
                            font.bold: true
                        }
                    }
                }
            }

            ListView {
                id: fieldsList
                objectName: "gpsFieldsTable"
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: root.gpsFields
                ScrollBar.vertical: ScrollBar {}

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    implicitHeight: Math.max(40, cells.implicitHeight + DashboardSpacing.md * 2)
                    color: index % 2 === 0 ? DashboardColors.surface : DashboardColors.surfaceMuted

                    RowLayout {
                        id: cells
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: DashboardSpacing.md
                        anchors.rightMargin: DashboardSpacing.md
                        spacing: DashboardSpacing.md

                        Text {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 1
                            text: modelData.field
                            textFormat: Text.PlainText
                            color: DashboardColors.textSecondary
                            font.family: DashboardTypography.family
                            font.pixelSize: DashboardTypography.caption
                            wrapMode: Text.WrapAnywhere
                        }

                        Text {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 1
                            text: modelData.value
                            textFormat: Text.PlainText
                            color: DashboardColors.textPrimary
                            font.family: DashboardTypography.family
                            font.pixelSize: DashboardTypography.caption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    width: parent.width
                    visible: fieldsList.count === 0
                    text: qsTr("In attesa di dati GPS…")
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    color: DashboardColors.textMuted
                    font.family: DashboardTypography.family
                    font.pixelSize: DashboardTypography.body
                }
            }
        }
    }
}
