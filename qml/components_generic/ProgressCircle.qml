import QtQuick 2.15

import ThemeEngine 1.0

// Based on the ProgressCircle component from ByteBau (Jörn Buchholz) @bytebau.com

Item {
    id: control
    width: 256
    height: width

    property real from: 0
    property real to: 1
    property real value: 0.5

    property bool isPie: false              // paint a pie instead of an arc

    property real arcOffset: 0              // rotation (0 means starts at top center)
    property real arcWidth: 16              // width of the arc
    property real arcOpacity: 1
    property string arcColor: Theme.colorPrimary

    property bool background: true          // a full circle as a background of the arc
    property real backgroundOpacity: 1
    property string backgroundColor: Theme.colorForeground

    property alias animationBegin: animationArcBegin.enabled
    property alias animationEnd: animationArcEnd.enabled
    property alias animationValue: animationArcValue.enabled
    property int animationDuration: 333

    // private
    property real arcBegin: 0
    property real arcEnd: 360
    property real arcValue: mapNumber(value, from, to, arcBegin, arcEnd)

    function mapNumber(n, srcMin, srcMax, dstMin, dstMax) {
        if (n < srcMin) n = srcMin
        if (n > srcMax) n = srcMax
        return (dstMin + ((n - srcMin) * (dstMax - dstMin)) / (srcMax - srcMin))
    }

    ////////////////////////////////////////////////////////////////////////////

    //onFromChanged: canvas.requestPaint()
    //onToChanged: canvas.requestPaint()
    //onValueChanged: canvas.requestPaint()

    onIsPieChanged: canvas.requestPaint()

    onArcBeginChanged: canvas.requestPaint()
    onArcEndChanged: canvas.requestPaint()
    onArcValueChanged: canvas.requestPaint()
    onArcWidthChanged: canvas.requestPaint()
    onArcColorChanged: canvas.requestPaint()
    onArcOpacityChanged: canvas.requestPaint()

    onBackgroundChanged: canvas.requestPaint()
    onBackgroundColorChanged: canvas.requestPaint()
    onBackgroundOpacityChanged: canvas.requestPaint()

    Connections {
        target: ThemeEngine
        function onCurrentThemeChanged() { canvas.requestPaint() }
    }

    Behavior on arcBegin {
       id: animationArcBegin
       enabled: true
       NumberAnimation {
           duration: control.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Behavior on arcEnd {
       id: animationArcEnd
       enabled: true
       NumberAnimation {
           duration: control.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    Behavior on arcValue {
       id: animationArcValue
       enabled: true
       NumberAnimation {
           duration: control.animationDuration
           easing.type: Easing.InOutCubic
       }
    }

    ////////////////////////////////////////////////////////////////////////////

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            var x = (width / 2)
            var y = (height / 2)
            var start = Math.PI * ((control.arcBegin + control.arcOffset - 90) / 180)
            var end = Math.PI * ((control.arcEnd + control.arcOffset - 90) / 180)
            var end_value = Math.PI * ((control.arcValue + control.arcOffset - 90) / 180)
            ctx.reset()

            // draw
            if (control.isPie) {
                if (control.background) {
                    ctx.beginPath()
                    ctx.globalAlpha = control.backgroundOpacity
                    ctx.fillStyle = control.backgroundColor
                    ctx.moveTo(x, y)
                    ctx.arc(x, y, (width / 2), start, end, false)
                    ctx.lineTo(x, y)
                    ctx.fill()
                }
                ctx.beginPath()
                ctx.globalAlpha = control.arcOpacity
                ctx.fillStyle = control.arcColor
                ctx.moveTo(x, y)
                ctx.arc(x, y, (width / 2), start, end_value, false)
                ctx.lineTo(x, y)
                ctx.fill()
            } else {
                if (control.background) {
                    ctx.beginPath()
                    ctx.globalAlpha = control.backgroundOpacity
                    ctx.arc(x, y, (width / 2) - (control.arcWidth / 2), start, end, false)
                    ctx.lineWidth = control.arcWidth
                    ctx.strokeStyle = control.backgroundColor
                    ctx.stroke()
                }
                ctx.beginPath()
                ctx.globalAlpha = control.arcOpacity
                ctx.arc(x, y, (width / 2) - (control.arcWidth / 2), start, end_value, false)
                ctx.lineWidth = control.arcWidth
                ctx.strokeStyle = control.arcColor
                ctx.stroke()
            }
        }
    }
}
