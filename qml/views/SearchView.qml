import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../components"

Item {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle{
        id: topItem
        width: root.width
        height: 35
        color: Qt.lighter(bgColor, 1.6)

        anchors.top: parent.top
        anchors.left: parent.left

        RowLayout
        {
            anchors.fill: parent
            spacing: 5

            Item {
                id: backToDevices
                height: 30
                width: height

                Layout.alignment: Qt.AlignVCenter

                Icon
                {
                    icon: "\uf060"
                    color: "white"
                    size: 15

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        // Open Drawer
                        stackIndex = 3
                    }
                }
            }

            TextInput
            {
                id: searchTextInput
                Layout.fillWidth: true
                Layout.minimumHeight: 34
                Layout.fillHeight: true
                Layout.leftMargin: 15
                Layout.rightMargin: text===""? 15:5

                color: "white"
                font.pixelSize: 12
                height: 35
                verticalAlignment: TextField.AlignVCenter

                Text
                {
                    visible: parent.text===""
                    font.pixelSize: parent.font.pixelSize
                    color: Qt.darker(parent.color, 1.5)
                    text: qsTr("Search name or device ID")

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: clearInput
                height: 30
                width: height
                visible: searchTextInput.text!==""

                Layout.alignment: Qt.AlignVCenter

                Icon
                {
                    icon: "\uf00d"
                    color: "white"
                    size: 15

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        // Clear the search text input data
                        searchTextInput.text=""
                    }
                }
            }

        }
    }

    Item
    {
        width: root.width

        anchors.top: topItem.bottom
        anchors.bottom: root.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
    }
}
