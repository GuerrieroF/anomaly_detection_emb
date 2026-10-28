import QtQuick
import QtQuick.Layouts
import Dashboard.Ui 1.0

ColumnLayout {
    id: root
    required property var target
    property bool shifted: false
    property bool symbols: false
    spacing: 6
    implicitHeight: 244

    function insertText(value) {
        var start = target.selectionStart
        var end = target.selectionEnd
        if (start !== end)
            target.remove(start, end)
        target.insert(target.cursorPosition, value)
    }
    function backspace() {
        if (target.selectionStart !== target.selectionEnd)
            target.remove(target.selectionStart, target.selectionEnd)
        else if (target.cursorPosition > 0)
            target.remove(target.cursorPosition - 1, target.cursorPosition)
    }
    function moveCursor(offset) {
        target.cursorPosition = Math.max(0, Math.min(target.length, target.cursorPosition + offset))
    }

    Repeater {
        model: root.symbols
               ? ["1234567890", "!@#$%^&*()", "-_=+[]{}\\|", ";:'\",.<>/?"]
               : ["1234567890", "qwertyuiop", "asdfghjkl", "zxcvbnm"]
        delegate: RowLayout {
            required property string modelData
            required property int index
            Layout.fillWidth: true
            spacing: 6
            DashboardButton {
                visible: index === 3
                text: "⇧"
                toolTip: qsTr("Maiuscole")
                selected: root.shifted
                focusPolicy: Qt.NoFocus
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 44
                onClicked: root.shifted = !root.shifted
            }
            Repeater {
                model: modelData.split("")
                delegate: DashboardButton {
                    required property string modelData
                    text: root.shifted && !root.symbols ? modelData.toUpperCase() : modelData
                    font.pixelSize: 22
                    focusPolicy: Qt.NoFocus
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 44
                    onClicked: root.insertText(text)
                }
            }
            DashboardButton {
                visible: index === 3
                text: "⌫"
                toolTip: qsTr("Cancella carattere")
                focusPolicy: Qt.NoFocus
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.preferredHeight: 44
                autoRepeat: true
                onClicked: root.backspace()
            }
        }
    }
    RowLayout {
        spacing: 6
        Layout.fillWidth: true
        DashboardButton {
            text: root.symbols ? "ABC" : "#+="
            toolTip: qsTr("Lettere e simboli")
            focusPolicy: Qt.NoFocus
            Layout.preferredWidth: 90
            Layout.preferredHeight: 44
            onClicked: root.symbols = !root.symbols
        }
        DashboardButton {
            text: qsTr("Spazio")
            focusPolicy: Qt.NoFocus
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            onClicked: root.insertText(" ")
        }
        DashboardButton {
            text: "←"
            toolTip: qsTr("Sposta cursore a sinistra")
            focusPolicy: Qt.NoFocus
            Layout.preferredWidth: 64
            Layout.preferredHeight: 44
            onClicked: root.moveCursor(-1)
        }
        DashboardButton {
            text: "→"
            toolTip: qsTr("Sposta cursore a destra")
            focusPolicy: Qt.NoFocus
            Layout.preferredWidth: 64
            Layout.preferredHeight: 44
            onClicked: root.moveCursor(1)
        }
    }
}
