import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0

ApplicationWindow {
    id: window
    visible: true
    title: "XLSX converter"
    minimumWidth: 600
    minimumHeight: 400
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2


    Column {
        anchors.centerIn: parent
        Row {
            spacing: 10
            Button {
                text: "Open .xlsx file"
                onClicked: fileDialog.open()
            }
            TextField {
                id: inputFile
                width: 270
                placeholderText: "Choose file"
                selectByMouse: true
            }
        }
        Row {
            spacing: 10
            Button {
                text: "Select output directory"
                onClicked: dirDialog.open()
            }
            TextField {
                id: outputDirectory
                width: 200
                placeholderText: "Current folder"
                selectByMouse: true
            }
        }
        Row {
            id: row
            Button {
                text: "Convert"
                onClicked: {
                    qmlBridge.sendToGo(inputFile.text, outputDirectory.text)
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        visible : false
        title: "Please, choose a file"
        folder: shortcuts.home
        nameFilters: [ "Excel files (*.xlsx)" ]
        onAccepted: {
            var path = fileDialog.fileUrl.toString();
            if(Qt.platform.os === "linux"){
                path= path.replace(/^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,"");
            } else if (Qt.platform.os === "windows"){
                path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            }
            var cleanPath = decodeURIComponent(path)
            inputFile.text = cleanPath

        }
        onRejected: {
            console.log("Canceled")
        }
    }
    FileDialog {
        id: dirDialog
        visible : false
        selectFolder: true
        selectMultiple: false
        selectExisting: true
        title: "Please choose a folder"
        folder: shortcuts.home
        onAccepted: {
            var path = dirDialog.fileUrl.toString();
            if(Qt.platform.os === "linux"){
                path= path.replace(/^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,"");
            } else if (Qt.platform.os === "windows"){
                path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            }
            var cleanPath = decodeURIComponent(path);
            outputDirectory.text = cleanPath+"/"
        }
        onRejected: {
            console.log("Canceled")
        }
    }
    MessageDialog {
        id: messageDialog
        title: "Status"
        text: ""
        onAccepted: {


        }

    }
    Connections {
        target: qmlBridge
        onSendToQml: {
            messageDialog.text = data
            messageDialog.open()
        }
    }
}
