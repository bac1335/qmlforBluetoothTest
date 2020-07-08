#ifndef LLSETTING_H
#define LLSETTING_H
#include <QSharedPointer>

#define LLSettings LLSetting::instance()

class QSettings;
class LLSetting{
public:
    static LLSetting* instance();
    void setValue(QString group,QString key,QString value);
    QVariant getValue(QString group,QString key,QString defaultValue = QString());

private:
    LLSetting();
    void        init();

private:
    static LLSetting*               m_setting;
    QSharedPointer<QSettings>       m_pSetting;
};


#endif // LLSETTING_H
