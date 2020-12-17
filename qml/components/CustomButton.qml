import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: control
    width: 100
    height: 40

    property string label: ""
    property bool isCurrent: false

    Rectangle {
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
        // border.color: control.down ? "#17a81a" : "#21be2b"
        border.width: 1
        radius: 2
        color: bgColor

        Text {
            text: label===""? control.text:label
            // font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: "white" // control.down ? "#17a81a" : "#21be2b"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
