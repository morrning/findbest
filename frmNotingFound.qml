import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id: rectangle;
    width: mainForm.width;
    height: mainForm.height / 5;

    Image {
        id: networkErrorIcon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
                sourceSize.height: parent.height * 0.9
                sourceSize.width: parent.height * 0.9
                source: "icons/404.png"
    }
    Label{
        color: "#ca3157"
        text: "چیزی برای نمایش یافت نشد"
        anchors.top: networkErrorIcon.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
