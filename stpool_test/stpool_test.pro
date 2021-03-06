#-------------------------------------------------
#
# Project created by QtCreator 2019-01-02T21:53:57
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = stpool_test
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


# //=====================================================================================//
#                                        说明
# greate honor to piggy_xrh
# his  (Email: piggy_xrh@163.com  QQ: 1169732280)
# environment
# must support Qt5.8.0 ,mingw5.3.0 ,if you want to compile the project
# //=====================================================================================//
# 这个项目主要用于测试 可直接商用的 多线程池库stpool (听说功能强大 )
# 版本
# 2016/2/12-3.4.0-libstpool-eCAPs  (libstpool)
# 2015/10/15-1.3-libmsglog-mfilter  (libmsglog)
# 整个 库的核心 API 均位于 libstpool;  libmsglog用于支持 libstpool库

# 常规线程池的缺点：
#           1. 总是启动时候就开启固定数目的线程,而不管系统的繁忙状态
#                    (这是很浪费系统资源的).
#
#           2. 当任务繁重的时候，即使线程池被设计成可继续添加更多线程来服务
#            ，由于实时服务状态暴漏给  用户的太少,所以线程添加数目会给用户会
#             带来额外的编程麻烦, 而且性能不怎么好
#                    (对应用的扩展性太差,同时外在人工干预性太强)

#     如果你在寻找一个具有如下特性的线程池库:
#         1.  系统空闲时候线程能自动退出.任务到来时候自动启动线程服务
#         2.  线程池自动根据任务执行时间和数量智能启动合适的线程数目来服务.达到最好的调度性能
#         3.  能随时调整和控制线程池中服务线程上下限
#         4.  跨平台,同时支持 c, c++
#     那么stpool满足你的要求.

#           (你只管提交你的任务,其他所有你关心的,需要的特性, 以及你认为的瓶颈stpool替你解决)


#       线程池的难点在于:
#          1.怎样动态创建线程执行任务,因为任务运行时间不一，即使同一类型的任务,因为逻辑的
#      触发条件不一致，可能导致执行时间千差万别, 更别说各种类型不一致的任务同时投递到一个线程池中。

#          2. 对于大量任务投递进来时候，到底该创建多少线程来服务? 仅仅根据任务数量开启对应的
#      线程数是肯定不行的.

#         本线程池解决了这些难点,而且跨平台.线程池动态创建线程,动态销毁, 在系统空闲时候，
#   耗费系统资源极小.基本为0,同时在某个时间点大量并发任务产生时候,又能快速跟进提供固定线程
#   始终不退出的线程池的优点,同时会根据任务状态和多少智能创建线程调度任务.

# 特性:
#     1. 采用c语言编写,提供丰富的API接口. (已c++接口支持)
#
#     2. 对os层进行了抽象,使具有良好的跨平台的能力(支持win32,linux,unix,arm)
#
#     3. 轻便快速, API接口自然易于使用,可直接商用,支持32位,64位系统
#
#     4. 能随时调整和控制线程池的线程数目, 内部已智能动态维护力求使其占用
#         最小的系统资源来最快速调度任务
#
#.    5. 支持优先级任务,同时内置内存对象池,减少运行时间长带来的内存碎片
#
#     6.  线程池能同时支持任意类型的任务, 一个线程池中如果加入延时的，和非延时的，
#         以及延时到一定程度的等各种不同类型的任务,stpool都能完美的工作.能选择最合适
#         的线程数目来提供服务  (可自行编写demo连接debug库进行实时监控验证)
# 应用场景:
#        适合间歇性或者持续性的并发程度高,任务执行时间较短的应用系统.

#     比如下面一些常用的应用场景.
#           1.高并发服务器,利用线程池来提高响应度
#           2.在没有asio的系统上利用线程池实现asio是对用户大量回调的反馈
#           3.对应用数据的预处理,比如web服务用户接入时需要用户验证等都可以作为
#              预处理等放入线程池处理,完成后再放入统一的事件调度器中(如libevent)
#             ,提高web高并发访问.
#           4.并行计算, 如在多核CPU上进行数据并行帧数据编解码.
#           5.网络爬虫或者文件并行搜索,下载等
#           6.临时多任务处理加速.(比如: 程序启动时按任务进行服务加速,多视频通道打开加速)
#============================================================
#libstpool高级特性:

