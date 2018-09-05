import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0

Item {

    id: mainForm
    //define properties


    property int itemsPage: 1



    //item model
    ListModel {
        id: itemsModel

    }
    function appLoadItems(pageNum){

        var http = new XMLHttpRequest()
        var url = window.siteAdr + "/json/ads/last/" + pageNum;
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
                            mainForm.itemsPage ++ ;


                        } else {
                            var networkError = Qt.createComponent("frmNetworkError.qml")
                            networkError.createObject(allAdsItems,{"width": parent.width, "y": 250})

                            console.log("error: " + http.status)
                        }
                        //stop show loading on page
                        pageLoading.running = false
                    }
                }
        http.send(params);
    }

    Component.onCompleted: {
        //create local database

        localDB.transaction(
                    function(tx) {
                        // Create the database if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS flags(ids TEXT)');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS reports(ids TEXT)');
                    }
        )

        allAdsItems.model = itemsModel
        mainForm.appLoadItems(mainForm.itemsPage)
    }

    Rectangle {
        id: recTitleApp
        anchors.bottomMargin: mainForm.height * 0.9
        anchors.fill: parent
        z:4
        Button {
            id: button
            height: 40
            text: "\uf0b0"
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            font.family: fontAwesomeSolid.name
            display: AbstractButton.TextBesideIcon
            anchors.left: parent.left
            anchors.leftMargin: mainForm.width * 0.05
            anchors.verticalCenter: parent.verticalCenter
            highlighted: true
            Material.accent: Material.color(Material.Red)
            width: mainForm.width * 0.1
        }

        TextField {
            id: txtSearch
            width: mainForm.width * 0.78
            text: qsTr("")
            font.pointSize: 12
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.right
            anchors.rightMargin: mainForm.width * 0.05
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: "جست و جو..."
        }
    }



    BusyIndicator {
        id: pageLoading
        z:200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: image.status === Image.Loading
    }

    ListView {
        width: parent.width
        z:2
        height: parent.height * 0.9
        id: allAdsItems
        anchors.top: parent.top
        anchors.topMargin: mainForm.height * 0.1
        spacing: 5
        clip: true
        delegate: Rectangle {
            id: recItemDelegate
            height: 150
            width: mainForm.width
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
            Image {
                id: itemImage
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                sourceSize.height: mainForm.height /5
                sourceSize.width: mainForm.width /3
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

        // Stuff
        onAtYEndChanged: {
          if (allAdsItems.atYEnd) {
            // Loading tail messages...
              if(mainForm.itemsPage != 1){
                  pageLoading.running = true
                  mainForm.appLoadItems(mainForm.itemsPage)
              }


          }
          else{
              pageLoading.running = false
          }
        }

    }


}
