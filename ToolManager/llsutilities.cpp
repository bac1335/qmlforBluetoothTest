#include "llsutilities.h"
#include <QDir>
#include <QCryptographicHash>
#include <QDebug>

QString LLSUtilities::SimpleEncryption(QString value, QString key)
{
    QString encrypt;

    for(int i = 0; i<value.size(); i++){
        int index = i % key.size();
        QChar ch = QChar((char)(value.at(i).toLatin1() ^ key.at(index).digitValue()));
        encrypt.append(ch);
    }
    return encrypt;
}

QString LLSUtilities::SimpleDecryption(QString value, QString key)
{
    QString decrypt;

    for(int i = 0; i<value.size(); i++){
        int index = i % key.size();
        decrypt.append((char)(value.at(i).toLatin1() ^ key.at(index).digitValue()));
    }

    return decrypt;
}

bool LLSUtilities::copyDirectory(QString fromDir, QString toDir, bool bCoverIfFileExists)
{
    QDir formDir_(fromDir);
    QDir toDir_(toDir);

    if(!toDir_.exists()){
        if(!toDir_.mkdir(toDir)){
            return false;
        }
    }

    QFileInfoList fileInfoList = formDir_.entryInfoList(QDir::Dirs
                                                        |QDir::Files|
                                                        QDir::Hidden|
                                                        QDir::NoDotAndDotDot);
    QString fileName;
    foreach(QFileInfo fileInfo, fileInfoList){
        fileName = fileInfo.fileName();
        if(fileInfo.isDir()){
            //递归调用拷贝
            if(!copyDirectory(fileInfo.filePath(),
                              toDir+ QString("/") + (fileName),
                              bCoverIfFileExists)){
                Q_ASSERT_X(1 == 0, "QFile::copy, can't copy dir", qPrintable(fileInfo.filePath()));
                continue;
            }
        }else{
            //拷贝子文件
            if(toDir_.exists(fileName)){
                if(bCoverIfFileExists){
                    toDir_.remove(fileName);
                }else{
                    continue;
                }
            }
            QString fromfile = fileInfo.filePath();
            QString tofile = toDir_.filePath(fileName);
            if(!QFile::copy(fromfile, tofile)){
                Q_ASSERT_X(1 == 0, "QFile::copy, can't copy file", qPrintable(fromfile));
                continue;
            }
        }
    }
    return true;
}

void LLSUtilities::cleanDirectory(const QString dirName)
{
    QDir dir(dirName);
    if(!dir.exists()){
        return;
    }
    QStringList dirNames;
    QFileInfoList filst;
    QFileInfoList::iterator curFi;
    dirNames << dirName;
    for(int i = 0; i < dirNames.size(); ++i ){
        //遍历各级文件夹，并将这些文件夹中的文件删除
        dir.setPath(dirNames.at(i));
        filst = dir.entryInfoList(QDir::Dirs|QDir::Files|QDir::Readable|QDir::Writable|
                                  QDir::Hidden|QDir::NoDotAndDotDot,QDir::Name);
        curFi=filst.begin();
        while(curFi!=filst.end()){
            if(curFi->isDir()){
                //遇到文件夹,则添加至文件夹列表dirs尾部
                dirNames << (curFi->filePath());
            }else if(curFi->isFile()){
                dir.remove(curFi->filePath());	//删除文件
            }
            curFi++;
        }
    }
    //不删除最外层文件夹 i不能等于0
    for(int i = dirNames.size() - 1; i > 0; i-- ){
        //删除文件夹
        dir.setPath(dirNames.at(i));
        if(!dir.rmdir(".")){//删除失败
            dirNames.removeAt(i);
        }
    }
}

void LLSUtilities::removeDirectory(const QString dirName)
{
    QDir dir(dirName);
    if(!dir.exists()){
        return;
    }
    QStringList dirNames;
    QFileInfoList filst;
    QFileInfoList::iterator curFi;
    dirNames << dirName;
    for(int i = 0; i < dirNames.size(); ++i ){
        //遍历各级文件夹，并将这些文件夹中的文件删除
        dir.setPath(dirNames.at(i));
        filst = dir.entryInfoList(QDir::Dirs|QDir::Files|QDir::Readable|QDir::Writable|
                                  QDir::Hidden|QDir::NoDotAndDotDot,QDir::Name);
        curFi=filst.begin();
        while(curFi!=filst.end()){
            if(curFi->isDir()){
                //遇到文件夹,则添加至文件夹列表dirs尾部
                dirNames << (curFi->filePath());
            }else if(curFi->isFile()){
                dir.remove(curFi->filePath());	//删除文件
            }
            curFi++;
        }
    }
    for(int i = dirNames.size() - 1; i >= 0; i-- ){
        //删除文件夹
        dir.setPath(dirNames.at(i));
        dir.rmdir(".");
    }
}

QString LLSUtilities::getFileMd5(const QString &filePath)
{
    QFile theFile(filePath);
    if(!theFile.open(QIODevice::ReadOnly))
    {
        qDebug() << "--->lls<---" << __FUNCTION__  << "open fail";
        return "";
    }
    QByteArray ba = QCryptographicHash::hash(theFile.readAll(),QCryptographicHash::Md5);
    theFile.close();
    return QString(ba);
}
