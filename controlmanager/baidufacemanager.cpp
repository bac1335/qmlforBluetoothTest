#include "baidufacemanager.h"
#include "llsetting.h"
#include <QVariant>
#include <QDebug>
#include "face.h"
#include <QImage>
#include <QFile>
#include "llsnetworkdetection.h"
#include <QBuffer>
#include <QElapsedTimer>

#include <QDate>
#include <QtConcurrent/QtConcurrent>

BaiduFaceManager::BaiduFaceManager(QObject *parent):
    QObject(parent)
{
    init();
}

void BaiduFaceManager::startFace()
{

}

QString BaiduFaceManager::start(QString imgpath)
{
    qDebug() << "--->lls<---" << __FUNCTION__  << imgpath << m_bIsFaceTakenOk;

    if(!LLSNDState->isConnected()){
        return "-1";
    }

    if(m_bIsFaceTakenOk){
        QElapsedTimer eptimer;
        eptimer.start();
        std::string app_id = m_id.toStdString();
        std::string api_key = m_appKey.toStdString();
        std::string secret_key = m_secretKey.toStdString();
        aip::Face client(app_id, api_key, secret_key);


        Json::Value result;

        if(imgpath.contains("file:///")){
            imgpath.replace("file:///","");
        }

        QFile file(imgpath);
        QByteArray array;


        if(!file.open(QFile::ReadOnly)) return "";

        array =file.readAll().toBase64();
        file.close();

        if(array.isEmpty()) return "";

        std::string image = array.toStdString();

        std::string image_type ="BASE64";

        // 调用人脸检测
      //  result = client.detect(image, image_type, aip::null);

        // 如果有可选参数
        std::map<std::string, std::string> options;
        options["face_field"] = "age";
        options["max_face_num"] = "10";
        options["face_type"] = "LIVE";
        options["liveness_control"] = "LOW";
        qDebug() << "--->lls<---112" << __FUNCTION__  << eptimer.elapsed();

        result = client.detect(image, image_type, options);

        qDebug() << "--->lls<---110" << __FUNCTION__  << eptimer.elapsed();
        return result.toStyledString().c_str();
    }
    else{
        return "";
    }
}

QString BaiduFaceManager::startFromStr(const QImage* img)
{

    if(!LLSNDState->isConnected()){
        return "-1";
    }

    if(m_bIsFaceTakenOk){
        QElapsedTimer eptimer;
        eptimer.start();
        std::string app_id = m_id.toStdString();
        std::string api_key = m_appKey.toStdString();
        std::string secret_key = m_secretKey.toStdString();
        aip::Face client(app_id, api_key, secret_key);
        Json::Value result;
        std::string image_type ="BASE64";
        qDebug() << "--->lls<---112" << __FUNCTION__  << eptimer.elapsed();

        std::map<std::string, std::string> options;
        options["face_field"] = "age";
        options["max_face_num"] = "10";
        options["face_type"] = "LIVE";
        options["liveness_control"] = "LOW";

        QByteArray arrayImg;
        QBuffer buffer(&arrayImg);
        buffer.open(QBuffer::ReadWrite);
        img->save(&buffer,"PNG",100);
        buffer.close();
        qDebug() << "--->lls<---110" << __FUNCTION__  << eptimer.elapsed();
        result = client.detect(arrayImg.toBase64().toStdString(), image_type, options);
        qDebug() << "--->lls<---111" << __FUNCTION__  << eptimer.elapsed();

        return result.toStyledString().c_str();
    }
    else{
        return "";
    }
}

bool BaiduFaceManager::addImgToServer(const QImage *img)
{
    if(m_bIsFaceTakenOk){
         QtConcurrent::run([=](){

             QImage image = *img;
             QElapsedTimer eptimer;
             eptimer.start();
             std::string app_id = m_id.toStdString();
             std::string api_key = m_appKey.toStdString();
             std::string secret_key = m_secretKey.toStdString();
             aip::Face client(app_id, api_key, secret_key);
             Json::Value result;
             std::string image_type ="BASE64";
             qDebug() << "--->lls<---112" << __FUNCTION__  << eptimer.elapsed();

             QByteArray arrayImg;
             QBuffer buffer(&arrayImg);
             buffer.open(QBuffer::ReadWrite);
             image.save(&buffer,"PNG",100);
             buffer.close();
             qDebug() << "--->lls<---110" << __FUNCTION__  << eptimer.elapsed();
     //        result = client.detect(arrayImg.toBase64().toStdString(), image_type, options);
             qDebug() << "--->lls<---111" << __FUNCTION__  << eptimer.elapsed();
             std::string group_id = QString(QDate::currentDate().toString("ddMMyyyy")).toStdString();
             std::string user_id = QString(QDate::currentDate().toString("ddMMyyyy") + QTime::currentTime().toString("hhmmss") + QString::number(qrand()%10)).toStdString();
             client.user_add(arrayImg.toBase64().toStdString(),image_type,group_id,user_id,aip::null);
         });
    }
    return m_bIsFaceTakenOk;
}

void BaiduFaceManager::onSendServerImg(QImage *img)
{
    qDebug() << "===========================" __FUNCTION__;
    if(LLSNDState->isConnected()){
          addImgToServer(img);
    }
}

void BaiduFaceManager::init()
{
    qsrand(QTime::currentTime().msec());
    m_id = LLSettings->getValue("APPTaken","AppID","").toString();
    m_appKey = LLSettings->getValue("APPTaken","APIKey","").toString();
    m_secretKey = LLSettings->getValue("APPTaken","SecretKey","").toString();

    m_bIsFaceTakenOk = !(m_id.isEmpty() || m_appKey.isEmpty() || m_secretKey.isEmpty());

    qDebug() << "====================444======================" << QDate::currentDate().toString("ddMMyyyy") + QTime::currentTime().toString("hhmmss") + QString::number(qrand()%10);
}
