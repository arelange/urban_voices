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
#ifndef CALENDAR_H
#define CALENDAR_H

#include <QObject>
#include <QDateTime>
#include "calendarevent.h"

class Calendar : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ical WRITE import)
    Q_PROPERTY(QDateTime next READ next NOTIFY nextChanged)
    Q_PROPERTY(QDateTime last READ last NOTIFY lastChanged)
    Q_PROPERTY(int lastDuration READ lastDuration NOTIFY lastDurationChanged)
public:
    Calendar();
    void import(QString iCalendar);
    QDateTime last() const;
    QDateTime next() const;
    int lastDuration() const;

signals:
    void nextChanged(QDateTime);
    void lastChanged(QDateTime);
    void lastDurationChanged(int);

public slots:

private:
    QList<CalendarEvent *> events;
};

#endif // CALENDAR_H
