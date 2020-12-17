import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root

    width: 230
    height: 40
    modal: true
    closePolicy: Popup.NoAutoClose

    x: (mainAppView.width-width)/2
    y: (mainAppView.height-height)/2

    property int infoLevel: 0
    property alias info: txt.text

    property bool isLoading: false

    RotationAnimation
    {
        target: ico
        from: 0; to: 360
        duration: 700
        loops: RotationAnimation.Infinite
        running: isLoading

        onRunningChanged: {
            if(!isLoading)
            {
                ico.rotation = 0;
            }
        }
    }

    background: Rectangle
    {
        id: bg
        color: Qt.lighter(bgColor, 1.3)

        RowLayout{
            anchors.fill: parent
            spacing: 5

            Item
            {
                Layout.fillHeight: true
                Layout.preferredWidth: 40

                Icon
                {
                    id: ico
                    color: "white"
                    size: 25
                    icon: "\uf110"

                    anchors.centerIn: parent
                }
            }


            AppText
            {
                id: txt

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                wrapMode: AppText.WordWrap
                horizontalAlignment: AppText.AlignLeft
                size: 12
                color: "white"
                text: "Loading, please wait ..."
            }
        }
    }
}
