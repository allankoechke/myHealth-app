import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root

    onOpened: msgPopup_isOpen=true
    onClosed: {msgPopup_isOpen=false
        msg.text="";
    }

    width: 300
    height: 150
    x: (mainAppView.width-width)/2
    y: (mainAppView.height-height)/2

    property bool isSendingReply: false

    contentItem: Rectangle
    {
        color: bgColor
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            TextArea
            {
                id: msg
                height: root.height-90
                width: root.width-40
                placeholderText: "Enter reply message here ..."
                color: "white"
                font.pixelSize: 12

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Rectangle
                {
                    color: "orange"
                    width: 70
                    height: parent.height-10

                    anchors.right: send.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    AppText
                    {
                        color: "white"
                        size: 13
                        text: "Cancel"
                        enabled: !isSendingReply

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: root.close()
                    }
                }

                Rectangle
                {
                    id: send
                    color: "green"
                    width: 100
                    height: parent.height-10

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    AppText
                    {
                        color: "white"
                        size: 13
                        text: isSendingReply? "Sending ...":"Send"

                        anchors.centerIn: parent
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            isSendingReply=true
                            QmlInterface.sendReply(msg.text)
                        }
                    }
                }

            }
        }
    }

    Connections
    {
        target: QmlInterface

        function onDoctorsReplyStateChanged(state, info)
        {
            isSendingReply = false;

            console.log("State Changed: ", state)

            if(state)
            {
                root.close()
            }
        }
    }
}
