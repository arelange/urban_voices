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

Rectangle {
    id: screenPostbox
    color: "#F8F8F8"
    property string message: uvFurniture.message
    onMessageChanged: {
        if (uvFurniture.message == "Loaded")
            loading.visible = false;
        else
            loading.visible = true;
    }

    Button {
        id: postboxTitle
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: "Boîte aux lettres"
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

                var text = "La prochaine levée aura lieu dans ";
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

            if (nd == td) {
                timerText.visible = true;
                lasteventText.visible = false
                nextEventText.visible = false
            }
            else {
                if (ld < td) {
                    lasteventText.text = "Pas de levée aujourd'hui"
                    lasteventText.color = "red"
                }
                else {
                    if (p > last) {
                        lasteventText.text = "La levée a été effectuée à " + Qt.formatTime(p, Qt.DefaultLocaleLongDate)
                        lasteventText.color = "red"
                    }
                    else {
                        lasteventText.text = "La levée aurait du être effectuée à " + Qt.formatTime(last, Qt.DefaultLocaleLongDate) + " mais le facteur n'est pas encore passé !"
                        lasteventText.color = "orange"
                    }
                }

                timerText.visible = false;
                lasteventText.visible = true;
                nextEventText.text = "La prochaine levée aura lieu le " + Qt.formatDateTime(timetable.next,Qt.DefaultLocaleLongDate);
                nextEventText.visible = true;

            }

        }
    }


    Text {
        id: timerText
        anchors.top: postboxTitle.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
        color: "green"
    }

    Text {
        id: lasteventText
        anchors.top: postboxTitle.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
        MouseArea {
            id: mouseUrlArea
            anchors.fill: parent
            onClicked: {
                lastevent.value = Qt.formatDateTime(new Date(), "yyyyMMdd'T'HHmmss'Z'");
            }
        }
    }
    Text {
        id: nextEventText
        anchors.top: lasteventText.bottom
        width: parent.width;
        wrapMode: Text.WordWrap; font.family: "Helvetica"
    }
    StationDelegate {
        id: letterboxstation
        anchors.top: nextEventText.bottom
        anchors.bottom: menu.top
        width: parent.width
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

    Button {
        id: menu
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Menu"
        onButtonClick: {
            pageLoader.source="home.qml";
        }
    }
}
