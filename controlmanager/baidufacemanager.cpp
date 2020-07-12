#include "baidufacemanager.h"
#include "llsetting.h"
#include <QVariant>
#include <QDebug>
#include "face.h"
#include <QImage>
#include <QFile>

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

    if(m_bIsFaceTakenOk){
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
        if(file.open(QFile::ReadOnly)){
            array =file.readAll().toBase64();
            file.close();
        }

        if(array.isEmpty()) return "";

        std::string image = array.toStdString();

        std::string image_type ="BASE64";

        // 调用人脸检测
      //  result = client.detect(image, image_type, aip::null);

        // 如果有可选参数
        std::map<std::string, std::string> options;
        options["face_field"] = "age";
        options["max_face_num"] = "1";
        options["face_type"] = "LIVE";
        options["liveness_control"] = "LOW";


        result = client.detect(image, image_type, options);

        qDebug() << "===========================" << result.toStyledString().c_str();
        return result.toStyledString().c_str();
    }
    else{
        return "";
    }
}

void BaiduFaceManager::init()
{
    m_id = LLSettings->getValue("APPTaken","AppID","").toString();
    m_appKey = LLSettings->getValue("APPTaken","APIKey","").toString();
    m_secretKey = LLSettings->getValue("APPTaken","SecretKey","").toString();

    m_bIsFaceTakenOk = !(m_id.isEmpty() || m_appKey.isEmpty() || m_secretKey.isEmpty());
}
