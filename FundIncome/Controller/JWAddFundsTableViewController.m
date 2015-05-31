//
//  JWAddFundsTableViewController.m
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import "JWAddFundsTableViewController.h"
#import "JWAddFundTableViewCell.h"
#import "JWFundTableViewCell.h"
#import "FundModel.h"
#import "Fund.h"
#import "UIViewController+ApplyBackgroundImageOfNavBar.h"

@interface JWAddFundsTableViewController ()
@property (strong, nonatomic) NSMutableArray *fundModels;
@property (strong, nonatomic) NSString *fundNO;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *num;
@end

@implementation JWAddFundsTableViewController
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.fundModels = [NSMutableArray arrayWithArray:[Fund userFunds]];
}
-(void)viewWillAppear:(BOOL)animated{
    [self applyImageBackgroundToTheNavigationBar:@"NavigationBarDefault" landscape:@"NavigationBarLandscapePhone" titleColor:[UIColor whiteColor]];
}
#pragma mark -Table view delegate
- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [self.fundModels count];
        case 0:
            return 1;
        default:
            return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"  %@",NSLocalizedString(@"ADD_FUND_VIEW_HEADER", @"添加基金模块标题")];
            break;
        case 1:
            return [NSString stringWithFormat:@"  %@",NSLocalizedString(@"FUND_MODELS_TABLE_VIEW_HEADER", @"已经持有的基金列表标题")];
            break;
        default:
            return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            JWAddFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWAddFundTableViewCell" forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(addFundModel) forControlEvents:UIControlEventTouchUpInside];
            [cell.fundNOTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.amountTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.numTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            
            return cell;
        }
            break;
        case 1:
        {
            JWFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWFundTableViewCell" forIndexPath:indexPath];
            FundModel *m = [self.fundModels objectAtIndex:indexPath.row];
            cell.fundNOLabel.text = [NSString stringWithFormat:@"代号:%@",m.fundNO];
            cell.amountLabel.text = [NSString stringWithFormat:@"投入:%@",m.amount];
            cell.numLabel.text = [NSString stringWithFormat:@"份额:%@",m.num];
            return cell;
        }
            break;
        default:
            return nil;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.fundModels removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
#pragma mark - scroll view delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - actions
-(void)addFundModel{
    FundModel *model = [[FundModel alloc]init];
    model.fundNO = self.fundNO;
    model.amount = self.amount;
    model.num = self.num;
    
    if ([model.fundNO length]==0 || [model.amount length]==0 || [model.num length]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_VIEW_TITLE",nil) message:NSLocalizedString(@"ALERT_MISS_PARAMETERS",@"提示：所有选项必填") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TEXT",nil)  otherButtonTitles: nil];
        [alert show];
    }else if ([self fundAreadyExsit:model]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_VIEW_TITLE",nil) message:NSLocalizedString(@"ALERT_FUND_AREAD_ADDED",@"提示：已经添加过该基金") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TEXT",nil)  otherButtonTitles: nil];
        [alert show];
        return;
    }else{
        [self.fundModels insertObject:model atIndex:0];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    
    
}
-(BOOL)fundAreadyExsit:(FundModel*)model{
    for (FundModel *m in self.fundModels) {
        if ([m.fundNO isEqualToString:model.fundNO]) {
            return true;
        }
    }
    return false;
}

- (IBAction)addFunds:(id)sender {
    [Fund syncUserFunds:self.fundModels];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)valueChanged:(UITextView*)textView{
    
    switch (textView.tag) {
        case 1:
            self.fundNO = textView.text;
            break;
        case 2:
            self.amount = textView.text;
            break;
        case 3:
            self.num = textView.text;
            break;
            
        default:
            break;
    }
    
}

#pragma mark - override getter
-(NSMutableArray *)fundModels{
    if (!_fundModels) {
        _fundModels = [NSMutableArray array];
    }
    return _fundModels;
}
@end

