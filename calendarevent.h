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
#ifndef CALENDAREVENT_H
#define CALENDAREVENT_H

#include <QObject>
#include <QDateTime>

class CalendarEvent : public QObject
{
    Q_OBJECT
public:
    CalendarEvent(QDateTime origin, int duration, QString summary, QList<QDateTime> exceptions, int mult_mo, int mult_sec);
    QDateTime last() const;
    QDateTime next() const;
    int duration() const;

signals:
public slots:

private:
    QDateTime m_origin;
    int m_duration;
    QString m_summary;
    QList<QDateTime> m_exceptions;
    int m_mult_mo;
    int m_mult_sec;
};

#endif // CALENDAREVENT_H
