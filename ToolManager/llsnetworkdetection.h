#ifndef LLSNETWORKDETECTION_H
#define LLSNETWORKDETECTION_H

    /**
    * @projectName   toolsoft
    * @brief         网络检测模块工具
    */
#define LLSNDState LLSNetworkDetction::inistance()

#include <QThread>
class QProcess;
class LLSNetworkDetction : public QThread{
    Q_OBJECT
public:
    enum NetState{
        Net_connection,
        Net_closed,
    };
    explicit LLSNetworkDetction(QThread* parent = nullptr);
    ~LLSNetworkDetction();
    static LLSNetworkDetction* inistance();
    /**
    * @brief 获取外网连接状态，无需阻塞
    */
    bool isConnected();
    /**
    * @brief 获取特定网络连接状态，需阻塞等待
    * @param
    */
    bool isConnected(QString url);

protected:
    void run();

signals:
    /**
    * @brief 网络发生变化发出得信号，用于改变界面相应ui效果
    * @param true表示连接网络，false表示未连接
    */
    void sigNetworkStateChange(bool);

private:
    static       LLSNetworkDetction* m_pInstance;
    bool         m_bRunState = true;
    QProcess*    m_pNetworkProcess = nullptr;
    NetState     m_netState = Net_closed;
};

#endif // LLSNETWORKDETECTION_H
