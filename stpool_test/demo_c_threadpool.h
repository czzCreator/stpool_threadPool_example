#ifndef DEMO_C_THREADPOOL_H
#define DEMO_C_THREADPOOL_H

#include <stdio.h>

#include "stpool.h"

#if defined(WIN32) || defined(_WIN32) || defined(_WIN64)
#include <windows.h>
#define msleep Sleep
#ifdef _DEBUG
#ifdef _WIN64

//mingw 下这种写法不支持 只有 微软的MSVC等支持
//#pragma comment(lib, "../x64/Debug/libmsglog.lib")
//#pragma comment(lib, "../x64/Debug/libstpool.lib")
//#else
//#pragma comment(lib, "../Debug/libmsglog.lib")
//#pragma comment(lib, "../Debug/libstpool.lib")

#endif
#else
#ifdef _WIN64

//mingw 下这种写法不支持 只有 微软的MSVC等支持
//#pragma comment(lib, "../x64/Release/libmsglog.lib")
//#pragma comment(lib, "../x64/Release/libstpool.lib")

#else

//mingw 下这种写法不支持 只有 微软的MSVC等支持
//#pragma comment(lib, "../Release/libmsglog.lib")
//#pragma comment(lib, "../Release/libstpool.lib")

#endif
#endif
#else
#include <unistd.h>
#define msleep(ms) usleep(ms * 1000)
#endif


extern int simple_test_c_libstpool();



#endif // DEMO_C_THREADPOOL_H
