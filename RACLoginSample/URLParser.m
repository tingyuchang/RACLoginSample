//
//  URLParser.m
//  MantleSample
//
//  Created by Matt Chang on 2014/5/29.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import "URLParser.h"

@implementation URLParser
/**
 *  init URLParser
 *
 *  @param urlString responseObject
 *
 *  @return self
 */
- (id)initWithURLString:(NSString *)urlString{
    self = [super init];
    if (self) {
        NSString *string = urlString;
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
        NSString *tempString;
        NSMutableArray *vars = [NSMutableArray new];
        while ([scanner scanUpToString:@"&" intoString:&tempString]) {
            [vars addObject:[tempString copy]];
        }
        self.variables = vars;
    }
    return self;
}

- (NSString *)valueForKey:(NSString *)key{
    for (NSString *var in self.variables) {
        if ([var length] > [key length] + 1 && [[var substringWithRange:NSMakeRange(0, [key length] + 1)] isEqualToString:[key stringByAppendingString:@"="]])
        {
            NSString *varValue = [var substringFromIndex:[key length] + 1];
            return varValue;
        }
    }
    return nil;
}


@end
