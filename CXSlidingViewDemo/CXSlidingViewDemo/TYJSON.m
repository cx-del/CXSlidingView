//
//  TYJSON.m
//  JSON 解析
//
//  Created by DCX on 16/4/11.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "TYJSON.h"

@implementation NSString(CXJson)

- (id)JSONObject {
    return [self JSONObjectWithError:nil];
}

- (id)JSONObjectWithError:(NSError **)error {
    return [[self UTF8Data] JSONObjectWithError:error];
}

- (NSData *)UTF8Data {
    if (self.length > 0) {
        return [self dataUsingEncoding:NSUTF8StringEncoding];
     } 
    return nil;
}

@end

@implementation NSData(CXJson)

- (id)JSONObject {
    return [self JSONObjectWithError:nil];
}

- (id)JSONObjectWithError:(NSError **)error{
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:error];
}

- (NSString *)UTF8String {
    if (self.length > 0) {
        return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end

@implementation NSDictionary(CXJson)

- (NSData *)JSONData {
    return [self JSONDataWithError:nil];
}

- (NSData *)JSONDataWithError:(NSError **)error {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];
    }
    return nil;
}

- (NSString *)JSONString {
    return [[self JSONData] UTF8String];
}

- (NSString *)JSONStringWithError:(NSError **)error {
    return [[self JSONDataWithError:error] UTF8String];
}
@end

@implementation NSArray(CXJson)

- (NSData *)JSONData {
    return [self JSONDataWithError:nil];
}
- (NSData *)JSONDataWithError:(NSError **)error {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:error];
    }
    return nil;
}

- (NSString *)JSONString {
    return [[self JSONData] UTF8String];
}
- (NSString *)JSONStringWithError:(NSError **)error {
    return [[self JSONDataWithError:error] UTF8String];
}

@end