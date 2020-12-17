import QtQuick 2.12
import QtQuick.Layouts 1.3

import "../components"

Rectangle {
    id: appView
    color: bgColor

    property var stackIndex: 0
    property alias spinner: spinner
    property alias infoPopup: infoPopup
    property alias menuDrawer: menuDrawer
    property alias deviceSwipeView: deviceSwipeView
    property alias addDevicePopup: newDevicePopup

    Timer
    {
        id: switchToLogin
        running: false
        interval: 3500
        repeat: false

        onTriggered: {
            splashView.pb.indeterminate = false
            stackIndex = 1;
        }
    }

    StackLayout
    {
        anchors.fill: parent
        currentIndex: stackIndex

        SplashView
        {
            // 0
            id: splashView
        }

        LoginView
        {
            // 1
            id: loginView
        }

        SignUpView
        {
            // 2
            id: signUpView
        }

        DeviceSwipeView
        {
            // 3
            id: deviceSwipeView
        }

        SettingsView
        {
            // 4
            id: settingsView
        }

        SearchView
        {
            // 5
            id: searchView
        }
    }

    MenuDrawer
    {
        id: menuDrawer
    }

    InfoPopup
    {
        id: infoPopup
    }

    NewDevicePopup
    {
        id: newDevicePopup
    }

    SpinnerLoader
    {
        id: spinner
    }

}
