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
    id: bus_station
    color: "#F8F8F8"
    property string message: uvFurniture.message
    onMessageChanged: {
        if (uvFurniture.message == "Loaded")
            loading.visible = false;
        else
            loading.visible = true;
    }

    Button {
        id: title
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: qsTr("bus_station")
    }
    Calendar {
        id: timetable
        ical: uvFurniture.timetable
    }

    Timer {
            id:nextTimer
            interval: 1000;
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var now = new Date();
                var next = timetable.next;
                var left = next.getTime()-now.getTime();
                var daysleft = Math.floor(left / (24*3600000));left=left%(24*3600000);
                var hoursleft = Math.floor(left / 3600000);left=left%(3600000);
                var minutesleft = Math.floor(left / 60000);left=left%60000;
                var secondsleft = Math.ceil(left / 1000);

                var text = "Le prochain bus passera dans ";
                if (daysleft > 0)
                    text = text + daysleft + " jours "
                if (hoursleft > 0)
                    text = text + hoursleft + " heures "
                if (minutesleft > 0)
                    text = text + minutesleft + " minutes "
                if (secondsleft > 0)
                    text = text + secondsleft + " secondes "
                timerText.text = text;

            var p = Date.fromLocaleString(Qt.locale(), uvFurniture.lastEvent,"yyyyMMdd'T'HHmmss'Z'");
            var last = timetable.last;
            var nd = Qt.formatDate(next,"yyyyMMdd");
            var td = Qt.formatDate(now,"yyyyMMdd");
            var ld = Qt.formatDate(last,"yyyyMMdd");

            if ((ld < td) && (nd > td)) {
                lasteventText.text = "Pas de bus aujourd'hui"
                lasteventText.color = "red"
            }
            else {
                if (p > last) {
                    lasteventText.text = "Le dernier bus est passé à " + Qt.formatTime(p, Qt.DefaultLocaleLongDate)
                    lasteventText.color = "red"
                }
                else {
                    lasteventText.text = "Le bus aurait du passer à " + Qt.formatTime(last, Qt.DefaultLocaleLongDate) + " mais il n'est pas encore passé !"
                    lasteventText.color = "orange"
                }
            }

            nextEventText.text = "Le prochain bus passera le " + Qt.formatDateTime(timetable.next,Qt.DefaultLocaleLongDate);

        }
    }


    Text {
        id: descriptionText
        anchors.top: title.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
        font.bold: true
        font.italic: true
        font.underline: true
        text: uvFurniture.description
    }

    Text {
        id: lasteventText
        anchors.top: descriptionText.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
        MouseArea {
            id: mouseUrlArea
            anchors.fill: parent
            onClicked: {
                uvFurniture.lastEvent = Qt.formatDateTime(new Date(), "yyyyMMdd'T'HHmmss'Z'");
            }
        }
    }

    Text {
        id: timerText
        anchors.top: lasteventText.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
        color: "green"
    }

    Text {
        id: nextEventText
        anchors.top: timerText.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
    }

    Rectangle {
        id: loading
        width: parent.width
        anchors.top: title.bottom
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
                text: qsTr(uvFurniture.message)
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
