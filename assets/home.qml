/***************************************************************************
**
** Copyright (C) 2014 BlackBerry Limited. All rights reserved.
** Copyright (C) 2016 Alexandre Relange <alexandre@relange.org>
**
** This file is part of the Urban Voices project.
** www.urbanvoicesiot.com
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Rectangle {
    id: screen
    color: "#F8F8F8"
    property string message: uvFurniture.message
    onMessageChanged: {
        if (uvFurniture.message != "Scanning for devices..." && uvFurniture.message != "Low Energy device found. Scanning for more...") {
            background.visible = false;
        }
        else {
            background.visible = true;
        }
    }

    Rectangle {
        id:select
        width: parent.width
        anchors.top: parent.top
        height: 0.1*parent.height
        color: "#F8F8F8"
        border.color: "#F0A000"
        border.width: 2
        radius: 5

        Text {
            id: selectText
            color: "#F0A000"
            font.pixelSize: 34
            anchors.centerIn: parent
            text: "Select Device"
        }
    }

    Rectangle {
        id: spinner
        width: parent.width
        anchors.top: select.bottom
        anchors.bottom: scanAgain.top
        visible: false
        color: "#F8F8F8"
        z: 100

        Rectangle {
            id: inside
            anchors.centerIn: parent
            AnimatedImage {
                id: background

                width:200
                height:200
                anchors.horizontalCenter: parent.horizontalCenter

                source: "uv_busy.gif"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: infotext
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: background.bottom
                text: uvFurniture.message
                color: "#8F8F8F"
            }
        }
    }

    Component.onCompleted: {
        uvFurniture.deviceSearch();
        spinner.visible=true;
    }

    ListView {
        id: theListView
        width: parent.width
        onModelChanged: spinner.visible=false
        anchors.top: select.bottom
        anchors.bottom: scanAgain.top
        model: uvFurniture.name

        delegate: Rectangle {
            id: box
            height:100
            width: parent.width
            color: "#F0A000"
            border.color: "#F8F8F8"
            border.width: 5
            radius: 5

            MouseArea {
                anchors.fill: parent
                onPressed: { box.color= "#E09000"; box.height=110}
                onClicked: {
                    uvFurniture.connectToService(modelData.deviceAddress);
                    pageLoader.source="tags/" + modelData.deviceName + ".qml";
                }
            }

            Text {
                id: device
                font.pixelSize: 30
                text: qsTr(modelData.deviceName)
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#F8F8F8"
            }
        }
    }

    Button {
        id:scanAgain
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Menu"
        onButtonClick: pageLoader.source="main.qml"
    }
}
