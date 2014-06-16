//
//  TTRACNetworking.m
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "TTRACNetworking.h"
#import <AFNetworking.h>
#import "URLParser.h"
#import "KOAuth.h"

typedef NS_ENUM(NSUInteger, TTRACNetworkingError){
    TTRACNetworkingErrorNORequestToken = 0,
    TTRACNetworkingErrorAuthenticateFailure,
    TTRACNetworkingErrorNoAccessToken
};

static NSString *const TTRACNetworkingDomain = @"TTRACNetworking";


@implementation TTRACNetworking

#pragma mark - Public

- (RACSignal *)getRequestToken {
    NSError *getRequestTokenError = [NSError errorWithDomain:TTRACNetworkingDomain code:TTRACNetworkingErrorNORequestToken userInfo:nil];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@/token", API_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *responseURLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            URLParser *parser = [[URLParser alloc] initWithURLString:responseURLString];
            // your response object
            NSDictionary *auth = @{};
            if ([[parser valueForKey:@"confirmed"] isEqualToString:@"true"]) {
                // send next to signal
                [subscriber sendNext:auth];
                [subscriber sendCompleted];
            } else {
                //send error
                [subscriber sendError:getRequestTokenError];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [subscriber sendError:error];
        }];
        [operation start];
        return nil;
    }];
}

- (RACSignal *)authenticate:(NSString *)account password:(NSString *)password auth:(NSDictionary *)auth {
    NSError *authenticateError = [NSError errorWithDomain:TTRACNetworkingDomain code:TTRACNetworkingErrorAuthenticateFailure userInfo:nil];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *urlString = [NSString stringWithFormat:@"%@/authenticate", API_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        // NSDictionary *params = @{@"oauth_token": auth[@"token"], @"account": account, @"password": password};
        NSMutableURLRequest *reuqset = [[NSMutableURLRequest alloc] initWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reuqset];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *responseURLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            URLParser *parser = [[URLParser alloc] initWithURLString:responseURLString];
            NSString *confirmed = [parser valueForKey:@""];
            if ([confirmed isEqualToString:@"true"]) {
                NSDictionary *dict = @{};
                [subscriber sendNext:dict];
                [subscriber sendCompleted];
            }else {
                [subscriber sendError:authenticateError];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [subscriber sendError:error];
        }];
        
        [operation start];
        
        return nil;
    }];
    
}

- (RACSignal *)getAccessToken:(NSDictionary *)auth {
    NSError *getAccessError = [NSError errorWithDomain:TTRACNetworkingDomain code:TTRACNetworkingErrorNoAccessToken userInfo:nil];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *urlString = [NSString stringWithFormat:@"%@/access", API_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *reuqest = [[NSMutableURLRequest alloc] initWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reuqest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *responseURLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            URLParser *parser = [[URLParser alloc] initWithURLString:responseURLString];
            
            if ([parser valueForKey:@"token"] && [parser valueForKey:@"secret"]) {
                [subscriber sendNext:@{}];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:getAccessError];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [subscriber sendError:error];
        }];
        
        [operation start];
        return nil;
    }];
}

@end
