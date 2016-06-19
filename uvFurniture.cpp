/***************************************************************************
**
** Copyright (C) 2014 BlackBerry Limited. All rights reserved.
** Copyright (C) 2015 The Qt Company Ltd.
** Copyright (C) 2016 Alexandre Relange <alexandre@relange.org>
**
** This file is part of the Urban Voices project.
** www.urbanvoicesiot.com
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "uvFurniture.h"

#include <QtEndian>

UVFurniture::UVFurniture():
    m_currentDevice(QBluetoothDeviceInfo()), foundUVFurnitureService(false),
    m_control(0), m_service(0)
{
    //! [devicediscovery-1]
    m_deviceDiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);

    connect(m_deviceDiscoveryAgent, SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo&)),
            this, SLOT(addDevice(const QBluetoothDeviceInfo&)));
    connect(m_deviceDiscoveryAgent, SIGNAL(error(QBluetoothDeviceDiscoveryAgent::Error)),
            this, SLOT(deviceScanError(QBluetoothDeviceDiscoveryAgent::Error)));
    connect(m_deviceDiscoveryAgent, SIGNAL(finished()), this, SLOT(scanFinished()));
    //! [devicediscovery-1]

    // initialize random seed for demo mode
    qsrand(QTime::currentTime().msec());
}

UVFurniture::~UVFurniture()
{
    qDeleteAll(m_devices);
    m_devices.clear();
}

void UVFurniture::deviceSearch()
{
    qDeleteAll(m_devices);
    m_devices.clear();
    //! [devicediscovery-2]
    m_deviceDiscoveryAgent->start();
    //! [devicediscovery-2]
    setMessage("Scanning for devices...");
}

//! [devicediscovery-3]
void UVFurniture::addDevice(const QBluetoothDeviceInfo &device)
{
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        qWarning() << "Discovered LE Device name: " << device.name() << " Address: "
                   << device.address().toString();
//! [devicediscovery-3]
        DeviceInfo *dev = new DeviceInfo(device);
        m_devices.append(dev);
        setMessage("Low Energy device found. Scanning for more...");
//! [devicediscovery-4]
    }
    //...
}
//! [devicediscovery-4]

void UVFurniture::scanFinished()
{
    if (m_devices.size() == 0)
        setMessage("No Low Energy devices found");
    Q_EMIT nameChanged();
}

void UVFurniture::deviceScanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        setMessage("The Bluetooth adaptor is powered off, power it on before doing discovery.");
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        setMessage("Writing or reading from the device resulted in an error.");
    else
        setMessage("An unknown error has occurred.");
}


void UVFurniture::setMessage(QString message)
{
    m_info = message;
    Q_EMIT messageChanged();
}

QString UVFurniture::message() const
{
    return m_info;
}

QVariant UVFurniture::name()
{
    return QVariant::fromValue(m_devices);
}

void UVFurniture::connectToService(const QString &address)
{
    bool deviceFound = false;
    for (int i = 0; i < m_devices.size(); i++) {
        if (((DeviceInfo*)m_devices.at(i))->getAddress() == address ) {
            m_currentDevice.setDevice(((DeviceInfo*)m_devices.at(i))->getDevice());
            setMessage("Connecting to device...");
            deviceFound = true;
            break;
        }
    }

    if (m_control) {
        m_control->disconnectFromDevice();
        delete m_control;
        m_control = 0;

    }
    //! [Connect signals]
    m_control = new QLowEnergyController(m_currentDevice.getDevice(), this);
    connect(m_control, SIGNAL(serviceDiscovered(QBluetoothUuid)),
            this, SLOT(serviceDiscovered(QBluetoothUuid)));
    connect(m_control, SIGNAL(discoveryFinished()),
            this, SLOT(serviceScanDone()));
    connect(m_control, SIGNAL(error(QLowEnergyController::Error)),
            this, SLOT(controllerError(QLowEnergyController::Error)));
    connect(m_control, SIGNAL(connected()),
            this, SLOT(deviceConnected()));
    connect(m_control, SIGNAL(disconnected()),
            this, SLOT(deviceDisconnected()));

    m_control->connectToDevice();
    //! [Connect signals]
}

//! [Connecting to service]

void UVFurniture::deviceConnected()
{
    m_control->discoverServices();
}

void UVFurniture::deviceDisconnected()
{
    setMessage("Urban Voices service disconnected");
    qWarning() << "Remote device disconnected";
}

//! [Connecting to service]

//! [Filter UVFurniture service 1]
void UVFurniture::serviceDiscovered(const QBluetoothUuid &gatt)
{
    if (gatt == QBluetoothUuid(QString("8ceda3c9-b7b6-2592-704f-97c2700a9dae"))) {
        setMessage("Urban Voices service discovered. Waiting for service scan to be done...");
        foundUVFurnitureService = true;
    }
}
//! [Filter UVFurniture service 1]

void UVFurniture::serviceScanDone()
{
    delete m_service;
    m_service = 0;

    //! [Filter HeartRate service 2]
    if (foundUVFurnitureService) {
        setMessage("Connecting to service...");
        m_service = m_control->createServiceObject(
                    QBluetoothUuid(QString("8ceda3c9-b7b6-2592-704f-97c2700a9dae")), this);
    }

    if (!m_service) {
        setMessage("Urban Voices Service not found.");
        return;
    }

    connect(m_service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)),
            this, SLOT(serviceStateChanged(QLowEnergyService::ServiceState)));
    connect(m_service, SIGNAL(descriptorWritten(QLowEnergyDescriptor,QByteArray)),
            this, SLOT(confirmedDescriptorWrite(QLowEnergyDescriptor,QByteArray)));

    m_service->discoverDetails();
    setMessage("Loading service information...");
    //! [Filter UVFurniture service 2]
}

//! [Error handling]
void UVFurniture::controllerError(QLowEnergyController::Error error)
{
    setMessage("Cannot connect to remote device.");
    qWarning() << "Controller Error:" << error;
}
//! [Error handling]


//! [Find UV characteristic]
void UVFurniture::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    switch (s) {
    case QLowEnergyService::ServiceDiscovered:
    {
        m_timetable = QString(m_service->characteristic(
                        QBluetoothUuid(QString("86f318ec-290d-6396-bc4a-3e9917495189"))).value());
        m_lastevent = QString(m_service->characteristic(
                    QBluetoothUuid(QString("3f33b12f-d4ee-e0b4-c345-f9cf5839f660"))).value());
        m_office = QString(m_service->characteristic(
                    QBluetoothUuid(QString("b2f3a32c-8c17-9199-e84a-7a8820e74283"))).value());
        m_description = QString(m_service->characteristic(
                    QBluetoothUuid(QString("18afb6a7-5bb1-848b-c74b-4d874ac326fc"))).value());

        // fill in tags
        m_tags.clear();
        QStringList tagPairs = m_description.split(';');
        Q_FOREACH (QString& tagString, tagPairs) {
            QStringList tagPair = tagString.split('=');
            if (tagPair.length() == 2)
                m_tags.insert(tagPair[0],tagPair[1]);
        }

        Q_EMIT timetableChanged();
        Q_EMIT lastEventChanged();
        Q_EMIT officeChanged();
        Q_EMIT descriptionChanged();

        m_control->disconnectFromDevice();
        delete m_service;
        m_service = 0;

        setMessage("Loaded");

        break;
    }
    default:
        //nothing for now
        break;
    }
}
//! [Find UV characteristic]

void UVFurniture::serviceError(QLowEnergyService::ServiceError e)
{
    switch (e) {
    case QLowEnergyService::DescriptorWriteError:
        setMessage("Cannot obtain UV notifications");
        break;
    default:
        qWarning() << "UV service error:" << e;
    }
}

void UVFurniture::confirmedDescriptorWrite(const QLowEnergyDescriptor &d,
                                         const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray("0000")) {
        //disabled notifications -> assume disconnect intent
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = 0;
    }
}

QString UVFurniture::deviceAddress() const
{
    return m_currentDevice.getAddress();
}

int UVFurniture::numDevices() const
{
    return m_devices.size();
}

QString UVFurniture::timetable() const
{
    return m_timetable;
}

QString UVFurniture::lastEvent() const
{
    return m_lastevent;
}

void UVFurniture::setLastEvent(QString event)
{
    m_lastevent = event;
    Q_EMIT lastEventChanged();
}

QString UVFurniture::office() const
{
    return m_office;
}

QString UVFurniture::description() const
{
    return m_description;
}

QString UVFurniture::tag(QString key) const
{
    return m_tags.value(key);
}
