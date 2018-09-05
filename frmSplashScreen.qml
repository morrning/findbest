import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import io.qt.Backend 1.0

Rectangle{
    id: rectangle
    width: parent.width
    height: parent.height
    color: "#ffffff"

    Image {
        id: appIcon
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.height: parent.width / 2
        sourceSize.width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        source: "icons/ic_launcher.png"
    }

    Label{
        text: "به آسانی بخرید و بفروشید"
        font.pointSize: 15
        font.family: "Sahel"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: appIcon.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

    }

}
