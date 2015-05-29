//
//  NSObject+JWLObjDicConvert.m
//  Dic2ObjAndObj2Dic
//
//  Created by mysticode on 15/4/28.
//  Copyright (c) 2015年 mysticode. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+JWLObjDicConvert.h"

@implementation NSObject (JWLObjDicConvert)
#pragma mark - util methods
/**
 *  移除字段名称前面的下划线
 *
 *  @param name 字段名称
 *
 *  @return 处理后的字段名称
 */
+(NSString*)removeUnderLine:(NSString*)name{
    if ([name hasPrefix:@"_"]) {
        return [name substringFromIndex:1];
    }
    return name;
}
/**
 *  获取字典对应的model类型
 *
 *  @param typeEncoding 字段类型编码
 *
 *  @return 字典对应的model类型
 */
+(Class)dictionaryClassFromTypeEncoding:(NSString *)typeEncoding{
    NSString *className = [typeEncoding substringWithRange:NSMakeRange(2, [typeEncoding length]-3)];
    //NSLog(@"typeEncoding:%@ 类名:%@",typeEncoding,className);
    return NSClassFromString(className);
}
/**
 *  获取数组元素对应的model类型
 *
 *  @param typeEncoding 字段类型编码
 *
 *  @return 数组元素对应的model类型
 */
+(Class)arrayItemClassStringWithTypeEncoding:(NSString *)typeEncoding{
    typeEncoding = [typeEncoding substringWithRange:NSMakeRange(2, [typeEncoding length]-3)];
    NSRange start = [typeEncoding rangeOfString:@"<"];
    NSRange end = [typeEncoding rangeOfString:@">"];
    NSRange r = NSMakeRange(start.location+1, end.location-start.location-1);
    NSString *className = [typeEncoding substringWithRange:r];
    //NSLog(@"typeEncoding:%@ 类名:%@",typeEncoding,className);
    return NSClassFromString(className);
}
/**
 *  判断字段是否需要特殊处理(是对象还是直接设置值)
 *
 *  @param pType 字段的类型编码
 *
 *  @return BOOL
 */
+(BOOL)needToHandle:(NSString *)pType{
    if (![pType hasPrefix:@"@"]) {
        return NO;
    }else if ([pType rangeOfString:@"NSString"].location != NSNotFound) {
        return NO;
    }else if ([pType rangeOfString:@"NSDictionary"].location != NSNotFound){
        return NO;
    }else if([pType rangeOfString:@"NSArray"].location != NSNotFound && [pType rangeOfString:@"<"].location == NSNotFound){
        return NO;
    }
    return YES;
}


+(instancetype)initWithDic:(NSDictionary*)dic{
    Class c = [self class];
    id obj = [[c alloc]init];
    unsigned int outCount;
    Ivar *vars = class_copyIvarList(c, &outCount);
    for(int i = 0; i < outCount; i++){
        NSString *pName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        pName = [self removeUnderLine:pName];
        id value = [dic valueForKey:pName];
        if (value!=nil) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSString *pType = [NSString stringWithUTF8String:ivar_getTypeEncoding(vars[i])];
                if ([pType rangeOfString:@"NSArray"].location == NSNotFound) {
                    Class subClass = [self dictionaryClassFromTypeEncoding:pType];
                    if (subClass == nil) {
                        NSLog(@"不存在名称为%@的类。",pType);
                        continue;
                    }
                    object_setIvar(obj, vars[i], [subClass initWithDic:value]);
                }else{
                    Class subClass = [self arrayItemClassStringWithTypeEncoding:pType];
                    if (subClass == nil) {
                        NSLog(@"不存在名称为%@的类。",pType);
                        continue;
                    }
                    NSArray *array = @[[subClass initWithDic:value]];
                    object_setIvar(obj, vars[i], array);
                }
            }else if([value isKindOfClass:[NSArray class]]){
                NSString *pType = [NSString stringWithUTF8String:ivar_getTypeEncoding(vars[i])];
                Class subClass = [self arrayItemClassStringWithTypeEncoding:pType];
                if (subClass == nil) {
                    NSLog(@"不存在名称为%@的类。",pType);
                    continue;
                }
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in value) {
                    [array addObject:[subClass initWithDic:dic]];
                }
                object_setIvar(obj, vars[i], array);
            }else{
                object_setIvar (obj, vars[i], value);
            }
        }
    }
    free(vars);
    return obj;
}

-(NSDictionary*)toDictionary{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    Class c = [self class];
    unsigned int outCount;
    Ivar *vars = class_copyIvarList(c, &outCount);
    for (int i=0; i < outCount; i++) {
        NSString *pName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        pName = [[self class] removeUnderLine:pName];
        id value = object_getIvar (self,vars[i]);
        NSString *pType = [NSString stringWithUTF8String:ivar_getTypeEncoding(vars[i])];
        if (![[self class] needToHandle:pType]) {
            [resultDic setValue:value forKey:pName];
        }else{
            if ([pType rangeOfString:@"NSArray"].location != NSNotFound) {
                NSMutableArray *array = [NSMutableArray array];
                for(id o in value){
                    NSDictionary *d = [o toDictionary];
                    [array addObject:d];
                }
                [resultDic setValue:array forKey:pName];
            }else{
                [resultDic setValue:[value toDictionary] forKey:pName];
            }
        }
        
    }
    return resultDic;
}
@end
