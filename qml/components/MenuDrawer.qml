import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Drawer {
    id: root

    width: mainAppView.width
    height: 300
    edge: Qt.BottomEdge
    interactive: false
    modal: true

    background: Rectangle
    {
        id: bg
        color: Qt.darker(bgColor, 1.3)
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 5

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            Rectangle
            {
                color: Qt.lighter(bg.color, 1.8)
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }

            RowLayout
            {
                anchors.fill: parent
                spacing: 5

                Item{
                    Layout.fillHeight: true
                    Layout.preferredWidth: 40

                    Icon
                    {
                        icon: "\uf21e"
                        color: "white"
                        size: 20

                        anchors.centerIn: parent
                    }
                }

                AppText
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 20

                    verticalAlignment: AppText.AlignVCenter
                    horizontalAlignment: AppText.AlignLeft
                    color: "white"
                    size: 16
                    text: qsTr("myHealth App")
                    font.bold: true
                }

                Icon
                {
                    icon: "\uf107"
                    color: "white"
                    size: 20

                    Layout.preferredWidth: 30
                    Layout.fillHeight: true
                    verticalAlignment: Icon.AlignVCenter
                    horizontalAlignment: Icon.AlignHCenter

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: root.close();
                    }
                }
            }
        }

        MenuButton
        {
            icon: "\uf067"
            text: qsTr("Add New Device")
            onAccepted: {
                addDevicePopup.open();
                root.close()
            }
        }

        MenuButton
        {
            icon: "\uf0f9"
            text: qsTr("Send SOS")
            onAccepted: {
                // stackIndex=1
                root.close()
            }
        }

        MenuButton
        {
            icon: "\uf021"
            text: qsTr("Refresh Sync Data")
            onAccepted: {
                spinner.open();
                stopLoader.start();
                // root.close()
            }
        }

        MenuButton
        {
            icon: "\uf3f2"
            text: qsTr("Settings")
            onAccepted: {
                stackIndex=4
                root.close()
            }
        }

        MenuButton
        {
            icon: "\uf2f5"
            text: qsTr("Logout")
            onAccepted: {
                stackIndex=1;
                QmlInterface.isUserLoggedIn = false;
                root.close();
            }
        }

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Timer
    {
        id: stopLoader
        interval: 3500
        repeat: false
        onTriggered: {
            spinner.close();
            spinner.isLoading = false;
            root.close();
        }

        onRunningChanged: {
            if(running)
                spinner.isLoading = true
        }
    }
}
