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

        Rectangle
        {
            Layout.preferredHeight: 105
            Layout.preferredWidth: 105
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20

            color: "white"
            radius: height/2

            CircularImage
            {
                anchors.centerIn: parent

                source: "qrc:/assets/images/pexels-photo-1681010.jpeg"
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
            color: "white"
            size: 15
            text: qsTr("Health Status Bar")

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        ProgressBar
        {
            id: pb
            Layout.preferredHeight: 10
            Layout.preferredWidth: root.width*0.8
            Layout.alignment: Qt.AlignHCenter

            value: QmlInterface.healthStatusValue
            from: 0
            to: 100

            background: Rectangle {
                implicitWidth: 250
                implicitHeight: 6
                color: "#c2cad3"
                radius: height/2
                border.width: 1
                border.color: "silver"
            }

            contentItem: Item {
                implicitWidth: 250
                implicitHeight: 4

                Rectangle {
                    width: pb.visualPosition * parent.width
                    height: parent.height
                    radius: height/2
                    color: "#06be24"
                }
            }
        }

        AppText
        {
            color: "white"
            size: 13
            font.bold: true
            text: qsTr("VITAL SIGNS")

            Layout.alignment: Qt.AlignHCenter
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
                    // value: QmlInterface.userTemperature
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
                    // Layout.preferredHeight: 100
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
                    // Layout.preferredHeight: 100
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
                    // Layout.preferredHeight: 100
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
                    // Layout.preferredHeight: 100
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
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

    }
}
