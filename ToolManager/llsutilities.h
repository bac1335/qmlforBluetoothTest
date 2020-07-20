#ifndef LLSUTILITIES_H
#define LLSUTILITIES_H
/**
    * @brief         常用工具
    * @date          2020-07-20
    */
#include <QString>

#define NOMALKEY "1357902468bac1335"

class LLSUtilities {
public:
    /**
    * @brief    用于字符串的加密，通过key值,对value加密，返回加密字符串
    * @parame   value,key
    */
    static QString SimpleEncryption(QString value,QString key);
    /**
    * @brief    用于字符串的解密，通过key值，对value解密，返回字符串
    * @parame   value，key
    */
    static QString SimpleDecryption(QString value,QString key);
    /**
    * @brief    复制文件夹
    */
    static bool copyDirectory(QString fromDir, QString toDir, bool bCoverIfFileExists);
    /**
    * @brief    清空文件夹
    */
    static void cleanDirectory(const QString dirName);
    /**
    * @brief    删除文件夹
    */
    static void removeDirectory(const QString dirName);
    /**
    * @brief    获取文件的md5码
    */
    QString getFileMd5(const QString &filePath);

};

#endif // LLSUTILITIES_H
