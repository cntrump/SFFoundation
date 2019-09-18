//
//  SFRWLock.m
//  SFFoundation
//
//  Created by vvveiii on 2019/9/18.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFRWLock.h"
#import <pthread.h>

@interface SFRWLock () {
    pthread_rwlock_t _rwlock;
}

@end

@implementation SFRWLock

- (void)dealloc {
    pthread_rwlock_destroy(&_rwlock);
}

- (instancetype)init {
    if (self = [super init]) {
        pthread_rwlock_init(&_rwlock, NULL);
    }

    return self;
}

- (void)RDLock {
    pthread_rwlock_rdlock(&_rwlock);
}

- (void)WRLock {
    pthread_rwlock_wrlock(&_rwlock);
}

- (BOOL)tryRDLock {
    return pthread_rwlock_tryrdlock(&_rwlock) == 0;
}

- (BOOL)tryWRLock {
    return pthread_rwlock_trywrlock(&_rwlock) == 0;
}

- (void)unlock {
    pthread_rwlock_unlock(&_rwlock);
}

@end
