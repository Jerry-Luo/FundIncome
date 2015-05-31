//
//  UIViewController+ApplyBackgroundImageOfNavBar.h
//  FundIncome
//
//  Created by jianwei on 15/5/31.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ApplyBackgroundImageOfNavBar)
- (void)applyImageBackgroundToTheNavigationBar:(NSString*)defaultImageName landscape:(NSString*)landscapeImageName titleColor:(UIColor*)titleColor;
@end
