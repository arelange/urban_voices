/****************************************************************************
**
** Copyright (C) 2016 Alexandre Relange <alexandre@relange.org>
**
** This file is part of the Urban Voices project.
** www.urbanvoicesiot.com
**
** $QT_BEGIN_LICENSE:GPL$
** This program is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import Calendar 1.0
import "../"

Rectangle {
    id: recycling
    color: "#F8F8F8"
    property string message: uvFurniture.message
    onMessageChanged: {
        if (uvFurniture.message == "Loaded")
            loading.visible = false;
        else
            loading.visible = true;
    }

    Button {
        id: Title
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: "Point de collecte pour recyclage"
    }

    Rectangle {
        id: loading
        width: parent.width
        anchors.top: postboxTitle.bottom
        anchors.bottom: menu.top
        visible: true//false
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

                source: "../uv_busy.gif"
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

    Button {
        id: menu
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Menu"
        onButtonClick: {
            pageLoader.source="../home.qml";
        }
    }
}
