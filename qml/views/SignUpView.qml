import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.12

import "../components"

Item {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias fullname: fname.text
    property alias email: email_.text
    property alias password: pass.text
    property alias cpassword: cpass.text

    ColumnLayout
    {
        width: root.width * 0.8
        height: root.height * 0.9
        anchors.centerIn: parent

        Image
        {
            Layout.preferredWidth: 200
            Layout.preferredHeight: 80
            source: "qrc:/assets/myHealth-logo.png"
            Layout.alignment: Qt.AlignHCenter
        }

        AppText
        {
            color: "white"
            text: qsTr("Creating Account")
            size: 20
            font.bold: true

            Layout.alignment: Qt.AlignHCenter
        }

        TextField
        {
            id: fname
            placeholderText: qsTr("Firstname Lastname")
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)

            Layout.fillWidth: true
            Layout.preferredHeight: 40
        }

        TextField
        {
            id: email_
            placeholderText: qsTr("Email")
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)

            Layout.fillWidth: true
            Layout.preferredHeight: 40
        }

        TextField
        {
            id: pass
            placeholderText: qsTr("Password")
            echoMode: TextField.Password
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)

            Layout.fillWidth: true
            Layout.preferredHeight: 40
        }

        TextField
        {
            id: cpass
            placeholderText: qsTr("Confirm Password")
            echoMode: TextField.Password
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)

            Layout.fillWidth: true
            Layout.preferredHeight: 40
        }

        Rectangle
        {
            Layout.preferredHeight: 40
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignHCenter

            radius: height/2
            color: "#0677e9"

            AppText
            {
                color: "white"
                size: 18
                text: qsTr("Sign Up")

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {

                    if(fullname.length < 5)
                    {
                        infoPopup.open()
                        infoPopup.infoLevel = 2
                        infoPopup.info = "Name field is short/empty!"
                    }

                    else if(email.length < 5)
                    {
                        infoPopup.open()
                        infoPopup.infoLevel = 2
                        infoPopup.info = "Email field is short/empty!"
                    }

                    else if(password.length < 5)
                    {
                        infoPopup.open()
                        infoPopup.infoLevel = 2
                        infoPopup.info = "Password field is short/empty!"
                    }

                    else if(cpassword.length < 5 || password !== cpassword)
                    {
                        infoPopup.open()
                        infoPopup.infoLevel = 2
                        infoPopup.info = "Password fields do not match!"
                    }

                    else
                    {
                        stackIndex = 1
                        resetFields()
                    }

                }
            }
        }

        AppText
        {
            text: qsTr("Already have an account? Sign In")
            color: "grey"
            size: 13

            Layout.alignment: Qt.AlignHCenter

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    resetFields();
                    stackIndex=1;
                }
            }
        }
    }

    function resetFields()
    {
        fullname = "";
        email = "";
        password = "";
        cpassword = "";
    }
}
