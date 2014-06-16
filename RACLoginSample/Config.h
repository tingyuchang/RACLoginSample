//
//  Config.h
//  RACLoginSample
//
//  Created by Matt Chang on 2014/6/16.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//
#pragma mark - Web API

#define API_URL @"YOUR_API_URL"
#define OAUTH_CONSUMER_KEY @"YOUR_CONSUMER_KEY"
#define OAUTH_CONSUMER_SECRET @"YOUR_CONSUMER_SECRET"
#define FACEBOOK_APP_ID @"YOUR_FACEBOOK_ID"

#pragma mark - DB

#define USER_SAVE_PATH @"user"


#pragma mark - Fuction

// TTLog always displays output regardless of the DEBUG setting
#define TTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// TTLog always displays output regardless of the DEBUG setting
#define TTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#pragma mark - UI

// using hex text: ColorFromHex(0xecf0f1) = rgb(236, 240, 241)
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorFromRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1];
