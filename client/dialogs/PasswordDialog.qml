import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Dashboard.Ui 1.0

DashboardDialog {
    id: root
    property string value: ""
    signal passwordConfirmed(string password)
    title: qsTr("Password Wi-Fi")
    width: Math.min(900, parent.width - 32)
    padding: 24
    contentHeight: 56 + 12 + keyboard.implicitHeight
    onOpened: {
        entry.text = value
        entry.cursorPosition = entry.length
        keyboard.shifted = false
        keyboard.symbols = false
        entry.forceActiveFocus()
    }
    onClosed: {
        entry.clear()
        value = ""
    }
    contentItem: ColumnLayout {
        spacing: 12
        TextField {
            id: entry
            objectName: "keyboardPasswordField"
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            // The app keyboard edits the field; readOnly prevents a second,
            // platform input panel from opening on top of the dialog.
            readOnly: true
            selectByMouse: true
            echoMode: TextInput.Password
            font.family: DashboardTypography.family
            font.pixelSize: 22
            color: DashboardColors.textPrimary
            placeholderText: qsTr("Inserisci la password")
            placeholderTextColor: DashboardColors.textSecondary
            leftPadding: 16
            rightPadding: 16
            background: Rectangle {
                color: DashboardColors.surfaceMuted
                radius: DashboardSpacing.radiusMd
                border.color: DashboardColors.accent
            }
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) keyboard.backspace()
                else if (event.key === Qt.Key_Delete) {
                    if (selectionStart !== selectionEnd) remove(selectionStart, selectionEnd)
                    else remove(cursorPosition, cursorPosition + 1)
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) root.confirm()
                else if (event.text.length && !(event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))
                         && event.text.charCodeAt(0) >= 32) keyboard.insertText(event.text)
                else return
                event.accepted = true
            }
        }
        PasswordKeyboard {
            id: keyboard
            target: entry
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
        }
    }
    function confirm() {
        passwordConfirmed(entry.text)
        accept()
    }
    footer: Item {
        implicitHeight: 80
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 16
            DashboardButton {
                text: qsTr("Annulla")
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                onClicked: root.reject()
            }
            DashboardButton {
                text: qsTr("Conferma")
                selected: true
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                onClicked: root.confirm()
            }
        }
    }
}
