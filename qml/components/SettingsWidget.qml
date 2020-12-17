import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../components"

Rectangle{
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 50
    Layout.topMargin: 10

    color: Qt.lighter(bgColor, 1.4)
    radius: 15

    property alias icon: ico.icon
    property alias title: t1.text
    property alias desc: t2.text

    signal clicked()

    RowLayout
    {
        anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Rectangle
        {
            Layout.fillHeight: true
            Layout.preferredWidth: height

            radius: 5
            color: "blue"

            Icon
            {
                id: ico
                color: "white"
                size: 20
                icon: "\uf508"

                anchors.centerIn: parent
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 4

                AppText
                {
                    id: t1
                    color: "white"
                    size: 14

                    Layout.alignment: Qt.AlignLeft
                }

                AppText
                {
                    id: t2
                    color: "grey"
                    size: 9

                    Layout.alignment: Qt.AlignLeft
                }
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

