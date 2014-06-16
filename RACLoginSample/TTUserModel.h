//
//  TTUserModel.h
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/MTLJSONAdapter.h>

@interface TTUserModel : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic, readonly) NSString *user_id;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *secret;

- (void)saveTofile:(void(^)(void))completion;

@end