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
    property alias msgPopup: msgPopup
    property alias deviceSwipeView: deviceSwipeView
    property alias addDevicePopup: newDevicePopup
    property string lastSyncDate: "Never";
    property bool hasSyncedBefore: false
    property bool msgPopup_isOpen: false

    Timer
    {
        id: switchToLogin
        running: hasSyncedBefore
        interval: 3500
        repeat: false

        onTriggered: {
            splashView.pb.indeterminate = false
            stackIndex = 1;
        }
    }

    Timer
    {
        id: lastSyncTimer
        running: true
        interval: 1000
        repeat: true

        onTriggered: {

            if(hasSyncedBefore)
            {
                let t = QmlInterface.getTimerIntervalBetweenSync();

                if(t<60)
                {
                    lastSyncDate = t.toString() + "s ago";
                }

                else if(t>=60 && t<3600)
                {
                    const mins = Math.floor(t/60)
                    console.log(">> ", mins, " ", mins.toString())
                    lastSyncDate = mins + (mins===1? "min ago":"mins ago");
                }

                else if(t>=3600 && t<86400)
                {
                    const hr = Math.floor(t/3600)
                    lastSyncDate = hr + (hr===1? "hour ago":"hours ago");
                }

                else
                {
                    lastSyncDate = "A couple of days ago";
                }
            }
            // console.log("Time Interval: ", t)
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

        DoctorReplyView
        {
            // 5
            id: searchView
        }
    }

    MenuDrawer
    {
        id: menuDrawer
    }

    MessagePopup
    {
        id: msgPopup
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
