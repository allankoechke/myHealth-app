import QtQuick 2.7
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Item {
    id: root
    width: 100
    height: 100
    visible: true

    property alias source: img.source
    property alias radius: mask.radius

    Image {
        id: img
        width: parent.height
        height: width
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: mask
        width: parent.height
        height: width
        radius: height/2
        visible: false
    }
}
