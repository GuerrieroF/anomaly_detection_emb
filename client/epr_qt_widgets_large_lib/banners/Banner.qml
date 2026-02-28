import QtQuick 2.15
import "../parts"
import "../colors"
import "../spacing"
import "../fonts"
import "../buttons"
import "../"

CustomRoundedRectangle{
    id: root

    enum Type {
        Sticky,
        Floating
    }

    property alias message: textMetric.text
    property alias messageTextColor: message.color
    property alias showCloseIcon: closeIcon.visible
    property alias showButton: button.visible
    property alias buttonText: buttonText.text

    property alias buttonColor: button.color
    property alias buttonTextColor: buttonText.color

    property int type: Banner.Type.Sticky

    property int maxStickyWidth: ScalingUtility.getScaledValue(700)

    property alias iconVisible: icon.visible
    property bool isDark: false
    property alias iconSource: icon.source

    signal close()
    signal buttonClicked()

    height: ScalingUtility.getScaledValue(84)

    roundTopLeft: type === Banner.Type.Floating
    roundTopRight: roundTopLeft

    radius: ScalingUtility.getScaledValue(Spacing.space2)
    width: row.width

    backgroundColor: (isDark) ?  ColorSemantic.layerVariant1BackgroundDefault :  ColorSemantic.contentDefault

    Row {
        id:row
        spacing: ScalingUtility.getScaledValue(Spacing.space6)
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: leftPadding
        topPadding: ScalingUtility.getScaledValue(Spacing.space3)
        bottomPadding: topPadding
        anchors.verticalCenter: root.verticalCenter
        width: rowButtonText.width + leftPadding + rightPadding + (closeIcon.width + spacing) * closeIcon.visible + (button.width + spacing) * button.visible

        Row{
            id:rowButtonText
            spacing: ScalingUtility.getScaledValue(Spacing.space4)
            anchors.verticalCenter: row.verticalCenter
            width: message.width + ((root.iconVisible) ? (icon.width + spacing) : 0)
            Image{
                id: icon
                width: ScalingUtility.getScaledValue(48)
                height: ScalingUtility.getScaledValue(48)
                anchors.verticalCenter: parent.verticalCenter
                source: (isDark) ? "../images/placeholder_white_large.png" : "../images/placeholder_black_large.png"
                visible: false
            }

            Text {
                id: message
                text:  textMetric.text
                color:  (isDark) ? ColorSemantic.contentDefault : ColorSemantic.pillBackgroundDefault
                font: FontStyle.mRegular
                lineHeight: FontStyle.mLineHeigth
                lineHeightMode: Text.FixedHeight
                anchors.verticalCenter: parent.verticalCenter
                width: textMetric.advanceWidth > textMetric.elideWidth ? textMetric.elideWidth : textMetric.advanceWidth
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }

        Rectangle {
            id:button
            color: (isDark) ? ColorSemantic.buttonPrimaryBackgroundDefault :  ColorSemantic.contentInverse
            width: buttonText.width + (Spacing.space2 * 2)
            height: buttonText.height + (Spacing.space1 * 2)
            anchors.verticalCenter: parent.verticalCenter
            radius: Spacing.space2
            visible: false

            Text {
                id: buttonText
                text: "BUTTON"
                font: FontStyle.mRegular
                lineHeight: FontStyle.mLineHeigth
                lineHeightMode: Text.FixedHeight
                anchors.centerIn: parent
                color: (isDark) ? ColorSemantic.contentInverse : ColorSemantic.contentDefault
            }

            MouseArea {
                id: mouseAreaButton
                anchors.fill: parent
                onClicked: root.buttonClicked()
            }
        }

        IconButton{
            id: closeIcon
            size: IconButton.Size.Large
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            defaultIcon: (isDark) ? "../images/close_circle_white.png"  : "../images/close_circle.png"
            onClicked: root.close()
        }

        TextMetrics {
            id: textMetric
            elideWidth: (type === Banner.Type.Floating) ?
                        (root.width - (icon.width + rowButtonText.spacing) * root.iconVisible) - ((row.leftPadding + row.rightPadding + (closeIcon.width + row.spacing) * closeIcon.visible + (button.width + row.spacing) * button.visible)) :
                        (root.maxStickyWidth - (icon.width + rowButtonText.spacing) * root.iconVisible) - ((row.leftPadding + row.rightPadding + (closeIcon.width + row.spacing) * closeIcon.visible + (button.width + row.spacing) * button.visible))
            font: FontStyle.mRegular
            text: "Hello world, I’m a banner with a long string of text. The string of text is so long that needs to be truncated "
        }
    }
}
