//
//  SFDispatchDefine.h
//  SFFoundation
//
//  Created by vvveiii on 2019/6/24.
//  Copyright © 2019 lvv. All rights reserved.
//

#ifndef SFDispatchDefine_h
#define SFDispatchDefine_h

#define SFDispatchQueueSerial DISPATCH_QUEUE_SERIAL
#define SFDispatchQueueConcurrent DISPATCH_QUEUE_CONCURRENT

typedef NS_ENUM(long, SFDispatchQueuePriority) {
    SFDispatchQueuePriorityDefault = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    SFDispatchQueuePriorityBackground = DISPATCH_QUEUE_PRIORITY_BACKGROUND,
    SFDispatchQueuePriorityLow = DISPATCH_QUEUE_PRIORITY_LOW,
    SFDispatchQueuePriorityHigh = DISPATCH_QUEUE_PRIORITY_HIGH
};

@class SFDispatchQueue;

#define SFDispatchDelay(sec) dispatch_time(DISPATCH_TIME_NOW, (sec) * NSEC_PER_SEC)

#endif /* SFDispatchDefine_h */
