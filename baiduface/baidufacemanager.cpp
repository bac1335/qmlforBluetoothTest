#include "baidufacemanager.h"
#include "llsetting.h"
#include <QVariant>
#include <QDebug>

BaiduFaceManager::BaiduFaceManager(QObject *parent):
    QObject(parent)
{
    init();
}

void BaiduFaceManager::startFace()
{

}

void BaiduFaceManager::init()
{
    QString id = LLSettings->getValue("APPTaken","AppID","").toString();
    QString appKey = LLSettings->getValue("APPTaken","APIKey","").toString();
    QString secretKey = LLSettings->getValue("APPTaken","SecretKey","").toString();

    m_bIsFaceTakenOk = !(id.isEmpty() || appKey.isEmpty() || secretKey.isEmpty());
}
