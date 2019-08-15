//
//  SFRunLoopObserver.m
//  SFFoundation
//
//  Created by vvveiii on 2019/7/16.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFRunLoopObserver.h"
#import "SFDispatchSemaphore.h"

static void RunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
static void RegisterRunLoopObserver(CFRunLoopRef runLoop, SFRunLoopObserver *ob);

@interface SFRunLoopObserver () {
    NSHashTable<id<SFRunLoopTransaction>> *_transactions;
    SFDispatchSemaphore *_lock;
}

@end

@implementation SFRunLoopObserver

+ (instancetype)mainObserver {
    static SFRunLoopObserver *observer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[self alloc] init];
        RegisterRunLoopObserver(CFRunLoopGetMain(), observer);
    });

    return observer;
}

- (instancetype)init {
    if (self = [super init]) {
        _transactions = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
        _lock = [SFDispatchSemaphore semaphoreWithValue:1];
    }

    return self;
}

- (void)commit {
    if (_transactions.count == 0) {
        return;
    }
    
    NSHashTable<id<SFRunLoopTransaction>> *transactions;

    [_lock wait];
    transactions = _transactions.copy;
    [_transactions removeAllObjects];
    [_lock signal];

    for (id<SFRunLoopTransaction> transaction in transactions) {
        if ([transaction respondsToSelector:@selector(commit)]) {
            [transaction commit];
        }
    }
}

- (void)addTransaction:(id<SFRunLoopTransaction>)transaction {
    [_lock wait];
    [_transactions addObject:transaction];
    [_lock signal];
}

@end

static void RunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    SFRunLoopObserver *ob = (__bridge SFRunLoopObserver *)info;
    [ob commit];
}

static void RegisterRunLoopObserver(CFRunLoopRef runLoop, SFRunLoopObserver *ob) {
    CFRunLoopObserverContext ctx;
    ctx.version = 0;
    ctx.release = &CFRelease;
    ctx.retain = &CFRetain;
    ctx.copyDescription = NULL;
    ctx.info = (__bridge void *)ob;

    CFRunLoopObserverRef runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                                   kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                                                   YES,
                                                                   INT_MAX,
                                                                   &RunLoopObserverCallBack,
                                                                   &ctx);
    CFRunLoopAddObserver(runLoop, runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
}
