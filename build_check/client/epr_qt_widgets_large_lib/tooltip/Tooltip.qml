import QtQuick 2.15
import QtQuick.Shapes
import "../"
import "../colors"
import "../fonts"
import "../spacing"


Item {
    id: root

    width: container.width + (shapeLeft.width * shapeLeft.visible) + (shapeRight.width * shapeRight.visible)
    height: container.height + (shapeBottom.width * shapeBottom.visible) + (shapeTop.width * shapeTop.visible)

    enum Direction{
        Left,
        Right,
        Top,
        Bottom
    }

    property int direction: Tooltip.Direction.Right
    property alias label: label.text

    Rectangle{
        id: container
        width: ScalingUtility.getScaledValue(224)
        height: label.height
        radius: ScalingUtility.getScaledValue(Spacing.space2)
        color: ColorSemantic.contentDefault
        anchors.right: (direction === Tooltip.Direction.Left) ? parent.right : undefined
        anchors.top: (direction === Tooltip.Direction.Bottom) ? parent.top : undefined
        anchors.bottom: (direction === Tooltip.Direction.Top) ? parent.bottom : undefined

        Text{
            id: label
            width: parent.width
            padding: ScalingUtility.getScaledValue(Spacing.space3)
            font: FontStyle.sRegular
            lineHeight: FontStyle.sLineHeigth
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.contentInverse
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            maximumLineCount: 3
            elide: Text.ElideRight
            text: "Label"
        }
    }


    Shape{
        id: shapeRight
        width: ScalingUtility.getScaledValue(18)
        height: ScalingUtility.getScaledValue(21)

        anchors.left:  container.right
        anchors.verticalCenter: container.verticalCenter
        visible: direction === Tooltip.Direction.Right
        layer.enabled: true
        layer.samples: 4

        ShapePath{

            startX: 0
            startY: 0
            fillColor: container.color
            strokeColor: "transparent"
            PathLine{ x:ScalingUtility.getScaledValue(15.04) ; y:ScalingUtility.getScaledValue(8.77)}
            PathArc{ x:ScalingUtility.getScaledValue(15.04); y:ScalingUtility.getScaledValue(12.23) ; radiusX: ScalingUtility.getScaledValue(1); radiusY: ScalingUtility.getScaledValue(1.73) }
            PathLine{ x:0; y:ScalingUtility.getScaledValue(21) }
            PathLine{ x:0; y:0 }
        }
    }

    Shape{
        id: shapeLeft
        width: ScalingUtility.getScaledValue(18)
        height: ScalingUtility.getScaledValue(21)

        anchors.right:  container.left
        anchors.verticalCenter: container.verticalCenter
        visible: direction === Tooltip.Direction.Left
        layer.enabled: true
        layer.samples: 4

        ShapePath{

            startX: ScalingUtility.getScaledValue(18)
            startY: 0
            fillColor: container.color
            strokeColor: "transparent"
            PathLine{ x:ScalingUtility.getScaledValue(2.96) ; y:ScalingUtility.getScaledValue(8.77)}
            PathArc{ x:ScalingUtility.getScaledValue(2.96); y:ScalingUtility.getScaledValue(12.23) ; radiusX: ScalingUtility.getScaledValue(1); radiusY: ScalingUtility.getScaledValue(1.73); direction: PathArc.Counterclockwise }
            PathLine{ x:ScalingUtility.getScaledValue(18); y:ScalingUtility.getScaledValue(21) }
            PathLine{ x:ScalingUtility.getScaledValue(18); y:0 }
        }
    }

    Shape{
        id: shapeBottom
        width: ScalingUtility.getScaledValue(21)
        height: ScalingUtility.getScaledValue(18)

        anchors.top:  container.bottom

        anchors.horizontalCenter: container.horizontalCenter
        visible: direction === Tooltip.Direction.Bottom
        layer.enabled: true
        layer.samples: 4

        ShapePath{

            startX: 0
            startY: 0
            fillColor: container.color
            strokeColor: "transparent"

            PathLine{ x:ScalingUtility.getScaledValue(8.77) ; y:ScalingUtility.getScaledValue(15.04)}
            PathArc{ x:ScalingUtility.getScaledValue(12.23); y:ScalingUtility.getScaledValue(15.04) ; radiusX: ScalingUtility.getScaledValue(1.73); radiusY: ScalingUtility.getScaledValue(1); direction: PathArc.Counterclockwise }
            PathLine{ x:ScalingUtility.getScaledValue(21); y:0 }
            PathLine{ x:0; y:0 }
        }
    }

    Shape{
        id: shapeTop
        width: ScalingUtility.getScaledValue(21)
        height: ScalingUtility.getScaledValue(18)

        anchors.bottom:  container.top

        anchors.horizontalCenter: container.horizontalCenter
        visible: direction === Tooltip.Direction.Top
        layer.enabled: true
        layer.samples: 4

        ShapePath{

            startX: 0
            startY: ScalingUtility.getScaledValue(18)
            fillColor: container.color
            strokeColor: "transparent"

            PathLine{ x:ScalingUtility.getScaledValue(8.77) ; y:ScalingUtility.getScaledValue(2.94)}
            PathArc{ x:ScalingUtility.getScaledValue(12.23); y:ScalingUtility.getScaledValue(2.94) ; radiusX: ScalingUtility.getScaledValue(1.73); radiusY: ScalingUtility.getScaledValue(1) }
            PathLine{ x:ScalingUtility.getScaledValue(21); y:ScalingUtility.getScaledValue(18) }
            PathLine{ x:0; y:ScalingUtility.getScaledValue(18) }
        }
    }

}
