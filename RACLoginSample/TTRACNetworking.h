//
//  TTRACNetworking.h
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRACNetworking : NSObject

- (RACSignal *)getRequestToken;
- (RACSignal *)authenticate:(NSString *)account password:(NSString *)password auth:(NSDictionary *)auth;
- (RACSignal *)getAccessToken:(NSDictionary *)auth;

@end
