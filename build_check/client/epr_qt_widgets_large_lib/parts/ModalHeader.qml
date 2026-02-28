import QtQuick
import "../"
import "../spacing"
import "../colors"

CustomRoundedRectangle {
    id: container

    readonly property int topPad: Spacing.space6
    readonly property int bottomPad: topPad
    readonly property int leftPad: topPad
    readonly property int rightPad: topPad

    width: parent.width
    height: parent.height

    borderColor: ColorSemantic.strokeBorder
    backgroundColor: ColorSemantic.modalPopupHeaderBackground
    borderWidth: 1
    radius: Spacing.space2
    roundBottomLeft: false
    roundBottomRight: false
}
