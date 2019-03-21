#ifndef CDEMOTASK_H
#define CDEMOTASK_H

#include <QDebug>

#include <iostream>

#include "stpool_caps.h"
#include "stpool.h"
#include "stpoolc++.h"



//C++ version example


using std::cout;
using std::cerr;
using std::hex;
using std::endl;


//继承CTask 方法必须重写 onRun()   onErrHandler(long reasons)  两个方法
class CDemoTask : public stpool::CTask
{
    public:
        CDemoTask(const string &name, stpool::CTaskPool *pTaskPool = NULL):
            stpool::CTask(name, pTaskPool) {
            qDebug() << __FUNCTION__ << ":" << this << "\n";
        }

        ~CDemoTask() {
            qDebug() << __FUNCTION__ << ":" << this << "\n";
        }

        virtual void onRun() {
            qDebug() << "task('"<< taskName().c_str() << "') is running ..."  << "\n";
        }

        virtual void onErrHandler(long reasons) {
            qCritical() << "task('"<< taskName().c_str() << "') has not been executed for reasons(" << hex << reasons << ")" << "\n";
        }
};

extern void test_cplusplus_stpool_testFun();

#endif // CDEMOTASK_H
