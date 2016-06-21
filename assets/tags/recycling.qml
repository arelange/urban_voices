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

        ListElement { value: "no"; key: "aerosol_cans"}
        ListElement { value: "no"; key: "aluminium"}
        ListElement { value: "no"; key: "batteries"}
        ListElement { value: "no"; key: "car_batteries"}
        ListElement { value: "no"; key: "beverage_cartons"}
        ListElement { value: "no"; key: "bicycles"}
        ListElement { value: "no"; key: "books"}
        ListElement { value: "no"; key: "cans"}
        ListElement { value: "no"; key: "cardboard"}
        ListElement { value: "no"; key: "cartons"}
        ListElement { value: "no"; key: "cds"}
        ListElement { value: "no"; key: "chipboard"}
        ListElement { value: "no"; key: "clothes"}
        ListElement { value: "no"; key: "computers"}
        ListElement { value: "no"; key: "cooking_oil"}
        ListElement { value: "no"; key: "cork"}
        ListElement { value: "no"; key: "drugs"}
        ListElement { value: "no"; key: "engine_oil"}
        ListElement { value: "no"; key: "fluorescent_tubes"}
        ListElement { value: "no"; key: "foil"}
        ListElement { value: "no"; key: "furniture"}
        ListElement { value: "no"; key: "gas_bottles"}
        ListElement { value: "no"; key: "glass"}
        ListElement { value: "no"; key: "glass_bottles"}
        ListElement { value: "no"; key: "green_waste"}
        ListElement { value: "no"; key: "garden_waste"}
        ListElement { value: "no"; key: "hazardous_waste"}
        ListElement { value: "no"; key: "hardcore"}
        ListElement { value: "no"; key: "low_energy_bulbs"}
        ListElement { value: "no"; key: "magazines"}
        ListElement { value: "no"; key: "metal"}
        ListElement { value: "no"; key: "mobile_phones"}
        ListElement { value: "no"; key: "newspaper"}
        ListElement { value: "no"; key: "organic"}
        ListElement { value: "no"; key: "paint"}
        ListElement { value: "no"; key: "paper"}
        ListElement { value: "no"; key: "paper_packaging"}
        ListElement { value: "no"; key: "PET"}
        ListElement { value: "no"; key: "plastic"}
        ListElement { value: "no"; key: "plastic_bags"}
        ListElement { value: "no"; key: "plastic_bottles"}
        ListElement { value: "no"; key: "plastic_packaging"}
        ListElement { value: "no"; key: "polyester"}
        ListElement { value: "no"; key: "rubble"}
        ListElement { value: "no"; key: "scrap_metal"}
        ListElement { value: "no"; key: "sheet_metal"}
        ListElement { value: "no"; key: "small_appliances"}
        ListElement { value: "no"; key: "styrofoam"}
        ListElement { value: "no"; key: "tyres"}
        ListElement { value: "no"; key: "waste"}
        ListElement { value: "no"; key: "white_goods"}
        ListElement { value: "no"; key: "wood"}
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
        text: "recycling"
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
            color: value ? "#48C47E" : "#FF7F5D"
            border.color: "#F8F8F8"
            border.width: 2
            radius: 5

            Text {
                id: materialText
                text: key
                width: parent.width * 2/3
                x: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                anchors.left: materialText.right
                anchors.verticalCenter: parent.verticalCenter
                text: value
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
