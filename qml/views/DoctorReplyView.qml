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

            AppText
            {
                Layout.fillWidth: true
                Layout.minimumHeight: 34
                Layout.fillHeight: true
                Layout.leftMargin: 15

                color: "white"
                font.pixelSize: 12
                height: 35
                verticalAlignment: AppText.AlignVCenter
                horizontalAlignment: AppText.AlignHCenter
                text: "Doctor's feedback"
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

        ScrollView
        {
            anchors.fill: parent
            spacing: 5
            clip: true

            ListView
            {
                id: lst
                width: parent.width
                height: parent.height
                model: doctorsReplyModel
                spacing: 5

                delegate: Component{
                    Item{
                        width: lst.width
                        height: 50

                        Rectangle
                        {
                            id: rec
                            width: parent.width-20
                            height: parent.height
                            radius: 4
                            color: Qt.lighter(bgColor, 1.4)

                            anchors.centerIn: parent

                            Column
                            {
                                anchors.centerIn: parent
                                spacing: 2

                                Item{
                                    height: 14
                                    width: rec.width

                                    AppText
                                    {
                                        text: "Date: 2020-12-20 12:32:00"
                                        color: Qt.lighter(bgColor, 2.4)
                                        size: 10

                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                    }
                                }

                                Rectangle
                                {
                                    width: rec.width-20
                                    height: 1
                                    Layout.leftMargin: 10
                                    color: Qt.lighter(bgColor, 1.6)
                                }

                                Item{
                                    height: 20
                                    width: rec.width

                                    AppText
                                    {
                                        text: msg // "Take a glass of minced juice and rest."
                                        color: "white"
                                        elide: AppText.ElideRight
                                        size: 10
                                        width: parent.width-20
                                        anchors.leftMargin: 10
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel
    {
        id: doctorsReplyModel
    }

    Connections
    {
        target: QmlInterface

        function onNewDoctorReplyEmitted(dataObj)
        {
            doctorsReplyModel.append(dataObj);
            // console.log("New Data Received!");
        }

        function onDoctorReplyReceived()
        {
            hasSyncedBefore = true;
            doctorsReplyModel.clear();
        }
    }
}
