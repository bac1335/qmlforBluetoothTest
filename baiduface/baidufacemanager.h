#ifndef BAIDUFACEMANAGER_H
#define BAIDUFACEMANAGER_H
#include <QObject>

class BaiduFaceManager : public QObject{
    Q_OBJECT
public:
    explicit BaiduFaceManager(QObject* parent = nullptr);
    void startFace();

private:
    void init();

private:
    bool        m_bIsFaceTakenOk = false;

};

#endif // BAIDUFACEMANAGER_H
