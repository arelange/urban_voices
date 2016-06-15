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
import QtPositioning 5.2
import QtLocation 5.3
import Contact 1.0

Item {
    id: stationColumn
    width: parent.width
    property alias contact: contact

    Contact {
        id: contact
        vcard: uvFurniture.office
        onGeoChanged: {
            routeQuery.clearWaypoints();
            routeQuery.addWaypoint(QtPositioning.coordinate(43.61508,7.07130));
            routeQuery.addWaypoint(QtPositioning.coordinate(43.61366,7.07981));
            routeQuery.addWaypoint(contact.geo);
        }
    }

    Address {
        id: office_addr
        address: contact.adr
    }

    Text {
        id: officeOrg
        width: parent.width;
        anchors.top: parent.top
        text: contact.org
        wrapMode: Text.WordWrap; font.family: "Helvetica"; font.bold: true
    }

    Text {
        id: officeIntro
        width: parent.width;
        anchors.top: officeOrg.bottom
        text: "Bureau le plus proche : "
        wrapMode: Text.WordWrap; font.family: "Helvetica"; font.bold: true
    }

    Row {
        id:row
        anchors.top: officeIntro.bottom
        Image {
            source: contact.logo
            fillMode: Image.Pad
            sourceSize.width: 100
            width: implicitWidth + 20
            height: implicitHeight + 20
        }

        Column {
            Text {
                id: nearestofficeDataNameText
                width: parent.width;
                text: contact.fn
                wrapMode: Text.WordWrap; font.family: "Helvetica"; font.bold: true
            }

            Text {
                id: nearestofficeDataAddressText
                text: office_addr.text
                wrapMode: Text.WordWrap; font.family: "Helvetica";
                MouseArea {
                    id: mouseAddressArea
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("maps:" + office_addr.street + " " + office_addr.postalCode + " " + office_addr.city + ", " + office_addr.country )
                    }
                }
            }
        }
    }
    Text {
        id: nearestofficeDataPhoneText
        width: parent.width - 20;
        anchors.top: row.bottom
        text: contact.tel
        wrapMode: Text.WordWrap; font.family: "Helvetica"; font.italic: true
        color: "Blue"
        MouseArea {
            id: mouseTelArea
            anchors.fill: parent
            onClicked: {
                Qt.openUrlExternally("tel:"+contact.tel)
            }
        }
    }
    Text {
        id: nearestofficeDataUrlText
        width: parent.width - 20;
        anchors.top: nearestofficeDataPhoneText.bottom
        text: contact.url
        wrapMode: Text.WordWrap; font.family: "Helvetica";
        color: "Blue"
        MouseArea {
            id: mouseUrlArea
            anchors.fill: parent
            onClicked: {
                Qt.openUrlExternally(contact.url)
            }
        }
    }
    Text {
        id: nearestofficeGeoUrlText
        width: parent.width - 20;
        anchors.top: nearestofficeDataUrlText.bottom
        text: "Géolocalisation"
        wrapMode: Text.WordWrap; font.family: "Helvetica";
        color: "Blue"
        MouseArea {
            id: mouseGeoArea
            anchors.fill: parent
            onClicked: {
                Qt.openUrlExternally("geo:"+contact.geo.latitude + "," + contact.geo.longitude)
            }
        }
    }

    Plugin {
        id: mapPlugin
        name: "osm"
    }
    Map {
        id: map
        width: parent.width * 0.8;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: nearestofficeGeoUrlText.bottom
        anchors.bottom: parent.bottom
        plugin: mapPlugin;

        center: contact.geo
        zoomLevel: map.maximumZoomLevel - 2

        gesture.enabled: true

        MapCircle {
            id: mapPoint
            radius: 5
            color: "#F0A000"
            border.color: "#301000"
            border.width: 2
            smooth: true
            opacity: 0.5
            center:contact.geo
        }

        MapQuickItem {
            id: mapLogo
            anchorPoint: Qt.point(officeLogo.width/2, officeLogo.height/2)
            coordinate: contact.geo
            sourceItem: Image {
                id: officeLogo
                source: contact.logo
                sourceSize.width: 100
            }
        }

        MapQuickItem {
            id: startPoint
            anchorPoint: Qt.point(sophiaconfLogo.width/2, sophiaconfLogo.height/2)
            coordinate: QtPositioning.coordinate(43.61508,7.07130)
            sourceItem: Image {
                id: sophiaconfLogo
                source: "sophiaconf.png"
            }
        }

        MapItemView {
            model: RouteModel {
                id: routeModel
                plugin: mapPlugin
                autoUpdate: true
                query: RouteQuery{
                    id: routeQuery
                }
            }
            delegate: MapRoute {
                route: routeData
                line.color: "red"
                line.width: 5
                smooth: true
                opacity: 0.8
            }
        }
    }
}
