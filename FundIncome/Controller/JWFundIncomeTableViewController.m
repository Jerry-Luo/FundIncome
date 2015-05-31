//
//  JWFundIncomeTableViewController.m
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import "JWFundIncomeTableViewController.h"
#import "Fund.h"
#import "JWFundIncomeTableViewCell.h"
#import "FundDetailModel.h"
#import "UIViewController+ApplyBackgroundImageOfNavBar.h"

@interface JWFundIncomeTableViewController ()
@property(strong, nonatomic) NSArray *fundDetails;
@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) BOOL viewJustAppear;
@property (weak, nonatomic) IBOutlet UILabel *totalInLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitLabel;
@end

@implementation JWFundIncomeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewJustAppear = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"PULL_UPDATE", @"下拉刷新")];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [self applyImageBackgroundToTheNavigationBar:@"NavigationBarDefault" landscape:@"NavigationBarLandscapePhone" titleColor:[UIColor whiteColor]];
    [self refreshData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}

-(void)refreshData{
    NSLog(@"refresh data");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Fund requestFundsFromWebservice:^(NSArray *array) {
            self.fundDetails = array;
            dispatch_async(dispatch_get_main_queue(), ^{
                double allIn = [Fund fundAmount];
                double benifit = [Fund totalAsset:self.fundDetails]-allIn;
                self.totalInLabel.text = [NSString stringWithFormat:@"%.2f",allIn];
                self.benefitLabel.text = [NSString stringWithFormat:@"%.2f",benifit];
                if (benifit>0) {
                    self.benefitLabel.textColor = [UIColor redColor];
                }else{
                    self.benefitLabel.textColor = [UIColor greenColor];
                }
                [self.tableView reloadData];
            });
        } failed:^{
            NSLog(@"refresh data failed");
            if (self.viewJustAppear) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_VIEW_TITLE", @"提示框标题") message:NSLocalizedString(@"request_Funds_FromWebservice_failed",@"请求基金详情失败") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TEXT", @"取消按钮文字") otherButtonTitles:nil];
                    [alert show];
                });
                self.viewJustAppear = NO;
            }
        } finish:^{
            if ([self.refreshControl isRefreshing]) {
                NSLog(@"end refreshing...");
                [self.refreshControl endRefreshing];
            }
        }];
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fundDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWFundIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWFundIncomeTableViewCell" forIndexPath:indexPath];
    FundDetailModel *fund = [self.fundDetails objectAtIndex:indexPath.row];
    cell.fundNameLabel.text = [NSString stringWithFormat:@"%@(%@)",fund.name,fund.fundcode];
    double income = [Fund fundIncome:fund];
    cell.incomeLabel.text = [NSString stringWithFormat:@"%.2f",income];
    if (income>0) {
        cell.incomeLabel.textColor = [UIColor redColor];
        cell.mood.image = [UIImage imageNamed:@"delight"];
    }else{
        cell.incomeLabel.textColor = [UIColor greenColor];
        cell.mood.image = [UIImage imageNamed:@"sad"];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
