//
//  FundModel.h
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FundDetailModel.h"
#import <UIKit/UIKit.h>
#define fundsKey @"funds"
@interface Fund : NSObject
typedef void(^FetchFundsSuccess)(NSArray *array);
typedef void(^FetchFundsFailed)();
typedef void(^Finish)();
/**
 *  同步用户基金
 *
 *  @param funds 用户基金
 */
+(void)syncUserFunds:(NSArray*)funds;

/**
 *  获取用户已存的基金
 *
 *  @return 基金数组
 */
+(NSArray*)userFunds;

/**
 *  获取基金信息并计算收益
 *
 *  @param updateUI 根据获取的基金信息更新UI的block
 */
+(void)requestFundsFromWebservice:(FetchFundsSuccess)success failed:(FetchFundsFailed)failed finish:(Finish)finish;

/**
 *  获取用户投入的基金总金额
 *
 *  @return 用户投入的总金额
 */
+(double)fundAmount;

/**
 *  估算用户的总资产
 *
 *  @param array 网络获取的用户持有基金详情
 *
 *  @return 估算出的总资产
 */
+(double)totalAsset:(NSArray*)array;

/**
 *  截至昨日的实际总资产
 *
 *  @param array 网络获取的用户持有基金详情
 *
 *  @return 计算出的截至昨日的实际资产
 */
+(double)actualAsset:(NSArray*)array;

/**
 *  计算某个基金的收益
 *
 *  @param fundDetailModel 基金详情
 *
 *  @return 指定基金的收益
 */
+(double)fundIncome:(FundDetailModel*)fundDetailModel;

/**
 *  <#Description#>
 *
 *  @param benifit <#benifit description#>
 *
 *  @return <#return value description#>
 */
+(UIColor*)colorWithBenifit:(double)benifit;
@end
