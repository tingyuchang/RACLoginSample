//
//  TTLoginViewModel.h
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTAuth.h"

@interface TTLoginViewModel : NSObject


@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *statusMessage;

@property (strong, nonatomic) TTAuth *auth;

- (void)racLogin;

@end
