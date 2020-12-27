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

    RotationAnimation
    {
        target: spinIco
        from: 0
        to: 360
        loops: RotationAnimation.Infinite
        running: QmlInterface.processingUserRegistration

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
            readOnly: QmlInterface.processingUserRegistration

            Layout.fillWidth: true
            Layout.preferredHeight: 40
        }

        TextField
        {
            id: email_
            placeholderText: qsTr("Email")
            Material.theme: Material.Dark
            Material.foreground: Qt.lighter("#c9cdd2", 1.5)
            readOnly: QmlInterface.processingUserRegistration

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
            readOnly: QmlInterface.processingUserRegistration

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
            readOnly: QmlInterface.processingUserRegistration

            Layout.fillWidth: true
            Layout.preferredHeight: 40
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

                visible: QmlInterface.processingUserRegistration

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            AppText
            {
                color: "white"
                size: 18
                text: QmlInterface.processingUserRegistration? qsTr("Signing Up"):qsTr("Sign Up")

                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked: {

                    if(QmlInterface.processingUserRegistration === false)
                    {
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
                            QmlInterface.processingUserRegistration = true;
                            QmlInterface.addUser(fullname, 23, email, 2547768423, password)
                        }
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

    Connections
    {
        target: QmlInterface

        function onAccountCreatedSuccessfully(status)
        {
            QmlInterface.processingUserRegistration = false;
            stackIndex = 1
            resetFields()
        }

        function onEmailAlreadyExists()
        {
            QmlInterface.processingUserRegistration = false;
            infoPopup.open()
            infoPopup.infoLevel = 2
            infoPopup.info = "Email exists"
        }

        function onAccountCreationFailed(error)
        {
            QmlInterface.processingUserRegistration = false;
            infoPopup.open()
            infoPopup.infoLevel = 2
            infoPopup.info = error
        }
    }
}
