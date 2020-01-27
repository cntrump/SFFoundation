//
//  SFKeychainPasswordItem.m
//  SFFoundation
//
//  Created by v on 2020/1/27.
//  Copyright © 2020 lvv. All rights reserved.
//

#import "SFKeychainPasswordItem.h"

@implementation SFKeychainPasswordItem

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ service:%@ account:%@ accessGroup:%@>",
            NSStringFromClass(self.class), _service, _account, _accessGroup];
}

- (instancetype)initWithService:(NSString *)service account:(NSString *)account accessGroup:(NSString *)accessGroup {
    if (self = [super init]) {
        _service = service;
        _account = account;
        _accessGroup = accessGroup;
    }

    return self;
}

- (NSString *)readPassword {
    NSMutableDictionary *query = [self keychainQuery];
    query[(NSString *)kSecMatchLimit] = (NSString *)kSecMatchLimitOne;
    query[(NSString *)kSecReturnAttributes] = (NSNumber *)kCFBooleanTrue;
    query[(NSString *)kSecReturnData] = (NSNumber *)kCFBooleanTrue;

    CFDictionaryRef queryResult = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&queryResult);
    if (status != noErr) {
        return nil;
    }

    NSString *password = nil;
    NSDictionary *existingItem = (__bridge NSDictionary *)queryResult;
    if (existingItem) {
        NSData *passwordData = existingItem[(NSString *)kSecValueData];
        password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        CFRelease(queryResult);
    }

    return password;
}

- (BOOL)savePassword:(NSString *)password {
    NSData *encodedPassword = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *attributesToUpdate = NSMutableDictionary.dictionary;
    attributesToUpdate[(NSString *)kSecValueData] = encodedPassword;
    NSDictionary *query = [self keychainQuery];
    OSStatus status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
    if (status == errSecItemNotFound) {
        NSMutableDictionary *newItem = [self keychainQuery];
        newItem[(NSString *)kSecValueData] = encodedPassword;
        status = SecItemAdd((CFDictionaryRef)newItem, NULL);
    }

    return status == noErr;
}

- (BOOL)renameAccount:(NSString *)newAccountName {
    NSMutableDictionary *attributesToUpdate = NSMutableDictionary.dictionary;
    attributesToUpdate[(NSString *)kSecAttrAccount] = newAccountName;
    NSDictionary *query = [self keychainQuery];
    OSStatus status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
    if (status == noErr) {
        _account = newAccountName;

        return YES;
    }

    return NO;
}

- (BOOL)deleteItem {
    NSDictionary *query = [self keychainQuery];
    OSStatus status = SecItemDelete((CFDictionaryRef)query);

    return status == noErr;
}

- (NSMutableDictionary<NSString*, id> *)keychainQuery {
    NSMutableDictionary *query = NSMutableDictionary.dictionary;
    query[(NSString *)kSecClass] = (NSString *)kSecClassGenericPassword;
    query[(NSString *)kSecAttrService] = _service;

    if (_account) {
        query[(NSString *)kSecAttrAccount] = _account;
    }

    if (_accessGroup) {
        query[(NSString *)kSecAttrAccessGroup] = _accessGroup;
    }

    return query;
}

@end


@implementation SFKeychainPasswordItem (SFExtend)

+ (NSArray<SFKeychainPasswordItem*> *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup {
    NSMutableDictionary *query = NSMutableDictionary.dictionary;
    query[(NSString *)kSecClass] = (NSString *)kSecClassGenericPassword;
    query[(NSString *)kSecAttrService] = service;
    if (accessGroup) {
        query[(NSString *)kSecAttrAccessGroup] = accessGroup;
    }

    query[(NSString *)kSecMatchLimit] = (NSString *)kSecMatchLimitAll;
    query[(NSString *)kSecReturnAttributes] = (NSNumber *)kCFBooleanTrue;
    query[(NSString *)kSecReturnData] = (NSNumber *)kCFBooleanFalse;

    CFArrayRef queryResult = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&queryResult);
    if (status != noErr) {
        return nil;
    }

    NSArray *resultData = (__bridge NSArray *)queryResult;
    if (resultData) {
        NSMutableArray *passwordItems = NSMutableArray.array;
        for (NSDictionary *result in resultData) {
            NSString *account  = result[(NSString *)kSecAttrAccount];
            [passwordItems addObject:[[SFKeychainPasswordItem alloc] initWithService:service
                                                                             account:account
                                                                         accessGroup:accessGroup]];
        }

        CFRelease(queryResult);

        return passwordItems;
    }

    return nil;
}

@end
