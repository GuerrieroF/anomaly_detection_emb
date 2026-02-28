import QtQuick 2.15
import "../"
import "../spacing"
import "../colors"
import "../fonts"

Item {
    id: container

    enum Size {
        Horizontal,
        Vertical
    }

    property int size: NumericKeyboard.Size.Horizontal
    property bool showSigns: false

    property bool isPowerLevel: false

    readonly property bool isHorizontal: container.size === NumericKeyboard.Size.Horizontal

    readonly property int cellWidth: ScalingUtility.getScaledValue(isHorizontal ? 50 : 80)
    readonly property int cellHeight: ScalingUtility.getScaledValue(80)
    readonly property bool isVerticalOnlyLevel: !isHorizontal && isPowerLevel && !showSigns

    readonly property var verticalList: [
        { value: "1" },
        { value: "2" },
        { value: "3" },
        { value: "4" },
        { value: "5" },
        { value: "6" },
        { value: "7" },
        { value: "8" },
        { value: "9" },
        { value: showSigns ? "+" : "" },
        { value: isPowerLevel ? "" : "0" },
        { value: showSigns ? "-" : "" }
    ]

    readonly property var horizontalList: [
        { value: "1" },
        { value: "2" },
        { value: "3" },
        { value: "4" },
        { value: "5" },
        { value: "6" },
        { value: "7" },
        { value: "8" },
        { value: "9" },
        { value: isPowerLevel ? "" : "0" },
        { value: showSigns ? "+" : "" },
        { value: showSigns ? "-" : "" }
    ]

    signal numberClicked(string numberString)
    signal plusClicked()
    signal minusClicked()

    width: ScalingUtility.getScaledValue(isHorizontal ? 386 : 336)
    height: grid.height

    Grid {
        id: grid
        readonly property int rowsCount: Math.floor(repeater.count / columns) - (isVerticalOnlyLevel ? 1 : 0)
        width: parent.width
        height: (rowsCount * cellHeight) + ((rowsCount-1) * rowSpacing)

        columns: isHorizontal ? 5 : 3
        columnSpacing: ScalingUtility.getScaledValue( isHorizontal ? 34 : Spacing.space12 )
        rowSpacing: ScalingUtility.getScaledValue( isHorizontal ? 1 : 0 )

        Repeater {
            id: repeater
            model: isHorizontal ? horizontalList : verticalList

            delegate: Item {

                width: cellWidth
                height: cellHeight

                Text {
                    anchors.centerIn: parent

                    color: ColorSemantic.contentDefault

                    font: FontStyle.xxlRegular

                    text: modelData.value
                }

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    enabled: modelData.value !== ""

                    onReleased: {
                        switch (model.index) {
                        case 9:
                            isHorizontal ? numberClicked(modelData.value) : plusClicked()
                            break

                        case 10:
                            isHorizontal ? plusClicked() : numberClicked(modelData.value)
                            break

                        case 11:
                            minusClicked()
                            break

                        default:
                            return numberClicked(modelData.value)
                        }
                    }
                }
            }
        }
    }
}
