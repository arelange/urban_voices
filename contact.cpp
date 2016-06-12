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
#include <QtDebug>
#include <QGeoCoordinate>
#include <QGeoAddress>
#include "contact.h"

Contact::Contact() :
    QObject()
{
}

void Contact::import(QString vCard)
{
    QTextStream *stream = new QTextStream(&vCard);
    /*
     * while readline
  if not cointain BEGIN
drop */
    QString line=stream->readLine();
    //qDebug() << output;
    QRegExp rx("^([A-Z]*)(?:;?.*)*:(.*)");
    while(line.length()!=0 && rx.indexIn(line) != -1)
    {
        //qDebug() << rx.cap(1) << rx.cap(2);
        hash.insert(rx.cap(1), rx.cap(2));
        line=stream->readLine();
    }

/*
if (1) == END
  break;
  */
//    return this;

    QString adrstring = hash.value("ADR");
    if (!adrstring.isEmpty()) {
        QStringList adrlist = adrstring.split(";");
        addr.setStreet(adrlist.at(2));
        addr.setCity(adrlist.at(3));
        addr.setState(adrlist.at(4));
        addr.setPostalCode(adrlist.at(5));
        addr.setCountry(adrlist.at(6));
    }

    QString geostring = hash.value("GEO");
    if (!geostring.isEmpty()) {
        QStringList geolist = geostring.split(";");
        coord.setLatitude(geolist.at(0).toDouble());
        coord.setLongitude(geolist.at(1).toDouble());
    }

    emit fnChanged(fn());
    emit orgChanged(org());
    emit adrChanged(adr());
    emit geoChanged(geo());
    emit telChanged(tel());
    emit urlChanged(url());
    emit logoChanged(logo());
}

QString Contact::fn() const
{
    return hash.value("FN");
}

QString Contact::org() const
{
    return hash.value("ORG");
}

QGeoAddress Contact::adr() const
{
    return addr;
}

QGeoCoordinate Contact::geo() const
{
    return coord;
}

QString Contact::tel() const
{
    return hash.value("TEL");
}

QString Contact::url() const
{
    return hash.value("URL");
}

QString Contact::logo() const
{
    return hash.value("LOGO");
}
