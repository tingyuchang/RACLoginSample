//
//  NSString+Extension.h
//  LoginSample
//
//  Created by Matt Chang on 2014/6/11.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)validateEmail:(NSString *)candidate;

@end
