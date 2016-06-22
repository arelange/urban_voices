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

    ListModel {
        id: listMaterial

        ListElement { value: "no"; key: QT_TR_NOOP("aerosol_cans")}
        ListElement { value: "no"; key: QT_TR_NOOP("aluminium")}
        ListElement { value: "no"; key: QT_TR_NOOP("batteries")}
        ListElement { value: "no"; key: QT_TR_NOOP("car_batteries")}
        ListElement { value: "no"; key: QT_TR_NOOP("beverage_cartons")}
        ListElement { value: "no"; key: QT_TR_NOOP("bicycles")}
        ListElement { value: "no"; key: QT_TR_NOOP("books")}
        ListElement { value: "no"; key: QT_TR_NOOP("cans")}
        ListElement { value: "no"; key: QT_TR_NOOP("cardboard")}
        ListElement { value: "no"; key: QT_TR_NOOP("cartons")}
        ListElement { value: "no"; key: QT_TR_NOOP("cds")}
        ListElement { value: "no"; key: QT_TR_NOOP("clothes")}
        ListElement { value: "no"; key: QT_TR_NOOP("computers")}
        ListElement { value: "no"; key: QT_TR_NOOP("cooking_oil")}
        ListElement { value: "no"; key: QT_TR_NOOP("cork")}
        ListElement { value: "no"; key: QT_TR_NOOP("drugs")}
        ListElement { value: "no"; key: QT_TR_NOOP("engine_oil")}
        ListElement { value: "no"; key: QT_TR_NOOP("fluorescent_tubes")}
        ListElement { value: "no"; key: QT_TR_NOOP("foil")}
        ListElement { value: "no"; key: QT_TR_NOOP("furniture")}
        ListElement { value: "no"; key: QT_TR_NOOP("gas_bottles")}
        ListElement { value: "no"; key: QT_TR_NOOP("glass")}
        ListElement { value: "no"; key: QT_TR_NOOP("glass_bottles")}
        ListElement { value: "no"; key: QT_TR_NOOP("green_waste")}
        ListElement { value: "no"; key: QT_TR_NOOP("garden_waste")}
        ListElement { value: "no"; key: QT_TR_NOOP("hazardous_waste")}
        ListElement { value: "no"; key: QT_TR_NOOP("low_energy_bulbs")}
        ListElement { value: "no"; key: QT_TR_NOOP("magazines")}
        ListElement { value: "no"; key: QT_TR_NOOP("metal")}
        ListElement { value: "no"; key: QT_TR_NOOP("mobile_phones")}
        ListElement { value: "no"; key: QT_TR_NOOP("newspaper")}
        ListElement { value: "no"; key: QT_TR_NOOP("organic")}
        ListElement { value: "no"; key: QT_TR_NOOP("paint")}
        ListElement { value: "no"; key: QT_TR_NOOP("paper")}
        ListElement { value: "no"; key: QT_TR_NOOP("paper_packaging")}
        ListElement { value: "no"; key: QT_TR_NOOP("plastic")}
        ListElement { value: "no"; key: QT_TR_NOOP("plastic_bags")}
        ListElement { value: "no"; key: QT_TR_NOOP("plastic_bottles")}
        ListElement { value: "no"; key: QT_TR_NOOP("plastic_packaging")}
        ListElement { value: "no"; key: QT_TR_NOOP("polyester")}
        ListElement { value: "no"; key: QT_TR_NOOP("rubble")}
        ListElement { value: "no"; key: QT_TR_NOOP("scrap_metal")}
        ListElement { value: "no"; key: QT_TR_NOOP("sheet_metal")}
        ListElement { value: "no"; key: QT_TR_NOOP("tyres")}
        ListElement { value: "no"; key: QT_TR_NOOP("waste")}
        ListElement { value: "no"; key: QT_TR_NOOP("white_goods")}
        ListElement { value: "no"; key: QT_TR_NOOP("wood")}
    }

    function displayList() {
        var value;
        for (var i=0;i<listMaterial.count;i++) {
            value = uvFurniture.tag("recycling:"+listMaterial.get(i).key);
            listMaterial.setProperty(i,"value",value);
        }
    }

    onMessageChanged: {
        if (uvFurniture.message == "Loaded") {
            loading.visible = false;
            displayList();
        }
        else
            loading.visible = true;
    }

    Button {
        id: title
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: qsTr("recycling")
    }

    ListView {
        id: listMaterialView
        model: listMaterial
        width: parent.width
        anchors.top: title.bottom
        anchors.bottom: menu.top
        delegate: Rectangle {
            width: listMaterialView.width
            height: materialText.height * 1.5
            color: value === "yes" ? "#48C47E" : "#FF7F5D"
            border.color: "#F8F8F8"
            border.width: 2
            radius: 5

            Text {
                id: materialText
                text: qsTr(key)
                width: parent.width * 0.85
                x: 10
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.Wrap
            }
            Text {
                anchors.left: materialText.right
                anchors.verticalCenter: parent.verticalCenter
                text: value === "yes" ? qsTr("yes") : qsTr("no")
            }
        }
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
