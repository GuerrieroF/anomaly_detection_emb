import QtQuick 2.15
import "../"
import "../colors"
import "../spacing"


Item{
    id: control
    width: ScalingUtility.getScaledValue(52)
    height: ScalingUtility.getScaledValue(32)

    property bool active: false
    property bool disabled: false
    property alias animationEnabled: behaviour.enabled
    property alias animationDuration: animation.duration
    property alias animationEasingType: animation.easing.type

    readonly property color switchColor: control.disabled ? ColorSemantic.contentDisabled : (control.active ? ColorSemantic.contentSelected : ColorSemantic.contentDefault)

    Rectangle {
        width: ScalingUtility.getScaledValue(44)
        height: ScalingUtility.getScaledValue(24)
        anchors.centerIn: parent

        color: "transparent"
        border.color: control.switchColor
        border.width: ScalingUtility.getScaledValue(2)
        radius: ScalingUtility.getScaledValue(3)

        Rectangle{
            width: ScalingUtility.getScaledValue(14)
            height: ScalingUtility.getScaledValue(14)
            anchors.verticalCenter: parent.verticalCenter
            x: control.active ? ScalingUtility.getScaledValue(25) : ScalingUtility.getScaledValue(5)
            Behavior on x {
                id: behaviour
                enabled: false
                NumberAnimation {
                    id:animation
                    duration: 200
                    easing.type: Easing.OutExpo
                }
            }

            color: control.switchColor
            radius: ScalingUtility.getScaledValue(Spacing.space025)
        }
    }
}

