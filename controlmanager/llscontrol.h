﻿#ifndef LLSCONTROL_H
#define LLSCONTROL_H

#include <QObject>
class QQmlApplicationEngine;
class BoothManage;
class BaiduFaceManager;

class LLSControlManager : public QObject{
    Q_OBJECT
public:
    explicit LLSControlManager(QQmlApplicationEngine* engine,QObject* parent = nullptr);

private:
    void init();

private:
    QQmlApplicationEngine*          m_pEngine = nullptr;
    BoothManage*                    m_pBoothManager = nullptr;
    BaiduFaceManager*               m_pBaiduFaceManage = nullptr;
};

#endif // LLSCONTROL_H