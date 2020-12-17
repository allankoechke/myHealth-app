import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3


Item {

    property alias label: label.text
    property alias labelSize: label.size
    property alias icon: ico.icon
    property alias value: val.text
    property alias unit: units.text
    property string colorFormat: temperatureColor

    Layout.preferredHeight: val.height

    RowLayout
    {
        anchors.fill: parent
        // anchors.margins: 3
        spacing: 3

        Item {
            id: nameNicon
            Layout.fillHeight: true
            Layout.preferredWidth: 40

            ColumnLayout
            {
                anchors.fill: parent
                spacing: 3

                AppText {
                    id: label
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    verticalAlignment: AppText.AlignVCenter
                    horizontalAlignment: AppText.AlignHCenter

                    text: qsTr("TEMP")
                    color: colorFormat
                    family: goBoldFontLoader.name
                    size: 13
                }

                Icon
                {
                    id: ico
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    size: 20
                    color: colorFormat
                }
            }
        }

        AppText {
            id: val
            // Layout.fillHeight: true
            Layout.fillWidth: true
            verticalAlignment: AppText.AlignVCenter
            horizontalAlignment: AppText.AlignHCenter

            color: colorFormat
            text: qsTr("36.3")
            size: 35
            family: goBoldFontLoader.name
        }

        AppText {
            id: units
            Layout.fillHeight: true
            Layout.preferredWidth: 40
            verticalAlignment: AppText.AlignBottom
            horizontalAlignment: AppText.AlignHCenter

            text: qsTr("C")
            color: colorFormat
            size: 12
            family: goBoldFontLoader.name
        }
    }
}
