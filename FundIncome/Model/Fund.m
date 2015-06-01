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
#import "FundWebServiceResp.h"
@implementation Fund

+(UIColor*)colorWithBenifit:(double)benifit{
    if (benifit>0) {
        return [UIColor redColor];
    }else{
        return [UIColor colorWithRed:49/255.0 green:144/255.0 blue:67/255.0 alpha:1];
    }
}

+(double)fundIncome:(FundDetailModel*)fundDetailModel{
    double invest = [[fundDetailModel.fundModel valueForKey:@"amount"] doubleValue];
    double num = [[fundDetailModel.fundModel valueForKey:@"num"] doubleValue];
    double gsz = [fundDetailModel.gsz doubleValue];
    return num * gsz - invest;
}

+(double)totalAsset:(NSArray*)array{
    double sum = 0;
    for (FundDetailModel *m in array) {
        double num = [[m.fundModel valueForKey:@"num"] doubleValue];
        double gsz = [m.gsz doubleValue];
        sum += (num * gsz);
    }
    return sum;
}

+(double)actualAsset:(NSArray*)array{
    double sum = 0;
    for (FundDetailModel *m in array) {
        double num = [[m.fundModel valueForKey:@"num"] doubleValue];
        double gsz = [m.dwjz doubleValue];
        sum += (num * gsz);
    }
    return sum;
}

+(double)fundAmount{
    NSArray *arr = [self userFunds];
    double sum = 0;
    for (NSDictionary *m in arr) {
        sum += [[m valueForKey:@"amount"] doubleValue];
    }
    return sum;
}

+(void)syncUserFunds:(NSArray*)funds
{
//    NSMutableArray *array = [NSMutableArray array];
//    for (FundModel *fund in funds) {
//        NSDictionary *dic = @{@"fundNO":fund.fundNO,@"amount":fund.amount,@"num":fund.num};
//        [array addObject:dic];
//    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:funds forKey:fundsKey];
    [userDefaults synchronize];
}

+(NSArray*)userFunds
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:fundsKey];
//    NSMutableArray *funds = [NSMutableArray array];
//    for (NSDictionary *dic in array) {
//        FundModel *m = [[FundModel alloc]init];
//        m.fundNO = [dic valueForKey:@"fundNO"];
//        m.amount = [dic valueForKey:@"amount"];
//        m.num = [dic valueForKey:@"num"];
//        [funds addObject:m];
//    }
//    return funds;
    return array;
}

+(void)requestFundsFromWebservice:(FetchFundsSuccess)success failed:(FetchFundsFailed)failure finish:(Finish)finish
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *str = [self fc];
    if ([str length]) {
        NSDictionary *param = @{@"pstart":@"0",@"psize":@"1000",@"fc":str,@"t":@"kf",@"dt":[NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970]};
        
        [manager GET:@"http://fundex2.eastmoney.com/FundWebServices/MyFavorInformation.aspx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"JSON: %@", resp);
            NSDictionary *dic = @{@"funds":resp};
            FundWebServiceResp *r = [FundWebServiceResp initWithDic:dic];
            [self addFundModel:r.funds];
            success(r.funds);
            finish();
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure();
            finish();
        }];

    }else{
        finish();
    }
}

+(void)addFundModel:(NSArray*)array{
    NSArray *arr = [self userFunds];
    for (NSDictionary *m in arr) {
        for (FundDetailModel *dm in array) {
            if ([dm.fundcode isEqualToString:[m valueForKey:@"fundNO"]]) {
                dm.fundModel = m;
            }
        }
    }
}

+(NSString *)fc{
    NSArray *arr = [self userFunds];
    NSMutableString *fc = [NSMutableString string];
    for (NSDictionary *m in arr) {
        [fc appendString:[m valueForKey:@"fundNO"]];
        [fc appendString:@","];
    }
    return [fc length]?[fc substringToIndex:[fc length]-1]:nil;
}

@end
