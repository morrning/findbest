import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0

Item {

    id: staredADS
    property var localDB : LocalStorage.openDatabaseSync("findbestdb","1.0")


    //item model
    ListModel {
        id: itemsModel

    }
    function appLoadStaredItems(){

        //feach ids
        var ids = [];
        var i;
        localDB.transaction(function (tx) {

            var searchRes = tx.executeSql('SELECT * FROM flags')
            for (i = 0; i < searchRes.rows.length; i++) {
               ids.push(searchRes.rows.item(i).ids)
            }

        })

        if(i === 0){
            //show nothing found message
            var notingFound = Qt.createComponent("frmNotingFound.qml")
            notingFound.createObject(allAdsItems,{"width": parent.width, "y": 250})
            return 0;
        }

        //--------------------------------------------

        var http = new XMLHttpRequest()
        var url = window.siteAdr + "/json/ads/load/some/" + ids.join();
        var params = "";
        http.open("POST", url, true);
        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        if (http.status == 200) {

                            var tst = JSON.parse(http.responseText).callBack
                            window.adsObjects = JSON.parse(tst)
                            var i;
                            for (i = 0; i < window.adsObjects.length; i++) {
                                itemsModel.append({
                                                        index:window.adsObjects[i].id,
                                                        price:window.adsObjects[i].price,
                                                        title:window.adsObjects[i].adsTitle,
                                                        moneyType : window.adsObjects[i].moneyType,
                                                        masterImage: window.adsObjects[i].masterImage
                                                    });
                            }


                        } else {
                            var networkError = Qt.createComponent("frmNetworkError.qml")
                            networkError.createObject(allAdsItems,{"width": parent.width, "y": 250})
                            console.log("error: " + http.status)
                        }

                    }
                }
        http.send(params);

    }

    Component.onCompleted: {

        appLoadStaredItems()
        allAdsItems.model = itemsModel

    }

    Rectangle {
        id: recTitleApp
        anchors.bottomMargin: staredADS.height * 0.9
        anchors.fill: parent
        color: Material.color(Material.LightBlue)
        z:4
        Label {
            id:flagIcon
            text: "\uf005"
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            font.family: fontAwesomeSolid.name

        }
        Label{

            text: "آگهی‌های نشان شده شما"
            anchors.left: flagIcon.right
            anchors.leftMargin: 15
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Sahel"
            color: "white"
        }
    }


    ListView {
        width: parent.width
        z:2
        height: parent.height * 0.9
        id: allAdsItems
        anchors.top: parent.top
        anchors.topMargin: window.height * 0.1
        spacing: 5
        clip: true
        delegate: Rectangle {
            id: recItemDelegate
            height: 150
            width: window.width
            property bool mirror: Qt.application.layoutDirection == Qt.LeftToRight
            LayoutMirroring.enabled: mirror
            LayoutMirroring.childrenInherit: true
            z:2
            Text {
                color: "#545454"
                text: title
                anchors.horizontalCenter: recItemDelegate.horizontalCenter
                anchors.leftMargin: 15
                font.pixelSize: 15
                anchors.left: recItemDelegate.left
                anchors.verticalCenter: recItemDelegate.verticalCenter
                font.family: "Sahel"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.top: recItemDelegate.top
                anchors.topMargin: 25
                width: parent.width - (itemImage.width + 15)
                wrapMode: Label.WordWrap
                property bool mirror: Qt.application.layoutDirection == Qt.RightToLeft
                LayoutMirroring.enabled: mirror
            }
            Text {
                color: "#8f8f8f"
                font.family: "Sahel"
                text: "قیمت: " + price + " " + moneyType
                anchors.left: parent.left
                anchors.leftMargin: 15
                font.pointSize: 10
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 25
                property bool mirror: Qt.application.layoutDirection == Qt.RightToLeft
                LayoutMirroring.enabled: mirror

            }
            Button {
                Label{
                    text: "\uf057"
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                   font.family: fontAwesomeSolid.name
                   color: "white"
                }
                id: btnExit
                text: qsTr("حذف")
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 15
                width: 75
                enabled: true
                focusPolicy: Qt.StrongFocus
                highlighted: true
                Material.accent: Material.color(Material.Red)
                onClicked: {
                    window.localDB.transaction(function (tx) {
                        tx.executeSql("DELETE FROM flags WHERE ids=?",index.toString())
                    })
                    itemsModel.remove(allAdsItems.currentIndex + 1)
                }
                z:400
            }
            Image {
                id: itemImage
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                sourceSize.height: window.height /5
                sourceSize.width: window.width /3
                source: window.siteRootImagesPath + masterImage
            }

            Text {
                text: "_________________________________________________________________________________________________________________"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                color: "#d4d4d4"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var itemAds = Qt.createComponent('FrmItemInList.qml')
                    window.activeADS = index
                    areaPageStack.push(itemAds)
                }
            }


        }

    }

}
