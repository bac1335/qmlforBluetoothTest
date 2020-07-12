#ifndef BAIDUFACEMANAGER_H
#define BAIDUFACEMANAGER_H
#include <QObject>

class BaiduFaceManager : public QObject{
    Q_OBJECT
public:
    explicit BaiduFaceManager(QObject* parent = nullptr);
    void startFace();
    Q_INVOKABLE QString start(QString imgpath);

private:
    void init();

private:
    bool        m_bIsFaceTakenOk = false;
    QString     m_id;
    QString     m_appKey;
    QString     m_secretKey;

};

#endif // BAIDUFACEMANAGER_H
