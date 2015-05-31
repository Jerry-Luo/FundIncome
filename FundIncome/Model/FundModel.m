//
//  FundModel.m
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import "FundModel.h"

@implementation FundModel
- (id)copyWithZone:(NSZone *)zone{
    FundModel *copy = [[[self class]allocWithZone:zone]init];
    copy.fundNO = self.fundNO;
    copy.amount = self.amount;
    copy.num = self.num;
    return copy;
}
@end
