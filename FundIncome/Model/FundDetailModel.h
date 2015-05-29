//
//  FundDetailModel.h
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FundModel.h"
@protocol FundDetailModel<NSObject>
@end
@interface FundDetailModel : NSObject
@property (strong, nonatomic) NSString *fundcode;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *jzrq;
@property (strong, nonatomic) NSString *dwjz;
@property (strong, nonatomic) NSString *ljjz;
@property (strong, nonatomic) NSString *rzzl;
@property (strong, nonatomic) NSString *gsz;
@property (strong, nonatomic) NSString *gszzl;
@property (strong, nonatomic) NSString *syl;
@property (strong, nonatomic) NSString *sgzt;
@property (strong, nonatomic) NSString *shzt;
@property (strong, nonatomic) NSString *jjlx;
@property (strong, nonatomic) NSString *htpj;
@property (strong, nonatomic) NSString *gztime;
@property (strong, nonatomic) NSString *isgz;
@property (strong, nonatomic) NSString *isbuy;
@property (strong, nonatomic) NSString *nkfr;
@property (strong, nonatomic) FundModel *fundModel;
@end
