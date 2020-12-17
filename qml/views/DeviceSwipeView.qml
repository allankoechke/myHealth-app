import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "../components"
import "../views"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    // property alias swipeView: swipeView
    property alias homePage: homePage

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
                id: menuOptions
                height: 30
                width: height

                Layout.alignment: Qt.AlignVCenter
                anchors.leftMargin: 10

                Icon
                {
                    icon: "\uf0c9"
                    color: "white"
                    size: 15

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        // Open Drawer
                        menuDrawer.open()
                    }
                }
            }

            AppText
            {
                color: "white"
                size: 13
                font.bold: true
                text: "myHealth App"

                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: AppText.AlignHCenter
                verticalAlignment: AppText.AlignVCenter
            }

            Item {
                id: searchDevice
                height: 30
                width: height

                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 10

                Icon
                {
                    icon: "\uf002"
                    color: "white"
                    size: 15

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        // Open Search Window
                        stackIndex = 5
                    }
                }
            }

        }
    }

    HomePage
    {
        id: homePage

        width: root.width
        anchors.top: topItem.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 5
    }
}
