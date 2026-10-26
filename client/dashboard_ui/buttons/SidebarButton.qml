import QtQuick
import Dashboard.Ui 1.0

DashboardButton {
    property string label: ""

    iconName: "home"
    iconSize: 32
    toolTip: label
}
