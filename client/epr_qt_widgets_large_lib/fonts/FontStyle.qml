pragma Singleton
import QtQuick 2.15
import "../"

QtObject {
    id: container


    readonly property FontLoader regular: FontLoader {
        source: "./NotoSans-Regular.ttf"
    }

    readonly property FontLoader semibold: FontLoader {
        source: "./NotoSans-SemiBold.ttf"
    }

    readonly property FontLoader italic: FontLoader {
        source: "./NotoSans-Italic.ttf"
    }

    //XXXL
    readonly property font xxxlRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(100)
    })

    //XXL
    readonly property font xxlRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(60)
    })

    //XL
    readonly property font xlRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(48)
    })

    //L
    readonly property font lRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(24)
    })

    readonly property font lSemibold: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(24),
        weight: Font.DemiBold
    })

    readonly property font lUnderline: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(24),
        underline: true
    })

    readonly property font lSemiboldCapital: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(24),
        capitalization: Font.AllUppercase,
        weight: Font.DemiBold
    })

    readonly property font lItalic: Qt.font({
        family: italic.name,
        pixelSize: ScalingUtility.getScaledValue(24),
        italic: true
    })

    readonly property int lLineHeight: ScalingUtility.getScaledValue(34)

    // M
    readonly property font mRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(21)
    })

    readonly property font mCapital: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(21),
        capitalization: Font.AllUppercase
    })

    readonly property font mUnderline: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(21),
        underline: true
    })

    readonly property font mSemibold: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(21),
        weight: Font.DemiBold
    })

    readonly property font mSemiboldCapital: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(21),
        capitalization: Font.AllUppercase,
        weight: Font.DemiBold
    })

    readonly property font mItalic: Qt.font({
        family: italic.name,
        pixelSize: ScalingUtility.getScaledValue(21),
        italic: true
    })

    readonly property real mLineHeigth: ScalingUtility.getScaledValue(30)

    // S
    readonly property font sRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(18)
    })

    readonly property font sCapital: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(18),
        capitalization: Font.AllUppercase
    })

    readonly property font sUnderline: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(18),
        underline: true
    })

    readonly property font sSemibold: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(18),
        weight: Font.DemiBold
    })

    readonly property real sLineHeigth: ScalingUtility.getScaledValue(25)

    // XS
    readonly property font xsRegular: Qt.font({
        family: regular.name,
        pixelSize: ScalingUtility.getScaledValue(16)
    })

    readonly property font xsSemibold: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(16),
        weight: Font.DemiBold
    })

    readonly property font xsSemiboldCapital: Qt.font({
        family: semibold.name,
        pixelSize: ScalingUtility.getScaledValue(16),
        capitalization: Font.AllUppercase,
        weight: Font.DemiBold
    })

    readonly property font xsItalic: Qt.font({
        family: italic.name,
        pixelSize: ScalingUtility.getScaledValue(16),
        italic: true
    })

    readonly property real xsLineHeigth: ScalingUtility.getScaledValue(23)
}
