import QtQuick
import Qt.labs.qmlmodels 1.0
import epr_qt_widgets_large_lib 1.0
Item {
    id: root
    implicitWidth: ScalingUtility.getScaledValue(700)
    height: navigationListItem.height + (listItems.visible * (listItems.height + listItems.anchors.topMargin))
    property alias label: navigationListItem.label
    property alias state: root.state
    property alias listModel: repeaterList.model
    property alias maximumLines: navigationListItem.maximumLines


    states: [
        State{
            name: "open"
            PropertyChanges { target: listItems; visible: true}
        },
        State{
            name: "close"
            PropertyChanges { target: listItems; visible: false}
        }
    ]

    Component.onCompleted: {
        root.state = "close"
    }

    NavigationListItem{
        id:navigationListItem
        width: root.width
        defaultIcon: (root.state === "open") ? "../images/caret_up.png" : "../images/caret_down.png"
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        onToggled: {
            if(root.state === "close"){
                defaultIcon = "../images/caret_up.png"
                root.state = "open"
            }else{
                defaultIcon = "../images/caret_down.png"
                root.state = "close"
            }
        }
    }
    Column{
        id: listItems
        anchors{
            top: navigationListItem.bottom
            topMargin: ScalingUtility.getScaledValue(Spacing.space2)
            right: parent.right
        }
        spacing: ScalingUtility.getScaledValue(Spacing.space2)
        Repeater{
            id: repeaterList
            delegate: delegateChooser
            model: listModel
        }
    }
    DelegateChooser{
        id: delegateChooser
        role: "type"
        DelegateChoice{
            roleValue: "toggleListItem";
            ToggleListItem{
                id: toggleListItem
                label: qsTrId((model.label === undefined) ? toggleListItem.label : model.label)
                active: (model.active === undefined) ? toggleListItem.active : model.active
                disabled: (model.disabled === undefined) ? toggleListItem.disabled : model.disabled
                width: (model.width === undefined) ? toggleListItem.width : model.width
                onToggled: active = !active
            }
        }
        DelegateChoice{
            roleValue: "parametersListItem";
            ParametersListItem{
                id: parametersListItem
                readOnly: (model.isReadOnly === undefined) ? parametersListItem.readOnly : model.isReadOnly
                label: qsTrId((model.label === undefined) ? parametersListItem.label : model.label)
                value:(model.value === undefined) ? parametersListItem.value : model.value
                active: (model.active === undefined) ? parametersListItem.active : model.active
                disabled: (model.disabled === undefined) ? parametersListItem.disabled : model.disabled
                width: (model.width === undefined) ? parametersListItem.width : model.width
                onToggled: {
                    active = !active
                }
            }
        }
        DelegateChoice{
            roleValue: "manualTestListItem"
            ManualTestListItem{
                id: manualTestListItem
                width: (model.width === undefined) ? manualTestListItem.width : model.width
                disabled: (model.disabled === undefined) ? manualTestListItem.disabled : model.disabled
                active: (model.active === undefined) ? manualTestListItem.active : model.active
                toggleLabel: qsTrId((model.toggleLabel === undefined) ? manualTestListItem.toggleLabel : model.toggleLabel)
                parameterLabel: qsTrId((model.parameterLabel === undefined) ? manualTestListItem.parameterLabel : model.parameterLabel)
                parameterValue: (model.parameterValue === undefined) ? manualTestListItem.parameterValue :  model.parameterValue
                minMaxValue:(model.minMaxValue === undefined) ? manualTestListItem.minMaxValue : model.minMaxValue
                onToggled: {
                    active = !active
                }
            }
        }
        DelegateChoice{
            roleValue: "dataMonitorListItem"
            DataMonitorListItem{
                id: dataMonitorListItem
                width: (model.width === undefined) ? dataMonitorListItem.width : model.width
                label: qsTrId((model.label === undefined) ? dataMonitorListItem.label : model.label)
                value: (model.value === undefined) ? dataMonitorListItem.value : model.value
                minMaxValue: (model.minMaxValue === undefined) ? dataMonitorListItem.minMaxValue : model.minMaxValue
                active: (model.active === undefined) ? dataMonitorListItem.active : model.active
                onClicked: {
                    active = !active
                }
            }
        }
        DelegateChoice{
            roleValue: "countersListItem"
            CountersListItem{
                id: countersListItem
                width: (model.width === undefined) ? countersListItem.width : model.width
                label: qsTrId((model.label === undefined) ? countersListItem.label : model.label)
                value1: (model.value1 === undefined) ? countersListItem.value1 : model.value1
                dateValue1: (model.dateValue1 === undefined) ? countersListItem.dateValue1 : model.dateValue1
                showDateValue1: (model.showDateValue1 === undefined) ? countersListItem.showDateValue1 : model.showDateValue1
                value2: (model.value2 === undefined) ? countersListItem.value2 : model.value2
                showValue2: (model.showValue2 === undefined) ? countersListItem.showValue2 : model.showValue2
                dateValue2: (model.dateValue2 === undefined) ? countersListItem.dateValue2 : model.dateValue2
                showDateValue2: (model.showDateValue2 === undefined) ? countersListItem.showDateValue2 : model.showDateValue2
                showIcon: (model.showIcon === undefined) ? countersListItem.showIcon : model.showIcon
                onClicked: {

                }
            }
        }
    }
}
