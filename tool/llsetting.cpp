#include "llsetting.h"
#include <QSettings>
#include <QApplication>
#include <QDebug>

LLSetting* LLSetting::m_setting = nullptr;

LLSetting *LLSetting::instance()
{
    if(!m_setting){
        m_setting = new LLSetting;
    }
    return m_setting;
}

void LLSetting::setValue(QString group, QString key, QString value)
{
    m_pSetting->beginGroup(group);
    m_pSetting->setValue(key,value);
    m_pSetting->endGroup();
}

QVariant LLSetting::getValue(QString group, QString key, QString defaultValue)
{
    m_pSetting->beginGroup(group);
    QVariant data = m_pSetting->value(key,defaultValue);
    m_pSetting->endGroup();
    return data;
}

LLSetting::LLSetting()
{
    init();
}

void LLSetting::init()
{
    QString appPath = qApp->applicationDirPath() + "/config.ini";
    m_pSetting = QSharedPointer<QSettings>(new QSettings(appPath,QSettings::IniFormat));
}
