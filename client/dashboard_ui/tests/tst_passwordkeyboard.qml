import QtQuick
import QtQuick.Controls
import QtTest
import Dashboard.Ui 1.0

TestCase {
    name: "PasswordKeyboard"
    width: 900
    height: 400
    visible: true
    when: windowShown

    TextField {
        id: field
        readOnly: true
        echoMode: TextInput.Password
    }
    PasswordKeyboard {
        id: keyboard
        y: 80
        width: 880
        target: field
    }
    function init() {
        field.clear()
        keyboard.shifted = false
        keyboard.symbols = false
    }
    function test_selection_and_backspace() {
        keyboard.insertText("abc123!")
        field.select(1, 3)
        keyboard.insertText("XY")
        compare(field.text, "aXY123!")
        keyboard.backspace()
        compare(field.text, "aX123!")
        field.select(1, 3)
        keyboard.backspace()
        compare(field.text, "a23!")
    }
    function test_cursor_and_spaces() {
        keyboard.insertText("a!")
        keyboard.moveCursor(-1)
        keyboard.insertText(" ")
        compare(field.text, "a !")
        keyboard.moveCursor(-100)
        compare(field.cursorPosition, 0)
        keyboard.backspace()
        compare(field.text, "a !")
        keyboard.moveCursor(100)
        compare(field.cursorPosition, field.length)
    }
}
