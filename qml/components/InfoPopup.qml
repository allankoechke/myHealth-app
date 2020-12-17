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

    background: Rectangle
    {
        id: bg
        color: infoLevel===0? "grey":infoLevel===1? "green":"orange"

        RowLayout{
            anchors.fill: parent
            spacing: 5

            Rectangle
            {
                Layout.fillHeight: true
                Layout.preferredWidth: 40

                color: Qt.darker(bg.color, 1.8)
                height: 1
                width: parent.width

                Icon
                {
                    color: "white"
                    size: 20
                    icon: infoLevel===0? "\uf129":infoLevel===1? "\uf128":"\uf12a"

                    anchors.centerIn: parent
                }
            }

            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true

                AppText
                {
                    id: txt
                    width: parent.width - 20
                    wrapMode: AppText.WordWrap
                    horizontalAlignment: AppText.AlignHCenter
                    size: 13
                    color: "white"

                    anchors.centerIn: parent
                }
            }

            Item{
                Layout.preferredWidth: 30
                Layout.fillHeight: true

                Icon
                {
                    color: "white"
                    size: 15
                    icon: "\uf00d"

                    anchors.centerIn: parent
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: root.close()
                }
            }

        }

    }
}
