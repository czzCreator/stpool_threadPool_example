#include "demo_c_threadpool.h"

#include <QDebug>

/**
 * (log library)    depends  (task pool library)
 * libmsglog.lib <-------------libstpool.lib
 */
void task_run(struct sttask *ptask)
{
    int e;

    qDebug() << QString(" \n\n RunTask: %1 \n").arg(ptask->task_name);
    //printf("\n\nRun %s\n", ptask->task_name);

    /** Sleep for a while to slow down the test */
    msleep(1000);

    /** Reschedule the task */
    /*
    * @note  If the pool's throttle is on, the pool will prevent users delivering
    * 		  any tasks into its pending queue.
    */
    if ((e = stpool_task_queue(ptask)))
    {
        qCritical() << QString("***reschedule(%1): '%2'\n").arg(ptask->task_name).arg(stpool_strerror(e));
//        fprintf(stderr, "***reschedule(%s): '%s'\n",
//            ptask->task_name, stpool_strerror(e));
    }
}

void task_err_handler(struct sttask *ptask, long reasons)
{
    qCritical() << QString("**ERR: '%1' (%2)\n").arg(ptask->task_name).arg(reasons);
//    fprintf(stderr, "**ERR: '%s' (%lx)\n",
//            ptask->task_name, reasons);
}


int simple_test_c_libstpool()
{
    stpool_t *pool;
    struct schattr attr[] = {
    {0, 0,  ep_SCHE_BACK},
    {0, 10, ep_SCHE_BACK},
    {0, 40, ep_SCHE_BACK},
    {0, 90, ep_SCHE_TOP},
    };

    long eCAPs = eCAP_F_SUSPEND|eCAP_F_ROUTINE|eCAP_F_PRIORITY|eCAP_F_THROTTLE|eCAP_F_WAIT_ALL;

    /**
    * Creat a pool with 1 servering threads
    */
    pool = stpool_create("mypool", eCAPs, 1, 0, 1, 1);

    /**
         * Add a few tasks into the pool
         */
    stpool_add_routine(pool, "zero_task",   task_run, task_err_handler, NULL, &attr[0]);
    stpool_add_routine(pool, "low_task",    task_run, task_err_handler, NULL, &attr[1]);
    stpool_add_routine(pool, "middle_task", task_run, task_err_handler, NULL, &attr[2]);
    stpool_add_routine(pool, "hight_task",  task_run, task_err_handler, NULL, &attr[3]);

    qDebug() << QString("Print any key to resume the pool ...\n");
    getchar();

    /**
         * Wake up the pool to run the tasks
         */
    stpool_resume(pool);

    qDebug() << QString("Print any key to exit the test ...\n");
    getchar();

    /**
         * Turn the throttle on
         * 如果把下面这句注释了   例子中 task_run()的 stpool_task_queue() 会再次将任务加入线程池 形成递归循环不停执行任务
         * 下面这句主要作用就是禁止用户自己将任务重新分配到线程池执行
         */
    stpool_throttle_enable(pool, 1);

    /**
         * Remove all pendings task
         */
    stpool_remove_all(pool, 0);

    /**
         * Wait for all tasks' completions
         */
    stpool_wait_all(pool, -1);

    qDebug() << QString("All tasks have been removed completely.\n");
    getchar();

    /**
         * Release the pool
         */
    stpool_release(pool);

    qDebug() << QString("print any key to exit.\n");
    getchar();
    return 0;
}
