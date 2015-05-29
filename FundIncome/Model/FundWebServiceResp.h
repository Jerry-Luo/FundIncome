//
//  FundWebServiceResp.h
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FundDetailModel.h"
@interface FundWebServiceResp : NSObject
@property (strong, nonatomic) NSArray<FundDetailModel> *funds;
@end
