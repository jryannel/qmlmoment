import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

import "moment.js" as M

ApplicationWindow {
    title: "QML Moment"
    width: 640
    height: 480
    visible: true

    Action {
        id: exitAction
        text: "Exit"
        onTriggered: Qt.quit()
    }

    menuBar: MenuBar {
        Menu {
            title: 'File'
            MenuItem {
                action: exitAction
            }
        }
    }

    Dialog {
        id: calendarDialog
        property TextField currentField
        contentItem: Calendar {
            id: calendar
            onClicked: {
                calendarDialog.click(StandardButton.Ok)
            }
        }
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            currentField.text = Qt.formatDate(calendar.selectedDate, 'yyyy-MM-dd')
        }
    }


    GridLayout {
        anchors.fill: parent
        anchors.margins: 4
        columns: 3
        Label { text: "Start" }
        TextField {
            id: startField;
            Layout.fillWidth:  true
            text: M.moment().format('YYYY-MM-DD')
        }
        Button {
            text: '...'
            onClicked: {
                calendarDialog.currentField = startField
                calendarDialog.open()
            }
        }
        Label { text: "End" }
        TextField {
            id: endField; Layout.fillWidth:  true
            onTextChanged: output.update()
            text: M.moment().format('YYYY-MM-DD')
        }
        Button {
            text: '...'
            onClicked: {
                calendarDialog.currentField = endField
                calendarDialog.open()
            }
        }
        TextArea {
            id: output
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            readOnly: true
            property var start: M.moment(startField.text)
            property var end: M.moment(endField.text)
            text: (function() {
                if(!start.isValid() || !end.isValid()) {
                    return ''
                }
                var s = ''
                s+= String('Start: %0, Week %1\n').arg(start.format("MMM Do YY")).arg(start.format('WW'));
                s+= String('End: %0, Week %1\n').arg(end.format("MMM Do YY")).arg(end.format('WW'));
                s+= String('When : %0 weeks\n').arg(M.moment(end).diff(start, 'w'));
                s+= String('When: %0\n').arg(end.from(start));
                return s;
            })()

        }
    }

    property var log : console.log

    Component.onCompleted: {
        log(M.moment("12-25-1995", "MM-DD-YYYY"));
        log(M.moment().format('dddd'));
        log(M.moment().format("MMM Do YY"));
        log(M.moment.duration(2, 'd').humanize());
        var start = M.moment("2015-06-01");
        var end   = M.moment("2015-06-30");
        log(end.from(start));
    }
}
