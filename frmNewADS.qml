import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8
import QtPositioning 5.8

Item{
    id:newAdsWindow
    property string usrLoc: "0"

    function submitAds(title,des,moneyType,price,loc)
    {
        var http = new XMLHttpRequest()
        var url = window.siteAdr + "/json/ads/submit";
        var params = "title=" + title + "&des=" + des + "&moneyType=" + moneyType + "&price=" + price + "&loc=" + loc;
        http.open("POST", url, true);
        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        if (http.status == 200) {
                            var tst = JSON.parse(http.responseText).callBack
                            if(tst == "ok"){
                                popupSuccessSubmit.open()
                            }

                        } else {
                            var networkError = Qt.createComponent("frmNetworkError.qml")
                            networkError.createObject(recNewAds,{"width": parent.width, "y": 250})
                            console.log("error: " + http.status)
                        }

                    }

                }
        http.send(params);

    }

    //this item save user location
    PositionSource {
        id: userLocation
        updateInterval: 1000
        active: true

        onPositionChanged: {
            var coord = userLocation.position.coordinate;
            newAdsWindow.usrLoc = coord.longitude + "MM" + coord.latitude
            console.log(newAdsWindow.usrLoc);
        }
    }
    Drawer {
        id: newAdsUploadImageDrawer
        width: window.width
        height: window.height / 4
        edge: Qt.BottomEdge
        Label{
            id: lblSelectImage
            text: qsTr("انتخاب عکس")
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 15
        }
        GridLayout{
            id:glDrawerOptions
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.top: lblSelectImage.top
            anchors.topMargin: 40
            columnSpacing: 20
            rowSpacing: 10
            layoutDirection: Qt.LeftToRight
            antialiasing: true
            scale: 1.2
            columns: 2
            rows:2
            flow: GridLayout.TopToBottom
            Label {
                text: "\uf083"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label {
                text: "\uf302"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.family: fontAwesomeSolid.name
            }
            Label{
                id:laNewADS
                text:"از دوربین"
                MouseArea{
                    id:maNewADS
                    anchors.fill: parent
                    onClicked: {
                        newAdsUploadImageDrawer.close()
                        var objFrmNewADS = Qt.createComponent("frmTakePicture.qml")
                        areaPageStack.push(objFrmNewADS)
                    }


                }
            }
            Label{
                id:laHome
                text:"انتخاب از گالری"
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
        }
    }
    ScrollView {
        id:sv
        anchors.bottomMargin: 30
        anchors.fill: parent
            Rectangle {
                id:recNewAds
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 30
                height: imgSelect.height  + btnSubmitAds.height + lblSelectImageUnderImage.height + txtTitle.height + txtDes.height + cobMoneyType.height + txtPrice.height +  400

                Image {
                    id: imgSelect
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.height: 150
                    sourceSize.width: 150
                    source: "icons/selectImage.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            newAdsUploadImageDrawer.open()
                        }
                    }
                }
                Label{
                    id:lblSelectImageUnderImage
                    text: qsTr("انتخاب تصویر برای آگهی")
                    anchors.top: imgSelect.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                TextField{
                    id:txtTitle
                    placeholderText: qsTr("عنوان آگهی")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 30
                    anchors.top: lblSelectImageUnderImage.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                }
                TextArea{
                    id:txtDes
                    placeholderText: qsTr("توضیحات بیشتر")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 30
                    anchors.top: txtTitle.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                    height:100
                }
                TextField{
                    id:txtTel
                    placeholderText: qsTr("تلفن")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 30
                    anchors.top: txtDes.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                }
                TextField{
                    id:txtEmail
                    placeholderText: qsTr("پست الکترونیکی")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 30
                    anchors.top: txtTel.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                }
                Label{
                    id: lblMoneyType
                    text: qsTr("واحد ارزیابی")
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: parent.width
                    anchors.top: txtEmail.bottom
                    anchors.topMargin: 20

                    font.family: "Sahel"
                }

                ComboBox {
                    id:cobMoneyType
                    width: parent.width - 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: lblMoneyType.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                    model: [  "تومان", "توافقی","مفت" ]
                    onCurrentIndexChanged: {
                        if(cobMoneyType.currentIndex == 0){
                             txtPrice.enabled = true
                             txtPrice.placeholderText = qsTr("قیمت")
                        }
                        else{
                            txtPrice.text="قیمت لازم نیست"
                            txtPrice.enabled = false
                        }
                    }
                }

                TextField{
                    id:txtPrice
                    placeholderText: qsTr("قیمت")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 30
                    anchors.top: cobMoneyType.bottom
                    anchors.topMargin: 20
                    font.family: "Sahel"
                }
                Label{
                    id: lblTerm
                    text: qsTr("با ثبت آگهی شما قوانین و شرایط خدمات را پذیرفته‌اید.")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    anchors.top: txtPrice.bottom
                    anchors.topMargin: 40
                    font.family: "Sahel"
                    color: Material.color(Material.Orange)
                }
                Button{
                    id: btnSubmitAds
                    Label{
                        text: "\uf071"
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                       font.family: fontAwesomeSolid.name
                    }

                    text: "ثبت آگهی"
                    anchors.top: lblTerm.top
                    anchors.topMargin: 55
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Sahel"
                    display: AbstractButton.TextBesideIcon
                    width: (parent.width / 2) - 5
                    highlighted: true
                    Material.accent: Material.color(Material.Red)
                    onClicked: {
                        submitAds(txtTitle.text,txtDes.text,cobMoneyType.currentText,txtPrice.text,newAdsWindow.usrLoc)
                    }

                }
            }

            contentHeight: recNewAds.height
            contentWidth: parent.width
    }

    Popup {
            id: popupSuccessSubmit
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 300
            height: 400
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            Image {
                id: imgSuccess
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: parent.width / 2
                sourceSize.width: parent.width / 2
                source: "icons/success-icon.png"

            }
            Label{
                id:lblSuccess
                text: qsTr("آگهی با موفقیت ثبت شد.")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: imgSuccess.bottom
                anchors.topMargin: 40
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Label.WordWrap
                width: parent.width - 15
                color: Material.color(Material.Green)

            }

            Button {
                id: btnClosePopup
                onClicked: {

                    popupSuccessSubmit.close()
                    areaPageStack.pop()
                }
                text: qsTr("بستن")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
            }


    }

}

