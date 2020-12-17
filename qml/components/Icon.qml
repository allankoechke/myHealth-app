import QtQuick 2.12
import QtQuick.Controls 2.4

Label {
    id: root

    property alias size: root.font.pixelSize
    property alias icon: root.text

    font.pixelSize: 15
    font.family: mainAppView.fontAwesomeFontLoader.name
    color: "black"
}
