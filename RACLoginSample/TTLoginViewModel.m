//
//  TTLoginViewModel.m
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "TTLoginViewModel.h"
#import "TTRACNetworking.h"
#import "TTUserModel.h"

@interface TTLoginViewModel ()

@property (strong, nonatomic) TTUserModel *userModel;
@property (strong, nonatomic) TTRACNetworking *networking;

- (void)getUserInfo;

@end

@implementation TTLoginViewModel

- (id)init {
    self = [super init];
    if (self) {
        // init & observe self.auth's value
        [RACObserve(self, auth) subscribeNext:^(TTAuth *x){
            TTLog(@"auth: %@ %@", x.access_token, x. access_secret);
            if (x.isValidated) {
                [self getUserInfo];
            }
        }];
        _networking = [TTRACNetworking new];
    }
    return self;
}

#pragma mark - Public

- (void)racLogin {
    // signal get request token then flatten to authenticate then flatten to get access
    [[[[_networking getRequestToken] flattenMap:^RACStream *(NSDictionary *x){
        return [_networking authenticate:self.account password:self.password auth:x];
    }] flattenMap:^RACStream *(NSDictionary *x) {
        return [_networking getAccessToken:x];
    }] subscribeNext:^(id x) {
        TTAuth *auth = [[TTAuth alloc] init];
        auth.access_token = x[@"token"];
        auth.access_secret = x[@"secret"];
        self.auth = auth;
        self.statusMessage = @"Login success";
    } error:^(NSError *error) {
        self.statusMessage = [NSString stringWithFormat:@"%@", error];
    }];
}

#pragma mark - Private

- (void)getUserInfo {
    // not finished
}



@end
