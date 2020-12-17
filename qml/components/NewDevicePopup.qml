import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root

    width: 300
    height: 250
    modal: true

    x: (mainAppView.width-width)/2
    y: (mainAppView.height-height)/2

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

                AppText
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 20

                    verticalAlignment: AppText.AlignVCenter
                    horizontalAlignment: AppText.AlignLeft
                    color: "white"
                    size: 16
                    text: qsTr("Add new Smartwatch")
                    font.bold: true
                }

                Icon
                {
                    icon: "\uf00d"
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

        Item{
            Layout.preferredHeight: 60
            Layout.fillWidth: true

            Rectangle
            {
                anchors.fill: parent
                anchors.margins: 5
                radius: 5
                color: Qt.darker(bgColor, 1.3)
                border.width: 1
                border.color: Qt.lighter(bg.color, 1.8)

                Rectangle
                {
                    width: gbLabel.width+10
                    height: parent.border.width+2
                    color: Qt.darker(bgColor, 1.3)

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.topMargin: -height/2
                }

                AppText
                {
                    id: gbLabel
                    color: "white"
                    size: 12
                    text: "Smartwatch Unique Id"

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 25
                    anchors.topMargin: -height/2
                }

                TextField
                {
                    color: "white"
                    font.pixelSize: 14
                    placeholderText: "Enter the Id"

                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    anchors.leftMargin: 6
                    anchors.topMargin: 6
                    anchors.rightMargin: 6
                }
            }
        }
        Item{
            Layout.preferredHeight: 60
            Layout.fillWidth: true

            Rectangle
            {
                anchors.fill: parent
                anchors.margins: 5
                radius: 5
                color: Qt.darker(bgColor, 1.3)
                border.width: 1
                border.color: Qt.lighter(bg.color, 1.8)

                Rectangle
                {
                    width: gbLabel1.width+10
                    height: parent.border.width+2
                    color: Qt.darker(bgColor, 1.3)

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.topMargin: -height/2
                }

                AppText
                {
                    id: gbLabel1
                    color: "white"
                    size: 12
                    text: "Who am I?"

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 25
                    anchors.topMargin: -height/2
                }

                ComboBox
                {
                    font.pixelSize: 14
                    model: ["Parent/Guardian", 'School Administartion']

                    anchors.fill: parent
                    anchors.margins: 6
                }
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle
        {
            color: "green"
            radius: 4
            width: 60
            height: 35

            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 20

            AppText {
                id: label
                text: qsTr("Add")
                color: "white"
                size: 13

                anchors.centerIn: parent

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        spinner.open();
                        stopLoader.start();
                    }
                }
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
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
