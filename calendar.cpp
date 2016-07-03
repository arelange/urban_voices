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
#include "calendar.h"

Calendar::Calendar() :
    QObject()
{
}

void Calendar::import(QString icalendar)
{
    QTextStream *stream = new QTextStream(&icalendar);
    QString line;
    QRegExp rx("^([A-Z]*)(?:;?.*)*:(.*)");
    QString summary;
    QString rule;
    QList<QDateTime> exceptions;
    QDateTime startTime, endTime;
    do {
        /* remove what is outside vevent */
        do {
            line = stream->readLine();
        } while (line.length()!=0 && ! line.contains("BEGIN:VEVENT"));
        if (line.contains("BEGIN:VEVENT")) {
            int mult_mo = 0, mult_sec = 0;
            do {
                line = stream->readLine();
                if (line.length()!=0 && line.contains(rx)) {
                    if (rx.cap(1) == "SUMMARY")
                        summary = rx.cap(2);
                    if (rx.cap(1) == "RRULE")
                        rule = rx.cap(2);
                    if (rx.cap(1) == "EXDATE")
                        exceptions.append(QDateTime::fromString(rx.cap(2),"yyyyMMdd'T'hhmmss'Z'"));
                    if (rx.cap(1) == "DTSTART")
                        startTime = QDateTime::fromString(rx.cap(2),"yyyyMMdd'T'hhmmss");
                    if (rx.cap(1) == "DTEND")
                        endTime = QDateTime::fromString(rx.cap(2),"yyyyMMdd'T'hhmmss");
                }
            } while (line.length()!=0 && ! line.contains("END:VEVENT"));
            qDebug() << startTime.toString() << startTime.timeZoneAbbreviation();

            QDateTime startRec;
            if (!rule.isEmpty()) {
                /* parse recurrence rule */
                /* limited to expand mode ! */
                QStringList ruleList = rule.split(';');
                QRegExp regRule("^([A-Z]*)=(.*)");
                foreach (const QString &strRule, ruleList) {
                    if (strRule.contains(regRule)) {
                        if (regRule.cap(1) == "FREQ") {
                            if (regRule.cap(2) == "YEARLY")   mult_mo = 12;
                            if (regRule.cap(2) == "MONTHLY")  mult_mo =  1;
                            if (regRule.cap(2) == "WEEKLY")   mult_sec = 7*24*60*60;
                            if (regRule.cap(2) == "DAILY")    mult_sec =   24*60*60;
                            if (regRule.cap(2) == "HOURLY")   mult_sec =      60*60;
                            if (regRule.cap(2) == "MINUTELY") mult_sec =         60;
                            if (regRule.cap(2) == "SECONDLY") mult_sec =          1;
                        }
                        if (regRule.cap(1) == "INTERVAL") {
                            mult_mo  *= regRule.cap(2).toInt();
                            mult_sec *= regRule.cap(2).toInt();
                        }
                        if (regRule.cap(1) == "BYDAY") {
                            QStringList dayList = regRule.cap(2).split(',');
                            startRec = startTime.addDays(1-startTime.date().dayOfWeek());
                            foreach (const QString &day, dayList) {
                                if (day == "MO")
                                    events.append(new CalendarEvent(startRec, startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "TU")
                                    events.append(new CalendarEvent(startRec.addDays(1), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "WE")
                                    events.append(new CalendarEvent(startRec.addDays(2), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "TH")
                                    events.append(new CalendarEvent(startRec.addDays(3), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "FR")
                                    events.append(new CalendarEvent(startRec.addDays(4), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "SA")
                                    events.append(new CalendarEvent(startRec.addDays(5), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                                else if (day == "SU")
                                    events.append(new CalendarEvent(startRec.addDays(6), startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec));
                            }
                        }
                    }
                }
            }
            if (startRec.isNull()) {
                CalendarEvent *event = new CalendarEvent(startTime, startTime.secsTo(endTime), summary, exceptions, mult_mo, mult_sec);
                events.append(event);
            }
        }
    } while (line.length()!=0);

    Q_EMIT lastChanged(last());
    Q_EMIT lastDurationChanged(lastDuration());
    Q_EMIT nextChanged(next());
}

QDateTime Calendar::last() const
{
    QDateTime last;
    Q_FOREACH (CalendarEvent *event, events) {
        QDateTime el = event->last();
        if (el.isValid()) {
            if (!last.isValid() || el > last)
                last = el;
        }
    }
    return last;
}

int Calendar::lastDuration() const
{
    QDateTime last;
    int duration;
    Q_FOREACH (CalendarEvent *event, events) {
        QDateTime el = event->last();
        if (el.isValid()) {
            if (!last.isValid() || el > last) {
                last = el;
                duration = event->duration();
            }
        }
    }
    return duration;
}

QDateTime Calendar::next() const
{
    QDateTime next;
    Q_FOREACH (CalendarEvent *event, events) {
        QDateTime en = event->next();
        if (en.isValid()) {
            if (!next.isValid() || en < next)
                next = en;
        }
    }
    return next;
}
