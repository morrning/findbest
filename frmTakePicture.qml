import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8

Item {
    id: areaBody
    anchors.fill: parent

    Camera {
            id: camera

            imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

            exposure {
                exposureCompensation: -1.0
                exposureMode: Camera.ExposureLandscape
            }

            flash.mode: Camera.FlashRedEyeReduction

            imageCapture {
                onImageCaptured: {
                    photoPreview.source = preview  // Show the preview in an Image
                }
            }
    }

    Image {
        id: photoPreview
    }

    VideoOutput {
        source: camera
        anchors.fill: parent
        focus : visible // to receive focus and capture key events when visible
    }

    Button {
        id: btCapture
        text: "\uf05a"
        font.pointSize: 18
        display: AbstractButton.TextOnly
        font.family: fontAwesomeSolid.name
        onClicked: {
            camera.imageCapture.capture()
        }
    }





}
