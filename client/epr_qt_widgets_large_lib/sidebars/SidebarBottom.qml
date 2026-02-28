import QtQuick
import "../"
import "../colors"
import "../buttons"
import "../spacing"
import "../fonts"

Item{
    id: root
    implicitWidth: ScalingUtility.getScaledValue(339)
    height: fillRect.height + shadowRect.height

    property alias showShadow: shadowRect.visible
    property alias title: title.text
    property alias icon: icon.source
    property alias showIcon: icon.visible

    readonly property alias shadowHeight: shadowRect.height

    signal clicked()

    Rectangle {
        id: shadowRect
        anchors.bottom: fillRect.top
        height: fillRect.height/2
        width: parent.width

        gradient: Gradient {
            GradientStop{position: 1.0; color: ColorSemantic.layerVariant1BackgroundDefault}
            GradientStop{position: 0.0; color: Qt.rgba(48, 48, 48, 0)}
        }
    }

    Rectangle {
        id: fillRect
        height: ScalingUtility.getScaledValue(80)
        width: parent.width
        anchors.bottom: parent.bottom

        color: ColorSemantic.layerVariant1BackgroundDefault

        Row{
            id:content
            width: parent.width
            height: parent.height
            spacing: ScalingUtility.getScaledValue(Spacing.space2)
            leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
            rightPadding: leftPadding

            Image {
                id: icon
                source: "../images/logout.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: title
                anchors.verticalCenter: parent.verticalCenter
                width: root.width - content.leftPadding - content.rightPadding - icon.visible * (icon.width + content.spacing)
                text: "Service logout"
                font: FontStyle.lRegular
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight
                color: ColorSemantic.contentDefault
                maximumLineCount: 1
                wrapMode: Text.Wrap
                elide: Text.ElideRight
            }
        }

        MouseArea {
            height: ScalingUtility.getScaledValue(50)
            width: (icon.visible * (icon.width + content.spacing) ) + title.contentWidth
            anchors{
                left: parent.left
                leftMargin: content.leftPadding
                verticalCenter: parent.verticalCenter
            }

            onClicked: root.clicked()
        }
    }
}
