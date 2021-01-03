import QtQuick 2.12
import QtCharts 2.3
import QtQuick.Layouts 1.3

ChartView
{
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
        // min: 0; max: 10
        // labelFormat: "%.0f"
        // labelsFont:Qt.font({pixelSize: 8})
        // labelsColor: "grey"
        visible: false
    }

    ValueAxis
    {
        id: yAxis
        labelFormat: "%.0f"
        min: 0; max: 121
        labelsFont:Qt.font({pointSize: 6})
    }

    SplineSeries
    {
        id: temperatureGraph
        axisX: xAxis
        axisY: yAxis
        color: temperatureColor

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    SplineSeries
    {
        id: rrGraph
        axisX: xAxis
        axisY: yAxis
        color: respirationRateColor

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    SplineSeries
    {
        id: bpmGraph
        axisX: xAxis
        axisY: yAxis

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    SplineSeries
    {
        id: spo2Graph
        axisX: xAxis
        axisY: yAxis

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    SplineSeries
    {
        id: sysGraph
        axisX: xAxis
        axisY: yAxis

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    SplineSeries
    {
        id: diaGraph
        axisX: xAxis
        axisY: yAxis

        XYPoint { x: 0; y: 0 }
        XYPoint { x: 1; y: 0 }
        XYPoint { x: 2; y: 0 }
        XYPoint { x: 3; y: 0 }
        XYPoint { x: 4; y: 0 }
        XYPoint { x: 5; y: 0 }
        XYPoint { x: 6; y: 0 }
        XYPoint { x: 7; y: 0 }
        XYPoint { x: 8; y: 0 }
        XYPoint { x: 9; y: 0 }
    }

    Connections
    {
        target: QmlInterface

        function onChartDataReceived(x_, data)
        {
            //console.log("X: [9] ", temperatureGraph.at(9).x, " - [0] ", temperatureGraph.at(0).x)
            // 34.5:17:72:94:120:80
            var arr = data.split(":")

            var xVal = temperatureGraph.at(9).x + 1

            if(arr.length===6)
            {
                // console.log("x: ", xVal, "\tArray: ", arr, "\tParse: ", parseFloat(arr[0]))

                xAxis.min = xVal-9
                xAxis.max = xVal

                temperatureGraph.remove(0)
                temperatureGraph.append(xVal, parseFloat(arr[0]))

                rrGraph.remove(0)
                rrGraph.append(xVal, parseFloat(arr[1]))

                bpmGraph.remove(0)
                bpmGraph.append(xVal, parseFloat(arr[2]))

                spo2Graph.remove(0)
                spo2Graph.append(xVal, parseFloat(arr[3]))

                sysGraph.remove(0)
                sysGraph.append(xVal, parseFloat(arr[4]))

                diaGraph.remove(0)
                diaGraph.append(xVal, parseFloat(arr[5]))

            } else {
                console.log("No Data Supplied!");
            }
        }
    }
}

