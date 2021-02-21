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

    RotationAnimation
    {
        target: spinIco
        from: 0
        to: 360
        loops: RotationAnimation.Infinite
        running: QmlInterface.processingUserLogin

        onRunningChanged: {
            if(!running)
                spinIco.rotation = 0;
        }
    }

    ColumnLayout
    {
        width: root.width * 0.8
        height: root.height * 0.9
        anchors.centerIn: parent
        spacing: 15

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

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
            readOnly: QmlInterface.processingUserLogin
            font.pixelSize: 15

            Layout.fillWidth: true
            Layout.preferredHeight: 60
        }

        TextField
        {
            id: pass
            placeholderText: qsTr("Password")
            echoMode: TextField.Password
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)
            readOnly: QmlInterface.processingUserLogin
            font.pixelSize: 15

            Layout.fillWidth: true
            Layout.preferredHeight: 60
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
            Layout.preferredWidth: 170
            Layout.alignment: Qt.AlignHCenter

            radius: height/2
            color: "#0677e9"

            Icon
            {
                id: spinIco
                size: 20
                color: "white"
                icon: "\uf3f4"
                visible: QmlInterface.processingUserLogin

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            AppText
            {
                color: "white"
                size: 18
                text: QmlInterface.processingUserLogin? qsTr("Signing In"):qsTr("Sign In")

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    if(QmlInterface.processingUserLogin === false)
                    {
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
                            QmlInterface.processingUserLogin = true;
                            QmlInterface.loginUser(email, password);
                        }
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

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    function resetFields()
    {
        email = ""
        password = ""
        QmlInterface.processingUserLogin = false;
    }

    Connections
    {
        target: QmlInterface

        function onLoginStatusChanged(state, status, isDoctor)
        {
            QmlInterface.processingUserLogin = false;

            loggedAsDoctor = isDoctor;

            // If switching accounts, reset this flag to restart sync timer
            // if(loggedAsDoctor)
            hasSyncedBefore = false;

            if(state)
            {
                stackIndex = 3
                resetFields();
                QmlInterface.isUserLoggedIn = true;
                QmlInterface.setDoctorMode(isDoctor);
            } else {
                infoPopup.open()
                infoPopup.info = status;
                infoPopup.infoLevel = 2
            }
        }
    }
}
