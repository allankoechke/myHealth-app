import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "../components"

Item{
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 40

    property bool isActive: false
    property alias icon: ico.icon
    property alias text: txt.text

    signal accepted()

    RowLayout
    {
        anchors.fill: parent
        spacing: 1

        Item{
            Layout.fillHeight: true
            Layout.preferredWidth: 45

            Icon
            {
                id: ico
                icon: "\uf21e"
                color: "white"
                size: 20

                anchors.centerIn: parent
            }
        }

        AppText
        {
            id: txt
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10

            verticalAlignment: AppText.AlignVCenter
            horizontalAlignment: AppText.AlignLeft
            color: "white"
            size: 15
            text: qsTr("Malaika Vitals App")
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: root.accepted()
    }
}
