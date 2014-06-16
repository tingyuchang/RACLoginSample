//
//  TTUserModel.m
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "TTUserModel.h"

@implementation TTUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name": @"name",
             @"email": @"email",
             @"phone": @"phone",
             @"user_id": @"user_id"};
}

- (void)saveTofile:(void(^)(void))completion {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:USER_SAVE_PATH];
    [NSKeyedArchiver archiveRootObject:self toFile:fileName];
    completion();
}

@end
