#include "cdemotask.h"

void test_cplusplus_stpool_testFun()
{
    // Set the necessary capabilities masks
    long eCaps = eCAP_F_DYNAMIC|eCAP_F_CUSTOM_TASK|eCAP_F_TASK_WAIT;

    stpool::CTaskPool *taskPool = stpool::CTaskPool::create("mypool", eCaps, 1, 0, 0, false);

    // Create a task and set its destination pool to our created pool
    CDemoTask *task  = new CDemoTask("mytask");
    task->setPool(taskPool);

    // Schedule the task
    for (int itimes = 0; itimes < 5; itimes ++) {
        task->queue();
        task->wait();
    }
    delete task;

    // Release the pool
    taskPool->release();
}
