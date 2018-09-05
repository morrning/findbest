import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import io.qt.Backend 1.0


ApplicationWindow {
    property bool mirror: Qt.application.layoutDirection == Qt.RightToLeft
    LayoutMirroring.enabled: mirror
    LayoutMirroring.childrenInherit: true
    FontLoader { id: localFont; source: "fonts/Sahel.ttf" }
    property string siteAdr: "http://chooz.ir/index.php"
    property string siteRootImagesPath: "http://chooz.ir/images/"
    property var localDB : LocalStorage.openDatabaseSync("findbestdb","1.0")
    property var adsObjects
    property int activeADS : 0
    Component.onCompleted: {
        /*
          Load main page for show ADS
          */

        var objFrmMainPage = Qt.createComponent("frmMainAdsWindow.qml")
        areaPageStack.push(objFrmMainPage)

    }


    id: window
    visible: true
    width: 400
    height: 640
    color: "white"
    title: qsTr("بهترین‌ها")
    Material.theme: Material.Light
    font.family: 'Sahel'
    /*
      This part is for connect QML to CPP class

      */
    Backend {
        id: backend
    }

    signal qmlEndPage()

    onQmlEndPage: {
        areaPageStack.pop()
    }




    FontLoader {
        id:fontAwesomeStandard
        source: "qrc:/icons/Font Awesome 5 Pro-Light-300.otf"
    }

    FontLoader {
        id:fontAwesomeBrand
        source: "qrc:/icons/Font Awesome 5 Pro-Regular-400.otf"
    }

    FontLoader {
        id:fontAwesomeSolid
        source: "qrc:/icons/Font Awesome 5 Pro-Solid-900.otf"
    }

    Loader{
        id:splashScreen
        anchors.fill: parent
        z:300
        source: "frmSplashScreen.qml"

    }
    Timer {
            interval: 1000; running: true; repeat: true
            onTriggered:{
                splashScreen.visible = false
            }

    }


    header: ToolBar {
        Material.background: Material.primary
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "\uf039"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                display: AbstractButton.TextOnly
                font.family: fontAwesomeSolid.name
                onClicked: mainDrawer.open()
            }

            Label {
                text: qsTr("بهترین‌ها")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.family: 'Sahel'
            }

            ToolButton {
                text: "\uf55a"
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                display: AbstractButton.TextOnly
                font.family: fontAwesomeSolid.name
                onClicked: {
                    mainDrawer.close()
                    areaPageStack.clear()
                     var objFrmNewADS = Qt.createComponent("frmMainAdsWindow.qml")
                     areaPageStack.push(objFrmNewADS)
                }
            }

        }

    }

    Drawer {

        id: mainDrawer
        width: 0.66 * window.width
        height: window.height
        edge: Qt.RightEdge
        Rectangle{
            id: areaAppProfile
            color:"#be0fa8"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            height: parent.height * 0.3

            Image {
                id: appIcon
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                sourceSize.height: parent.height * 0.4
                sourceSize.width: parent.height * 0.4
                anchors.horizontalCenter: parent.horizontalCenter
                source: "icons/ic_launcher.png"
            }
            Label {
                id: name
                y: parent.height * 0.6
                color: "#ffffff"
                text: qsTr("به آسانی بخرید و بفروشید")
                font.capitalization: Font.MixedCase
                font.family: "Sahel"
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenterOffset: 0
                anchors.topMargin: 100
                anchors.horizontalCenter: appIcon.horizontalCenter
                Material.foreground: "white"
            }
        }

        GridLayout{
            id:glDrawerOptions
            anchors.left: parent.left
            anchors.leftMargin: mainDrawer.width * 0.2
            anchors.top: parent.top
            anchors.topMargin: areaAppProfile.height * 1.2
            columnSpacing: 20
            rowSpacing: 10
            layoutDirection: Qt.LeftToRight
            antialiasing: true
            scale: 1.2
            columns: 2
            rows:7
            flow: GridLayout.TopToBottom
            Label {
                text: "\uf015"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf067"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf007"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf005"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf013"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf05a"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf44f"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label{
                id:laNewADS
                text:"آخرین آگهی‌ها"
                MouseArea{
                    id:maNewADS
                    anchors.fill: parent
                    onClicked: {
                        mainDrawer.close()
                        areaPageStack.clear()
                         var objFrmNewADS = Qt.createComponent("frmMainAdsWindow.qml")
                         areaPageStack.push(objFrmNewADS)
                    }


                }
            }
            Label{
                id:laHome
                text:"آگهی جدید"
                MouseArea{
                    id:maHome
                    anchors.fill: parent
                    onClicked: {
                        mainDrawer.close()
                         var objFrmNewADS = Qt.createComponent("frmNewADS.qml")
                         areaPageStack.push(objFrmNewADS)
                    }


                }
            }
            Label{
                text:"آگهی‌های من"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         mainDrawer.close()
                         var objFrmMyADS = Qt.createComponent("frmMyADS.qml")
                         areaPageStack.push(objFrmMyADS)
                    }
                }
            }
            Label{
                text:"نشان شده‌ها"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         mainDrawer.close()
                         var objFrmStaredADS = Qt.createComponent("frmStaredADS.qml")
                         areaPageStack.push(objFrmStaredADS)
                    }
                }
            }
            Label{
                text:"تنظیمات"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         mainDrawer.close()
                         var objFrmStaredADS = Qt.createComponent("frmStaredADS.qml")
                         areaPageStack.push(objFrmStaredADS)
                    }
                }
            }
            Label{
                text:"درباره ما"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         mainDrawer.close()
                         var objFrmStaredADS = Qt.createComponent("frmAboutUs.qml")
                         areaPageStack.push(objFrmStaredADS)
                    }
                }
            }
            Label{
                text:"امن خرید کنید"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         mainDrawer.close()
                         Qt.openUrlExternally("http://sarkesh.org/findbest/notice/safetynotice");
                    }
                }
            }

        }

        Button {
            Label{
                text: "\uf2f5"
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
               font.family: fontAwesomeSolid.name
               color: "white"
            }
            id: btnExit
            text: qsTr("خروج")
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.bottom: parent.bottom
            width: parent.width / 3
            enabled: true
            focusPolicy: Qt.StrongFocus
            highlighted: true
            onClicked: window.close()
            Material.accent: Material.color(Material.Red)
        }

    }
    Item {
        id: areaBody
        anchors.fill: parent

        StackView {
            id: areaPageStack
            anchors.fill: parent
        }


    }
}
