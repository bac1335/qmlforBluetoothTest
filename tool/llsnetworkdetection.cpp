#include "llsnetworkdetection.h"
#include <QProcess>

#define BAIDUWEB "www.baidu.com"

LLSNetworkDetction* LLSNetworkDetction::m_pInstance = nullptr;

LLSNetworkDetction* LLSNetworkDetction::inistance()
{
    if(!m_pInstance){
        m_pInstance = new LLSNetworkDetction;
        m_pInstance->start();
    }

    return m_pInstance;
}

bool LLSNetworkDetction::isConnected()
{
    return m_netState == Net_connection;
}

bool LLSNetworkDetction::isConnected(QString url)
{
    QString network_cmd = QString("%1 -n 2 -w 500").arg(url);
    QString result;
    QProcess process;
    process.start(network_cmd);   //调用ping 指令
    process.waitForFinished();    //等待指令执行完毕
    result = process.readAll();   //获取指令执行结果
    bool isConnected = false;
    if(result.contains(QString("TTL=")))   //若包含TTL=字符串则认为网络在线
    {
        isConnected = true;
    }
    else
    {
        isConnected = false;
    }
    return isConnected;
}

void LLSNetworkDetction::run()
{
    QString network_cmd = QString("ping %1 -n 2 -w 500").arg(BAIDUWEB);
    QString result;
    m_pNetworkProcess = new QProcess();
    while(m_bRunState)
    {
        m_pNetworkProcess->start(network_cmd);   //调用ping 指令
        m_pNetworkProcess->waitForFinished();    //等待指令执行完毕
        result = m_pNetworkProcess->readAll();   //获取指令执行结果
        NetState state;
        if(result.contains(QString("TTL=")))   //若包含TTL=字符串则认为网络在线
        {
            state = Net_connection;
        }
        else
        {
            state = Net_closed;
        }

        if(m_netState !=state){
            qInfo("======================nectworkChanged=========================%s",__FUNCTION__);
            emit sigNetworkStateChange(state == Net_connection);
        }

        m_netState = state;
        QThread::msleep(1000);
    }
}
