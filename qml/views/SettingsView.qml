import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../components"

Item {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true


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

            Text
            {
                font.pixelSize: 13
                color: "white"
                text: qsTr("Setting Panel")

                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    ColumnLayout
    {
        anchors.top: topItem.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width*0.8
        height: parent.height
        spacing: 1

        CircularImage
        {
            Layout.preferredHeight: 130
            Layout.preferredWidth: 130
            Layout.alignment: Qt.AlignHCenter

            radius: height/2
            source: "qrc:/assets/images/pexels-photo-1681010.jpeg"

            Rectangle
            {
                height: 30; width: 30
                radius: height/2
                color: Qt.darker(bgColor, 1.3)

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: (parent.width-parent.width*Math.sin(45))-radius
                anchors.bottomMargin: (parent.width-parent.width*Math.sin(45))-radius

                Icon
                {
                    color: "blue"
                    icon: "\uf030"
                    size: 15

                    anchors.centerIn: parent
                }
            }
        }

        AppText
        {
            color: "grey"
            size: 13
            bold: true
            text: qsTr("John Doe")

            Layout.alignment: Qt.AlignHCenter
        }

        SettingsWidget
        {
            Layout.topMargin: 20
            icon: "\uf508"
            title: qsTr("Edit profile")
            desc:  qsTr("Edit profile info")

            onClicked: profileDrawer.open()
        }

        SettingsWidget
        {
            icon: "\uf021"
            title: qsTr("Sync Settings")
            desc:  qsTr("Edit sync info")

            onClicked: syncDrawer.open()
        }

        SettingsWidget
        {
            icon: "\uf042"
            title: qsTr("Change Theme")
            desc:  qsTr("Edit current theme")

            onClicked: themeDrawer.open()
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Layout.topMargin: 20

            color: Qt.lighter("red", 1.5)
            radius: 3

            AppText
            {
                anchors.centerIn: parent

                color: "red"
                text: qsTr("Logout")
                size: 13
            }

            MouseArea
            {
                anchors.fill: parent
                // TODO to work on logout script
            }
        }

        Item{
            Layout.fillHeight: true
            Layout.preferredWidth: 1
        }

        AppText
        {
            color: "grey"
            text: qsTr("Smartwatch\nVersion 0.0.1 (c)2020")
            size: 8

            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            horizontalAlignment: AppText.AlignHCenter
        }
    }
}
