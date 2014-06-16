//
//  URLParser.h
//  MantleSample
//
//  Created by Matt Chang on 2014/5/29.
//  Copyright (c) 2014年 Accuvally Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject

@property (strong, nonatomic) NSArray *variables;

- (id)initWithURLString:(NSString *)urlString;
- (NSString *)valueForKey:(NSString *)key;

@end
