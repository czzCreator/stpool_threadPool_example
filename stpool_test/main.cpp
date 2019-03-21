#include "mainwindow.h"
#include <QApplication>

#include <QThread>
#include <QDebug>

#include "qlog_message_handler.h"

#include "stpool.h"
#include "stpool_caps.h"
#include "stpool_group.h"

#include "demo_c_threadpool.h"
#include "cdemotask.h"


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);


    //定义日志文件位置(配置文件中读出 参数初始化日志)
    message_handler::QLog_MessageHandler::setLogDir(DEFAULT_PROC_LOG_DIR);
    message_handler::QLog_MessageHandler::setLogReserve_day(DEFAULT_LOG_RESERVE_DAY);

#if (QT_VERSION >= QT_VERSION_CHECK(5, 6, 0))
    qInstallMessageHandler(message_handler::QLog_MessageHandler::FormatMessage_myown);
#else
    qInstallMsgHandler(message_handler::QLog_MessageHandler::FormatMessage_myown);
#endif

    //debug test
    qDebug() << QString("main() Thread Id:") << QThread::currentThreadId();

    simple_test_c_libstpool();

    test_cplusplus_stpool_testFun();

    MainWindow w;
    w.show();

    return a.exec();
}
