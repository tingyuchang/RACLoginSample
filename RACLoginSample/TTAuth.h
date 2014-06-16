//
//  TTAuth.h
//  MantleSample
//
//  Created by Matt Chang on 2014/5/29.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTAuth : NSObject

@property (strong, nonatomic, readonly) NSString *consumer_key;
@property (strong, nonatomic, readonly) NSString *consumer_secret;
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *access_secret;

- (BOOL)isValidated;

@end
