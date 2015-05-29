//
//  FundModel.m
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//
#import "Fund.h"
#import "FundDetailModel.h"
#import "NSObject+JWLObjDicConvert.h"
#import "AFNetworking.h"
#import "FundModel.h"
#import "FundWebServiceResp.h"
@implementation Fund

+(double)fundIncome:(FundDetailModel*)fundDetailModel{
    double invest = [fundDetailModel.fundModel.amount doubleValue];
    double num = [fundDetailModel.fundModel.num doubleValue];
    double gsz = [fundDetailModel.gsz doubleValue];
    return num * gsz - invest;
}

+(double)totalAsset:(NSArray*)array{
    double sum = 0;
    for (FundDetailModel *m in array) {
        double num = [m.fundModel.num doubleValue];
        double gsz = [m.gsz doubleValue];
        sum += (num * gsz);
    }
    return sum;
}

+(double)fundAmount{
    NSArray *arr = [self userFunds];
    double sum = 0;
    for (FundModel *m in arr) {
        sum += [m.amount doubleValue];
    }
    return sum;
}

+(void)syncUserFunds:(NSArray*)funds
{
    NSMutableArray *array = [NSMutableArray array];
    for (FundModel *fund in funds) {
        NSDictionary *dic = @{@"fundNO":fund.fundNO,@"amount":fund.amount,@"num":fund.num};
        [array addObject:dic];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:fundsKey];
    [userDefaults synchronize];
}

+(NSArray*)userFunds
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:fundsKey];
    NSMutableArray *funds = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        FundModel *m = [[FundModel alloc]init];
        m.fundNO = [dic valueForKey:@"fundNO"];
        m.amount = [dic valueForKey:@"amount"];
        m.num = [dic valueForKey:@"num"];
        [funds addObject:m];
    }
    return funds;
}

+(void)requestFundsFromWebservice:(FetchFundsSuccess)success failed:(FetchFundsFailed)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{@"pstart":@"0",@"psize":@"1000",@"fc":[self fc],@"t":@"kf",@"dt":[NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970]};
    
    [manager GET:@"http://fundex2.eastmoney.com/FundWebServices/MyFavorInformation.aspx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"JSON: %@", resp);
        NSDictionary *dic = @{@"funds":resp};
        FundWebServiceResp *r = [FundWebServiceResp initWithDic:dic];
        [self addFundModel:r.funds];
        success(r.funds);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure();
    }];
}

+(void)addFundModel:(NSArray*)array{
    NSArray *arr = [self userFunds];
    for (FundModel *m in arr) {
        for (FundDetailModel *dm in array) {
            if ([dm.fundcode isEqualToString:m.fundNO]) {
                dm.fundModel = m;
            }
        }
    }
}

+(NSString *)fc{
    NSArray *arr = [self userFunds];
    NSMutableString *fc = [NSMutableString string];
    for (FundModel *m in arr) {
        [fc appendString:m.fundNO];
        [fc appendString:@","];
    }
    return [fc substringToIndex:[fc length]-1];
}

@end
