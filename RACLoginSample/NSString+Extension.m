//
//  NSString+Extension.m
//  LoginSample
//
//  Created by Matt Chang on 2014/6/11.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isEmpty:(NSString *)string {
    return (string == nil || string.length == 0);
}

+ (BOOL)validateEmail:(NSString *) candidate {
    NSString *regExPattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
    
    return [emailTest evaluateWithObject:candidate];
}


@end
