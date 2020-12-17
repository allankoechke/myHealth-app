import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.12

import "../components"

Item {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias email: email_.text
    property alias password: pass.text

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
            text: qsTr("Account Details")
            size: 20
            font.bold: true

            Layout.alignment: Qt.AlignHCenter
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

        AppText
        {
            text: qsTr("Forgot password?")
            color: "grey"
            size: 13

            Layout.alignment: Qt.AlignRight
            Layout.topMargin: -5

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
                text: qsTr("Sign In")

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    if(email.length < 5)
                    {
                        console.log("Email length: ", email.length)
                        infoPopup.open()
                        infoPopup.info = "Email field is inavalid!"
                        infoPopup.infoLevel = 2
                    }

                    else if(password.length < 5)
                    {
                        console.log("Password length: ", password.length)
                        infoPopup.open()
                        infoPopup.info = "Password field is inavalid!"
                        infoPopup.infoLevel = 2
                    }

                    else
                    {
                        stackIndex = 3
                        resetFields();
                        QmlInterface.isUserLoggedIn = true;
                    }
                }
            }
        }

        AppText
        {
            text: qsTr("Don't have an account yet? Create One")
            color: "grey"
            size: 13

            Layout.alignment: Qt.AlignHCenter

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    resetFields()
                    stackIndex=2
                }
            }
        }
    }

    function resetFields()
    {
        email = ""
        password = ""
    }
}
