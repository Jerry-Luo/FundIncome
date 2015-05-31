//
//  JWAddFundTableViewCell.h
//  FundIncome
//
//  Created by jianwei on 15/5/29.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWAddFundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *fundNOTextview;
@property (weak, nonatomic) IBOutlet UITextField *amountTextview;
@property (weak, nonatomic) IBOutlet UITextField *numTextview;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
