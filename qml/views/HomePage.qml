import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import "../components"

Rectangle {
    id: root

    function open(id, _name, tempt)
    {
        name = _name
        deviceId = id
        temperature = tempt
    }

    property alias name: nm.text
    property alias temperature: tm.value
    property string deviceId: ""

    color: bgColor

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 5

        Item {
            Layout.preferredWidth: root.width*0.8
            Layout.preferredHeight: 110
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 30

            RowLayout
            {
                anchors.fill: parent
                spacing: 5

                Rectangle
                {
                    Layout.preferredHeight: 105
                    Layout.preferredWidth: 105
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20

                    color: "transparent"
                    radius: height/2
                    border.width: 5
                    border.color: "white"

                    CircularImage
                    {
                        anchors.centerIn: parent

                        source: "qrc:/assets/smartwatch.png"
                    }
                }

                Rectangle
                {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                    Layout.leftMargin: 10
                    color: Qt.lighter(bgColor, 1.8)
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout
                    {
                        anchors.fill: parent
                        spacing: 10

                        Item{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        AppText
                        {
                            color: QmlInterface.isOnline? temperatureColor:"red"
                            size: 12
                            text: QmlInterface.isOnline? qsTr("Status: Online"):qsTr("Status: Offline")

                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 10
                        }

                        AppText
                        {
                            color: "white"
                            size: 12
                            text: QmlInterface.isOnline? qsTr("Connected ..."):qsTr("Disconnected ...")

                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 10
                        }

                        Item{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }

        }

        AppText
        {
            id: nm
            color: "white"
            size: 17
            text: qsTr("Peter Mathews")

            Layout.alignment: Qt.AlignHCenter
        }

        AppText
        {
            color: Qt.darker(temperatureColor, 1.4)
            size: 13
            font.bold: true
            text: qsTr("VITAL SIGNS")

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        Rectangle
        {
            Layout.preferredWidth: root.width*0.8
            Layout.preferredHeight: 1
            Layout.alignment: Qt.AlignHCenter
            color: Qt.lighter(bgColor, 1.8)
        }

        Item{
            id: lay
            Layout.preferredWidth: root.width*0.8
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignHCenter

            GridLayout
            {
                anchors.fill: parent
                columnSpacing: 5
                rowSpacing: 5

                DashboardElement{
                    id: tm
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 0
                    Layout.row: 0

                    label: qsTr("TEMP")
                    labelSize: 10
                    icon: "\uf2c8"
                    value: QmlInterface.userTemperature
                    unit: qsTr("°C")
                    colorFormat: temperatureColor
                }

                DashboardElement{
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 1
                    Layout.row: 0

                    label: qsTr("RESP")
                    labelSize: 10
                    icon: "\uf604"
                    value: QmlInterface.userRespiratoryRate
                    unit: qsTr("rpm")
                    colorFormat: respirationRateColor
                }

                DashboardElement{
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 0
                    Layout.row: 1

                    label: qsTr("HR")
                    icon: "\uf21e"
                    value: QmlInterface.userHeartRate
                    unit: qsTr("bpm")
                    colorFormat: hearRateColor
                }

                DashboardElement{
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 1
                    Layout.row: 1

                    label: qsTr("SPO2")
                    icon: "\uf72e"
                    value: QmlInterface.userSPO2
                    unit: qsTr("%")
                    colorFormat: spo2Color
                }
                DashboardElement{
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 0
                    Layout.row: 2

                    label: qsTr("BP-SYS")
                    labelSize: 10
                    icon: "\uf043"
                    value: QmlInterface.userSystolicPressure
                    unit: qsTr("mmHg")
                    colorFormat: pressureColor
                }

                DashboardElement{
                    Layout.preferredWidth: (lay.width-5)/2
                    Layout.column: 1
                    Layout.row: 2

                    label: qsTr("BP-DIA")
                    labelSize: 10
                    icon: "\uf043"
                    value: QmlInterface.userDiastolicPressure
                    unit: qsTr("mmHg")
                    colorFormat: pressureColor
                }
            }
        }

        Item{
            id: p
            Layout.fillHeight: true
            Layout.fillWidth: true

            Column
            {
                anchors.centerIn: parent

                AppText
                {
                    color: foreBlue
                    size: 10
                    text: "Last Sync : 5s ago"

                    height: 30
                    verticalAlignment: AppText.AlignVCenter
                    // anchors.leftMargin: p.width * 0.8
                }

                Rectangle
                {
                    height: 40
                    width: p.width * 0.8
                    color: Qt.lighter(bgColor, 1.7)
                    radius: 4

                    Icon
                    {
                        id: ico1
                        color: "orange"
                        size: 15
                        icon: "\uf82e"

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                    }

                    AppText
                    {
                        size: 15
                        text: "Doctor's Feedback"
                        color: "white"

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: ico1.right
                        anchors.leftMargin: 5
                    }

                    Icon
                    {
                        color: "white"
                        size: 15
                        icon: "\uf061"

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: stackIndex=5
                    }
                }
            }
        }

    }
}
