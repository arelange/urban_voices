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
#ifndef CONTACT_H
#define CONTACT_H

#include <QObject>
#include <QGeoCoordinate>
#include <QGeoAddress>

class Contact : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString vcard WRITE import)
    Q_PROPERTY(QString fn READ fn NOTIFY fnChanged)
    Q_PROPERTY(QString org READ org NOTIFY orgChanged)
    Q_PROPERTY(QGeoAddress adr READ adr NOTIFY adrChanged)
    Q_PROPERTY(QGeoCoordinate geo READ geo NOTIFY geoChanged)
    Q_PROPERTY(QString tel READ tel NOTIFY telChanged)
    Q_PROPERTY(QString url READ url NOTIFY urlChanged)
    Q_PROPERTY(QString logo READ logo NOTIFY logoChanged)
public:
    Contact();
    void import(QString vCard);
    QString fn() const;
    QString org() const;
    QGeoAddress adr() const;
    QGeoCoordinate geo() const;
    QString tel() const;
    QString url() const;
    QString logo() const;

signals:
    void fnChanged(QString);
    void orgChanged(QString);
    void adrChanged(QGeoAddress);
    void geoChanged(QGeoCoordinate);
    void telChanged(QString);
    void urlChanged(QString);
    void logoChanged(QString);

public slots:

private:
    QHash<QString,QString> hash;
    QGeoCoordinate coord;
    QGeoAddress addr;
};

#endif // CONTACT_H
