import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.2

Item {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias pb: pb

    Timer
    {
        interval: 10
        repeat: true
        running: true

        onTriggered:
        {
            if(pb.value < pb.to)
            {
                pb.value = pb.value + 10

            }

            else
            {
                running = false;
                pb.indeterminate = true
                switchToLogin.start();
            }
        }
    }

    ColumnLayout
    {
        anchors.centerIn: parent

        Image
        {
            Layout.preferredWidth: 200
            Layout.preferredHeight: 80
            source: "qrc:/assets/myHealth-logo.png"
            Layout.alignment: Qt.AlignHCenter
        }

        ProgressBar
        {
            id: pb
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            from: 0
            to: 5000
            value: 0
            Material.theme: Material.Dark
            Material.foreground: "green"
            Material.accent: "#0677e9"
            Material.background: "white"
        }
    }
}
