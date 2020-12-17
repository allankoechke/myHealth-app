import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12

import "views"
import "components"

ApplicationWindow {
    id: mainAppView
    width: 320
    height: 568
    visible: true
    title: qsTr("myHealth App")

    property string bgColor: "#071e28"
    property string bgColorLighter: "#082835"
    property string foreBlue: "#60b6ec"
    property string foreGrey: "#6c7d85"
    property string temperatureColor: "#06db0b"
    property string hearRateColor: "#ec0606"
    property string respirationRateColor: "#ecd006"
    property string pressureColor: "#e606c7"
    property string spo2Color: "#17b5da"

    property alias fontAwesomeFontLoader: fontAwesomeFontLoader
    property alias goBoldFontLoader: goBoldFontLoader

    Material.theme: Material.Dark

    AppView
    {
        id: appView
        anchors.fill: parent
    }

    FontLoader
    {
        id: fontAwesomeFontLoader
        source: "qrc:/assets/fonts/fontawesome.otf"
    }

    FontLoader
    {
        id: goBoldFontLoader
        source: "qrc:/assets/fonts/Gobold Regular.otf"
    }

    Component.onCompleted: QmlInterface.isUserLoggedIn = false;
}
