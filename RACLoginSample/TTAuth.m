//
//  TTAuth.m
//  MantleSample
//
//  Created by Matt Chang on 2014/5/29.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "TTAuth.h"
#import "NSString+Extension.h"

@implementation TTAuth

- (id)init {
    self = [super init];
    if (self) {
        _consumer_key = OAUTH_CONSUMER_KEY;
        _consumer_secret = OAUTH_CONSUMER_SECRET;
    }
    return self;
}

- (BOOL)isValidated {
    if ([NSString isEmpty:self.access_token] || [NSString isEmpty:self.access_secret]) {
        return NO;
    }
    return YES;
}

@end
