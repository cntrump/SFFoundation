//
//  SFURIFixup.h
//  SFFoundation
//
//  Created by v on 2019/11/4.
//  Copyright © 2019 lvv. All rights reserved.
//

@interface SFURIFixup : NSObject

+ (NSURL *)getURL:(NSString *)entry;

@end

@interface NSCharacterSet (SFURL)

+ (instancetype)sf_URLAllowedCharacterSet;

@end
