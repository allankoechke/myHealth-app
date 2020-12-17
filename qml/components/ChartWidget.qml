import QtQuick 2.12
import QtCharts 2.3
import QtQuick.Layouts 1.3

ChartView
{
    Layout.fillWidth: true
    Layout.preferredHeight: 150

    antialiasing: true
    legend.visible: false
    margins.left: 0
    margins.right: 0
    margins.top: 0
    margins.bottom: 0
    backgroundColor: bgColor

    ValueAxis
    {
        id: xAxis
        min: 0; max: 7
        labelFormat: "%.0f"
        labelsFont:Qt.font({pixelSize: 8})
        labelsColor: "grey"
    }

    ValueAxis
    {
        id: yAxis
        labelFormat: "%.0f"
        labelsFont:Qt.font({pointSize: 6})
    }

    SplineSeries
    {
        axisX: xAxis
        axisY: yAxis

        XYPoint { x: 0; y: 34.5 }
        XYPoint { x: 1; y: 35.5 }
        XYPoint { x: 2; y: 36.4 }
        XYPoint { x: 3; y: 35.7 }
        XYPoint { x: 4; y: 36.7 }
        XYPoint { x: 5; y: 35.5 }
        XYPoint { x: 6; y: 37.0 }
        XYPoint { x: 7; y: 36.5 }
    }
}

