import QtQuick 2.15
import "../colors"
import "../fonts"
import "../spacing"
import "../"

Rectangle {
    id: container

    enum Type {
        Primary,
        Secondary,
        Danger
    }

    readonly property color primaryColor: enabled ? ColorSemantic.buttonPrimaryBackgroundDefault : ColorSemantic.buttonPrimaryBackgroundDisabled
    readonly property color secondaryColor: enabled ? ColorSemantic.buttonSecondaryBackgroundDefault : ColorSemantic.buttonSecondaryBackgroundDefault
    readonly property color dangerColor: enabled ? ColorSemantic.buttonDangerBackgroundDefault : ColorSemantic.buttonDangerBackgroundDisabled
    readonly property bool isPrimary: type === ButtonCentralLarge.Type.Primary
    readonly property bool isSecondary: type === ButtonCentralLarge.Type.Secondary
    readonly property real maxTextWidth: container.width - content.leftPadding - content.rightPadding - (icon.visible ? (content.spacing + icon.width) : 0)

    property int type: ButtonCentralLarge.Type.Primary
    property bool showIcon: true

    property alias icon: icon.source
    property alias label: labelMetric.text

    signal clicked()

    width: ScalingUtility.getScaledValue(352)
    height: ScalingUtility.getScaledValue(72)

    radius: ScalingUtility.getScaledValue(Spacing.space2)

    color: isPrimary
           ? primaryColor
           : (isSecondary
              ? secondaryColor
              : dangerColor)

    border.width: isSecondary ? 1 : 0
    border.color: isSecondary
                  ? (container.enabled
                     ? ColorSemantic.buttonSecondaryBorderDefault
                     : ColorSemantic.buttonSecondaryBorderDisabled)
                  : "transparent"

    Row {
        id: content
        anchors.centerIn: parent
        topPadding: 0
        bottomPadding: 0
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: ScalingUtility.getScaledValue(Spacing.space6)

        spacing: ScalingUtility.getScaledValue(Spacing.space2)

        Image {
            id: icon
            visible: container.showIcon
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.Pad
            source: isSecondary
                    ? (container.enabled
                       ? "../images/favorite_white.png"
                       : "../images/favorite_disabled.png")
                    : "../images/favorite.png"
        }

        Text {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.Wrap
            text: labelMetric.elidedText
            font: FontStyle.lSemiboldCapital
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: isPrimary
                   ? ColorSemantic.buttonPrimaryContentDefault
                   : (isSecondary
                      ? (container.enabled
                         ? ColorSemantic.buttonSecondaryContentDefault
                         : ColorSemantic.buttonSecondaryContentDisabled)
                      : ColorSemantic.buttonDangerContent)

            TextMetrics {
                id: labelMetric
                font: FontStyle.lSemiboldCapital
                elide: Text.ElideRight
                elideWidth: maxTextWidth
                text: "Label"
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: container.clicked()
        enabled: container.enabled
    }
}
