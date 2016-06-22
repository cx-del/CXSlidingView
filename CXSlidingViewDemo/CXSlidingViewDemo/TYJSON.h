//
//  TYJSON.h
//  JSON 解析
//
//  Created by DCX on 16/4/11.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(CXJson)

- (id)JSONObject;
- (id)JSONObjectWithError:(NSError **)error;
 
@end

@interface NSData(CXJson)

- (id)JSONObject;
- (id)JSONObjectWithError:(NSError **)error;

- (NSString *)UTF8String;

@end


@interface NSDictionary(CXJson)

- (NSData *)JSONData;
- (NSData *)JSONDataWithError:(NSError **)error;

- (NSString *)JSONString;
- (NSString *)JSONStringWithError:(NSError **)error;

@end


@interface NSArray (CXJson)

- (NSData *)JSONData;
- (NSData *)JSONDataWithError:(NSError **)error;

- (NSString *)JSONString;
- (NSString *)JSONStringWithError:(NSError **)error;

@end