#         libstpool 3.x 现已支持group组控制. (库已开放), 整个app都可以设计运行在libstpool库上. 可以
#严格精细控制app线程环境.

# 能满足需求:
#        1.对任务进行分组，可以独立对组控制,支持所有常见访问控制
#         gid = stpool_group_create(pool, "my_group", 1, 0); //创建组
#         stpool_task_set_gid(ptsk, gid);            //设置任务组ID
#         stpool_group_set_attrl(pool, gid, attr); //设置组调度属性 (任务并发数限制)
#         stpool_group_suspend(pool, gid, 0);    //暂停所有组任务调度
#         stpool_group_resume(pool, gid);         //恢复对组的调度
#         stpool_group_remove_all(pool, gid);    //移除组上所有任务
#         stpool_group_wait_all(pool, gid, ms);    //等待组上所有任务完成
#         stpool_group_wait_cb(poo, gid, wcb, wcb_args, ms);  //访问组上任务,由wcb回调决定是否等待该任务
#         stpool_group_wait_any(pool, gid, ms);   //等待组上任一任务完成
#         stpool_group_mark_all(pool, gid, lflags); //对组上所有任务做lflags标记
#         stpool_group_mark_cb(pool, gid, wcb, wcb_args);  //定制化对组上任务标记
#         stpool_group_delete(pool, gid);       //删除组
# 场景1:
#        一个app有10个比较耗时的任务（比如加速１０个通道视频的掉线重连需求，SDK被设计成只能支
#持串行）,其它有2个并发线程负责log,   3个并发线程负责网络IO请求, ......, 各种各样的需求，每种需求
#都需要线程服务. 必须对其单独开启线程并发.  有的线程因为不忙而被创建空等待, 能否将所有需求全部
#配置到一个任务池中进行共享？
#   共享会带来的问题是，有的需求任务过多会消耗过多线程而导致饥饿其它突发性的需要及时响应的需求

#  libstpool的组服务完全可以满足如上所以需求:
#       1. libstpool的task的优先级能保证突发性的响应需求得到及时调度
#       2. libstpool的group组就像一个沙箱一样可以配置属性严格限制其在该组上并发的任务数而解
#          决饥饿问题
#       3. libstpool里的线程可以供所有group共享, 达到很好的系统性能（当libstpool在满足所有的
#          group配置需求 后，还有冗余的时候，其会从所有group中选中一些任务来执行，提供了响应
#         ,这对group来说， 它只配置了并发性为n的任务，但因为共享的好处，它获得了n + k的优惠),
#         当其它有新活动组加入时，其并发线程数会迅速的限制在limit_parralle_tasks内
#
#     libstpool3.x 重构框架,支持静态线程池,动态线程池,任务组,框架对特定需求的性能优化具有良好的扩展性和伸缩性

# //=====================================================================================//
# //=====================================================================================//
# 下面调用者 应该关注 !!!!!!!!!!!!!!!!! 如何包含库
# . 库内容
#      stpool.h  (头文件,组件API集合描述)
#     ===================================
#     已经支持的平台: Windows, Linux, ARM, Android, MAC/IOS
#     ===================================

#       WIN32             LINUX         其它支持
#   libstpool.lib      libstpool.a       @email<piggy_xrh@163.com>
#   libstpool.dll      libstpool.so

# 我在这里用的是 win32 版本的动态线程池库(dll) 并且把stpool源码工程也提供在了测试工程里 如果需要64位版本 可以自行编译
# 关于这个库的使用方法 可以到  ./stpool_src_pro 内部查看 多种example(example C++) 和 demo_win_c 工程
INCLUDEPATH += ./stpool_include
LIBS += -L./stpool_lib  \
        -lstpool


SOURCES += main.cpp\
        mainwindow.cpp \
    qlog_message_handler.cpp \
    demo_c_threadpool.cpp \
    cdemotask.cpp \
    stpoolc++.cpp

HEADERS  += mainwindow.h \
    qlog_message_handler.h \
    demo_c_threadpool.h \
    cdemotask.h \
    stpoolc++.h

FORMS    += mainwindow.ui
