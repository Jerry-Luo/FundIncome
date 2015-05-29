//
//  NSObject+JWLObjDicConvert.h
//  Dic2ObjAndObj2Dic
//
//  Created by mysticode on 15/4/28.
//  Copyright (c) 2015年 mysticode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JWLObjDicConvert)
+(instancetype)initWithDic:(NSDictionary*)dic;
-(NSDictionary*)toDictionary;
@end
