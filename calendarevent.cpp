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
#include <QDateTime>
#include <QTextStream>
#include <QTimeZone>
#include "calendarevent.h"

CalendarEvent::CalendarEvent(QDateTime origin,
                             int duration,
                             QString summary,
                             QList<QDateTime> exceptions,
                             int mult_mo,
                             int mult_sec):
    QObject()
{
    m_origin = origin;
    m_duration = duration;
    m_summary = summary;
    m_exceptions = exceptions;
    m_mult_mo = mult_mo;
    m_mult_sec = mult_sec;
}

QDateTime CalendarEvent::last() const
{
    QDateTime now = QDateTime::currentDateTime();
    if (m_origin == now)
        return m_origin;
    else if (m_origin > now)
        return QDateTime();
    else {
        /* TODO multiplicity year/month */
        if (m_mult_sec == 0)
            return QDateTime();
        else {
            QDateTime ret = now.addSecs(-1*(m_origin.secsTo(now)%m_mult_sec));
            return ret.addSecs(-ret.timeZone().daylightTimeOffset(ret));
        }
    }
}


QDateTime CalendarEvent::next() const
{
    QDateTime now = QDateTime::currentDateTime();
    if (m_origin > now)
        return m_origin;
    else {
        /* TODO multiplicity year/month */
        QDateTime next = QDateTime(now);
        if (m_mult_sec == 0)
            return QDateTime();
        else {
            QDateTime ret = now.addSecs(m_mult_sec-(m_origin.secsTo(now)%m_mult_sec));
            return ret.addSecs(-ret.timeZone().daylightTimeOffset(ret));
        }
    }
}
