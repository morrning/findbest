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


    Image {
        id: appIcon
        sourceSize.height: parent.width / 2
        sourceSize.width: parent.width / 2
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        source: "icons/ic_launcher.png"
    }
    Label{
        id:appLabel
        color: "#701689"
        text: qsTr("بهترین‌ها")
        anchors.top: appIcon.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    Label{
        id:versionLabel
        color: "#701689"
        text: qsTr("نسخه:1.0.0.20")
        anchors.top: appLabel.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    Label{
        id:companyLabel
        color: "#701689"
        text: qsTr("کاری از توسعه فناوری سرکش")
        anchors.top: versionLabel.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 12
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    Label{
        id:copyrightLabel
        color: "#701689"
        text: qsTr("این نرم افزار به صورت رایگان و متن باز منتشر شده است.")
        anchors.top: companyLabel.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width - 10
        wrapMode: Label.WordWrap

    }

}
