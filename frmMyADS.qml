import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
Item {
    id: newMyADS

    ScrollView {
        id: scrollView
        anchors.fill: parent
        ScrollBar.vertical.interactive: true
        Button {
            id: button
            x: 51
            y: 111
            text: qsTr("Cancel")
            highlighted: true
            Material.accent: Material.Orange
            onClicked: {
                qmlEndPage()
            }
        }
    }

}
