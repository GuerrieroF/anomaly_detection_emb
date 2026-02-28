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

    enum Type {
        CloseMenu,
        Back,
        TitleOnly
    }

    property alias showShadow: shadowRect.visible
    property int type: SidebarTop.Type.CloseMenu
    property alias title: title.text

    signal clicked()

    readonly property alias shadowHeight: shadowRect.height
    readonly property int paddingLeft: ScalingUtility.getScaledValue((root.type === SidebarTop.Type.TitleOnly) ? Spacing.space6 : Spacing.space4)
    readonly property int paddingRight: ScalingUtility.getScaledValue(Spacing.space6)
    readonly property int spacing: ScalingUtility.getScaledValue(Spacing.space2)

    Rectangle {
        id: fillRect
        height: ScalingUtility.getScaledValue(80)
        width: parent.width

        color: ColorSemantic.layerVariant1BackgroundDefault

        IconButton{
            id: closeIcon
            visible: root.type === SidebarTop.Type.CloseMenu
            anchors{
                left: parent.left
                leftMargin: root.paddingLeft
                verticalCenter: parent.verticalCenter
            }

            size: IconButton.Size.Medium
            defaultIcon: "../images/close.png"
            onClicked: root.clicked()
        }

        Image {
            id: backIcon
            source: "../images/caret_left_small.png"
            visible: root.type === SidebarTop.Type.Back
            anchors{
                left: parent.left
                leftMargin: root.paddingLeft
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: title
            visible: root.type === SidebarTop.Type.Back || root.type === SidebarTop.Type.TitleOnly
            anchors{
                left: backIcon.visible ? backIcon.right : parent.left
                leftMargin: backIcon.visible ? root.spacing : root.paddingLeft
                right: parent.right
                rightMargin: root.paddingRight
                verticalCenter: parent.verticalCenter
            }

            text: root.type === SidebarTop.Type.Back ? "Parent title" : "Section title"
            font: FontStyle.sSemibold
            lineHeight: FontStyle.sLineHeigth
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.contentDefault
            maximumLineCount: 1
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }

        MouseArea {
            height: ScalingUtility.getScaledValue(50)
            width: (backIcon.visible * (backIcon.width + root.paddingLeft) ) + title.contentWidth
            visible: root.type === SidebarTop.Type.Back
            enabled: visible
            anchors{
                left: backIcon.visible ? backIcon.left : title.left
                verticalCenter: parent.verticalCenter
            }
            onClicked: root.clicked()
        }
    }

    Rectangle {
        id: shadowRect
        anchors.top: fillRect.bottom
        height: fillRect.height/2
        width: parent.width

        gradient: Gradient {
            GradientStop{position: 0.0; color: ColorSemantic.layerVariant1BackgroundDefault}
            GradientStop{position: 1.0; color: Qt.rgba(48, 48, 48, 0)}
        }
    }
}
