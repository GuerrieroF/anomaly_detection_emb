pragma Singleton
import QtQuick 2.15
//import "ColorPalettes.qml"

QtObject {
    // Template
    readonly property color templateBackground: ColorPalettes.gray900

    // Layer
    readonly property color layerNeutralBackgroundDefault: ColorPalettes.gray900
    // readonly property color layerNeutralBackgroundPressed:
    readonly property color layerVariant1BackgroundDefault: ColorPalettes.gray800
    // readonly property color layerVariant1BackgroundPressed:
    readonly property color layerBorderSelected: ColorPalettes.green400
    readonly property color layerBorderError: ColorPalettes.red400
    // readonly property color layerInverseBackground:

    // Stroke
    readonly property color strokeBorder: ColorPalettes.gray200
    readonly property color strokeDefault: ColorPalettes.gray50
    readonly property color strokeActive: ColorPalettes.green400
    readonly property color strokeDisabled: ColorPalettes.gray500

    // Content
    readonly property color contentDefault: ColorPalettes.gray50
    readonly property color contentSelected: ColorPalettes.green400
    readonly property color contentDisabled: ColorPalettes.gray500
    readonly property color contentInverse: ColorPalettes.gray900
    readonly property color contentDanger: ColorPalettes.red400
    readonly property color contentWarning: ColorPalettes.yellow300

    // Modal
    readonly property color modalPopupHeaderBackground: ColorPalettes.gray800
    readonly property color modalPopupBodyBackground: ColorPalettes.gray900
    readonly property color modalOverlay: Qt.rgba(0, 0, 0, 0.7)
    readonly property color modalOverlayDarker: Qt.rgba(0, 0, 0, 0.9)

    // Button
    readonly property color buttonPrimaryBackgroundDefault: ColorPalettes.green400
    readonly property color buttonPrimaryBackgroundDisabled: ColorPalettes.green800
    // readonly property color buttonPrimaryBackgroundPressed:
    readonly property color buttonPrimaryContentDefault: ColorPalettes.gray900
    readonly property color buttonSecondaryBackgroundDefault: ColorPalettes.gray900
    // readonly property color buttonSecondaryBackgroundPressed:
    readonly property color buttonSecondaryBorderDefault: ColorPalettes.gray200
    readonly property color buttonSecondaryBorderDisabled: ColorPalettes.gray500
    readonly property color buttonSecondaryContentDefault: ColorPalettes.gray50
    readonly property color buttonSecondaryContentDisabled: ColorPalettes.gray500
    readonly property color buttonTertiaryContentDefault: ColorPalettes.gray50
    // readonly property color buttonTertiaryContentPressed:
    readonly property color buttonTertiaryContentDisabled: ColorPalettes.gray500
    readonly property color buttonDangerBackgroundDefault: ColorPalettes.red400
    // readonly property color buttonDangerBackgroundPressed:
    readonly property color buttonDangerBackgroundDisabled: ColorPalettes.red800
    readonly property color buttonDangerContent: ColorPalettes.gray900

    // Pill
    readonly property color pillBackgroundDefault: ColorPalettes.gray900
    readonly property color pillContentDefault: ColorPalettes.gray50
    readonly property color pillBackgroundActive: ColorPalettes.green900
    readonly property color pillBorderActive: ColorPalettes.green600
    readonly property color pillContentActive: ColorPalettes.green400
}
