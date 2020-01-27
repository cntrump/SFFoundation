//
//  SFKeychainPasswordItem.h
//  SFFoundation
//
//  Created by v on 2020/1/27.
//  Copyright © 2020 lvv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFKeychainPasswordItem : NSObject

@property(nonatomic, copy) NSString *service;
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *accessGroup;

- (instancetype)initWithService:(NSString *)service
                        account:(NSString *)account
                    accessGroup:(NSString *)accessGroup;

- (NSString *)readPassword;

- (BOOL)savePassword:(NSString *)password;

- (BOOL)renameAccount:(NSString *)newAccountName;

- (BOOL)deleteItem;

@end

@interface SFKeychainPasswordItem (SFExtend)

+ (NSArray<SFKeychainPasswordItem*> *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end
