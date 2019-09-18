//
//  SFRWLock.h
//  SFFoundation
//
//  Created by vvveiii on 2019/9/18.
//  Copyright © 2019 lvv. All rights reserved.
//


@interface SFRWLock : NSObject

- (void)RDLock;

- (void)WRLock;

- (BOOL)tryRDLock;

- (BOOL)tryWRLock;

- (void)unlock;

@end
