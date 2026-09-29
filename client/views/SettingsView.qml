import QtQuick
import QtQuick.Layouts
import Dashboard.Ui 1.0

ColumnLayout {
    spacing: DashboardSpacing.lg

    Text {
        Layout.fillWidth: true
        text: qsTr("Impostazioni")
        color: DashboardColors.textPrimary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.title
        font.bold: true
    }

    Text {
        Layout.fillWidth: true
        text: qsTr("Pagina provvisoria · Configurazione dei sensori in preparazione")
        color: DashboardColors.textSecondary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.body
        wrapMode: Text.WordWrap
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: DashboardSpacing.lg

        DashboardCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            title: qsTr("IMU")
            subtitle: qsTr("Impostazioni del sensore inerziale")

            Text {
                anchors.fill: parent
                text: qsTr("Qui saranno disponibili i parametri configurabili dell'IMU.")
                color: DashboardColors.textSecondary
                font.family: DashboardTypography.family
                font.pixelSize: DashboardTypography.body
                wrapMode: Text.WordWrap
            }
        }

        DashboardCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            title: qsTr("GPS")
            subtitle: qsTr("Impostazioni del ricevitore GPS")

            Text {
                anchors.fill: parent
                text: qsTr("Qui saranno disponibili i parametri configurabili del GPS.")
                color: DashboardColors.textSecondary
                font.family: DashboardTypography.family
                font.pixelSize: DashboardTypography.body
                wrapMode: Text.WordWrap
            }
        }
    }
}
