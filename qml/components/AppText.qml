import QtQuick 2.0

Text {
    id: root

    property alias size: root.font.pixelSize
    property alias family: root.font.family
    property alias bold: root.font.bold

    color: "white"
    font.pixelSize: 15
}
