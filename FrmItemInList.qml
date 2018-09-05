import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import QtPositioning 5.8
import QtLocation 5.6
import io.qt.Backend 1.0


Rectangle{
    property string itemAdsID: "0"
    property string mapx: "0"
    property string mapy: "0"

    id: adsDesArea
    anchors.fill: parent
    function appReportItem(id){
        var http = new XMLHttpRequest()
        var url = window.siteAdr + "/json/ads/report/" + id;
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
                            console.log(tst)
                        } else {
                            var networkError = Qt.createComponent("frmNetworkError.qml")
                            networkError.createObject(allAdsItems,{"width": parent.width, "y": 250})
                            console.log("error: " + http.status)
                        }

                    }
                     pageLoading.running = false
                }
        http.send(params);
    }

    function appLoadItem(id){
        var http = new XMLHttpRequest()
        var url = window.siteAdr + "/json/ads/get/" + id;
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
                            var adsObjects = JSON.parse(tst)
                            adsDesArea.itemAdsID = adsObjects.id
                            adsImage.source = window.siteRootImagesPath + adsObjects.masterImage
                            lblTitle.text = adsObjects.adsTitle
                            lblDes.text =  adsObjects.adsDes
                            lblPrice.text =  "قیمت: " + adsObjects.price + " " + adsObjects.moneyType
                            lblTel.text = "تلفن: " + adsObjects.tel
                            lblEmail.text = "پست الکترونیکی: " + adsObjects.email
                            var mapString = adsObjects.location
                            var locArray = mapString.split("MM")
                            adsDesArea.mapx = locArray[0]
                            adsDesArea.mapy = locArray[1]
                        } else {
                            var networkError = Qt.createComponent("frmNetworkError.qml")
                            networkError.createObject(allAdsItems,{"width": parent.width, "y": 250})
                            console.log("error: " + http.status)
                        }

                    }
                     pageLoading.running = false
                }
        http.send(params);
    }
    function isFlaged(id){
        window.localDB.transaction(function (tx) {
                var searchRes = tx.executeSql('SELECT * FROM flags WHERE ids=?',id)
                if(searchRes.rows.length === 1){
                    btnFlagADS.text = "نشان شده"
                    btnFlagADS.enabled = false
                }
        })
    }
    function isReported(id){
        window.localDB.transaction(function (tx) {
                var searchRes = tx.executeSql('SELECT * FROM reports WHERE ids=?',id)
                if(searchRes.rows.length === 1){
                    btnReportADS.text = "گزارش شده"
                    btnReportADS.enabled = false
                }
        })
    }

    Component.onCompleted: {
        pageLoading.running = true
        //load item details
        appLoadItem(window.activeADS)
        //load flags
        isFlaged(window.activeADS)
        //check reported
        isReported(window.activeADS)



    }

    ScrollView {
        id:sv
        anchors.bottomMargin: 30
        anchors.fill: parent
            Rectangle {
                id:adsDetailBlock
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 30
                height: mapView.height + adsImage.height + lblDes.height + lblTitle.height + lblPrice.height + contactArea.height + lblPoliceNotic.height +  350

                Image {
                 id: adsImage
                 sourceSize.height: parent.width
                 sourceSize.width: parent.width
                 anchors.top: parent.top
                 anchors.topMargin: 0
                 anchors.horizontalCenter: parent.horizontalCenter
                 source: "icons/sampleImage.png"
                 }
                 Label{
                 id:lblTitle
                 width: parent.width - 30
                 text: "در حال بارگزاری ..."
                 anchors.left: parent.left
                 anchors.leftMargin: 20
                 anchors.top: adsImage.bottom
                 anchors.topMargin: 20
                 font.family: "Sahel"
                 font.pointSize: 15
                 verticalAlignment: Text.AlignVCenter
                 wrapMode: Label.WordWrap

                 }
                 Label{
                 id: lblDes
                 text: ""
                 anchors.right: parent.right
                 anchors.rightMargin: 20
                 anchors.left: parent.left
                 anchors.leftMargin: 20
                 anchors.top: lblTitle.bottom
                 anchors.topMargin: 20
                 font.family: "Sahel"
                 font.pointSize: 12
                 verticalAlignment: Text.AlignVCenter
                 wrapMode: Label.WordWrap

                 }
                 Label{
                 id: lblPrice
                 width: parent.width - 30
                 color: "#484e53"
                 text: "قیمت: 125.000 تومان"
                 anchors.left: parent.left
                 anchors.leftMargin: 20
                 anchors.top: lblDes.bottom
                 anchors.topMargin: 20
                 font.family: "Sahel"
                 font.pointSize: 12
                 verticalAlignment: Text.AlignVCenter
                 wrapMode: Label.WordWrap

                 }

                 Text {
                 id: line1
                 text: "_________________________________________________________________________________________________________________"
                 anchors.top: lblPrice.top
                 anchors.topMargin: 30
                 color: "#d4d4d4"
                 }

                 Label{
                 id: lblDestance
                 width: parent.width - 30
                 color: "#484e53"
                 text: "زمان و مکان: نیم ساعت پیش در ۳.۵ کیلومتری شما"
                 anchors.left: parent.left
                 anchors.leftMargin: 20
                 anchors.top: line1.bottom
                 anchors.topMargin: 20
                 font.family: "Sahel"
                 font.pointSize: 12
                 verticalAlignment: Text.AlignVCenter
                 wrapMode: Label.WordWrap

                 }

                 Plugin {
                         id: mapPlugin
                         name: "osm" // "mapboxgl", "esri", ...
                         // specify plugin parameters if necessary
                         // PluginParameter {
                         //     name:
                         //     value:
                         // }
                 }

                 Map {
                     id:mapView
                     plugin: mapPlugin
                     anchors.top: lblDestance.bottom
                     anchors.topMargin: 40
                     width: parent.width
                     height: window.width
                     center: QtPositioning.coordinate(adsDesArea.mapy, adsDesArea.mapx) // ads location
                     zoomLevel: 17

                 }

                 Row{
                     id: rowBtn
                     anchors.top: mapView.bottom
                     anchors.topMargin: 40
                     anchors.horizontalCenter: parent.horizontalCenter
                     width: parent.width - 30
                     Button{
                         id: btnReportADS
                         Label{
                             text: "\uf071"
                             anchors.left: parent.left
                             anchors.leftMargin: 10
                             anchors.verticalCenter: parent.verticalCenter
                             verticalAlignment: Text.AlignVCenter
                            font.family: fontAwesomeSolid.name
                         }
                         text: "گزارش آگهی"
                         font.family: "Sahel"
                         display: AbstractButton.TextBesideIcon
                         anchors.left: parent.left
                         anchors.leftMargin: 0
                         anchors.verticalCenter: parent.verticalCenter
                         width: (parent.width / 2) - 5
                         highlighted: true
                         Material.accent: Material.color(Material.Red)
                         onClicked: {
                             appReportItem(itemAdsID)
                             window.localDB.transaction(function (tx) {
                                     var searchRes = tx.executeSql('SELECT * FROM reports WHERE ids=?',itemAdsID)
                                     if(searchRes.rows.length === 0){
                                         window.localDB.transaction(function (tx) {
                                                 var results = tx.executeSql('INSERT INTO reports VALUES(?)',itemAdsID)
                                                 btnReportADS.text = "گزارش شده"
                                                 btnReportADS.enabled = false
                                         })
                                     }
                             })
                         }

                     }
                     Button{
                         id: btnFlagADS
                         Label{
                             color: "#ffffff"
                             text: "\uf11e"
                             anchors.left: parent.left
                             anchors.leftMargin: 10
                             anchors.verticalCenter: parent.verticalCenter
                             verticalAlignment: Text.AlignVCenter
                            font.family: fontAwesomeSolid.name
                         }

                         text: "نشان کن"
                         font.family: "Sahel"
                         anchors.right: parent.right
                         anchors.rightMargin: 0
                         anchors.verticalCenter: parent.verticalCenter
                         width: (parent.width / 2) - 5
                         highlighted: true
                        Material.accent: Material.color(Material.LightBlue)
                        onClicked: {
                            window.localDB.transaction(function (tx) {
                                    var searchRes = tx.executeSql('SELECT * FROM flags WHERE ids=?',itemAdsID)
                                    if(searchRes.rows.length === 0){
                                        window.localDB.transaction(function (tx) {
                                                var results = tx.executeSql('INSERT INTO flags VALUES(?)',itemAdsID)
                                                btnFlagADS.text = "نشان شده"
                                                btnFlagADS.enabled = false
                                        })
                                    }
                            })
                        }

                     }
                 }

                 Text {
                 id: line2
                 text: "_________________________________________________________________________________________________________________"
                 anchors.top: rowBtn.top
                 anchors.topMargin: 30
                 color: "#d4d4d4"
                 }

                 Label{
                     id: lblPoliceNotic
                     width: parent.width - 30
                     color: Material.color(Material.Red)
                     text: "هشدار پلیس:
لطفا پیش از انجام معامله و هر نوع پرداخت وجه، از صحت کالا یا خدمات ارائه شده، به صورت حضوری اطمینان حاصل نمایید."
                     anchors.left: parent.left
                     anchors.leftMargin: 20
                     anchors.top: line2.bottom
                     anchors.topMargin: 20
                     font.family: "Sahel"
                     font.pointSize: 12
                     verticalAlignment: Text.AlignVCenter
                     wrapMode: Label.WordWrap

                 }
            }

            contentHeight: adsDetailBlock.height
            contentWidth: parent.width
    }
    Rectangle{
        id: contactArea

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: parent.height / 8
        color: "#f2f2f2"
        border.color: "#e4e0e0"

        Button {
            id: btnCom
            text: qsTr("اطلاعات تماس")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 30
            highlighted: true

            Material.accent: Material.color(Material.Red)
            onClicked: {
                popup.open()
            }
        }

    }

    Popup {
            id: popup
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 300
            height: 400
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            Label{
                id:lblTel
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 15
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap
                width: parent.width - 15

            }

            Label{
                id:lblEmail
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.left: parent.left
                anchors.leftMargin: 15
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap
                width: parent.width - 15

            }
            Label{
                text: "بهترین‌ها هیچ‌گونه منفعت و مسئولیتی در قبال معامله شما ندارد."
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 70
                font.bold: true
                font.family: "Sahel"
                anchors.right: parent.right
                anchors.rightMargin: 15
                id:lblFindBestNotice
                color: "#c5401e"
                anchors.left: parent.left
                anchors.leftMargin: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap

            }

            Button {
                id: btnClosePopup
                onClicked: popup.close()
                text: qsTr("بستن")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
            }


    }

    BusyIndicator {
        id: pageLoading
        z:200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: image.status === Image.Loading
    }

}
