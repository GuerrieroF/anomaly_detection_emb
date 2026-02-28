pragma Singleton
import QtQuick

QtObject
{
    id: scalingUtilityRoot

    readonly property real millimitersPerInch: 25.4
    readonly property int defaultPPI: 130
    readonly property int actualPPI: 130 // Math.round(Screen.pixelDensity * millimitersPerInch)
    readonly property real scalingFactor: actualPPI / defaultPPI

    function getScaledValue(x)
    {
        if (scalingFactor == 0) return 0;

        var ret = Math.round(x * scalingFactor);
        if ((ret == 0) && (x !== 0)) console.log("WARNING : getScaledValue(" + x + ") returning 0 !!!");

        return ret;
    }
}
