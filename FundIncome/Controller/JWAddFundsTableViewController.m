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
#import "Fund.h"
#import "UIViewController+ApplyBackgroundImageOfNavBar.h"
/**
 *  测试source tree
 */
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
    [self applyImageBackgroundToTheNavigationBar:@"NavigationBarDefault" landscape:@"NavigationBarLandscapePhone" titleColor:[UIColor whiteColor]];
}
#pragma -Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.fundModels objectAtIndex:indexPath.row];
    self.fundNO = [dic valueForKey:@"fundNO"];
    self.amount = [dic valueForKey:@"amount"];
    self.num = [dic valueForKey:@"num"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"%@",NSLocalizedString(@"ADD_FUND_VIEW_HEADER", @"添加基金模块标题")];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@",NSLocalizedString(@"FUND_MODELS_TABLE_VIEW_HEADER", @"已经持有的基金列表标题")];
            break;
        default:
            return nil;
    }
}
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            JWAddFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWAddFundTableViewCell" forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(addFundModel) forControlEvents:UIControlEventTouchUpInside];
            [cell.fundNOTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.amountTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.numTextview addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
            cell.fundNOTextview.text = self.fundNO;
            cell.amountTextview.text = self.amount;
            cell.numTextview.text = self.num;
            return cell;
        }
            break;
        case 1:
        {
            JWFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JWFundTableViewCell" forIndexPath:indexPath];
            NSDictionary *m = [self.fundModels objectAtIndex:indexPath.row];
            cell.fundNOLabel.text = [NSString stringWithFormat:@"代号:%@",[m valueForKey: @"fundNO"]];
            cell.amountLabel.text = [NSString stringWithFormat:@"投入:%@",[m valueForKey: @"amount"]];
            cell.numLabel.text = [NSString stringWithFormat:@"份额:%@",[m valueForKey: @"num"]];
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
    if ([self.fundNO length]==0 || [self.amount length]==0 || [self.num length]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_VIEW_TITLE",nil) message:NSLocalizedString(@"ALERT_MISS_PARAMETERS",@"提示：所有选项必填") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TEXT",nil)  otherButtonTitles: nil];
        [alert show];
    }else if ([self fundAreadyExsit:self.fundNO]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ALERT_VIEW_TITLE",nil) message:NSLocalizedString(@"ALERT_FUND_AREAD_ADDED",@"提示：已经添加过该基金") delegate:nil cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TEXT",nil)  otherButtonTitles: nil];
//        [alert show];
        NSDictionary *dic = [self dicFromFunds:self.fundNO];
        NSInteger index = [self.fundModels indexOfObject:dic];
        NSDictionary *newDic = @{@"fundNO":self.fundNO, @"amount":self.amount, @"num":self.num};
        [self.fundModels replaceObjectAtIndex:index withObject:newDic];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }else{
        [self.fundModels insertObject:@{@"fundNO":self.fundNO,@"amount":self.amount,@"num":self.num} atIndex:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
-(BOOL)fundAreadyExsit:(NSString*)fundNO{
    for (NSDictionary *m in self.fundModels) {
        if ([[m valueForKey:@"fundNO"] isEqualToString:fundNO]) {
            return true;
        }
    }
    return false;
}
-(NSDictionary*)dicFromFunds:(NSString*)fundNO{
    for (NSDictionary *d in self.fundModels) {
        if ([fundNO isEqualToString:[d valueForKey:@"fundNO"]]) {
            return d;
        }
    }
    return nil;
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
@end

