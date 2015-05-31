//
//  UIViewController+ApplyBackgroundImageOfNavBar.m
//  FundIncome
//
//  Created by jianwei on 15/5/31.
//  Copyright (c) 2015年 Jianwei. All rights reserved.
//

#import "UIViewController+ApplyBackgroundImageOfNavBar.h"

@implementation UIViewController (ApplyBackgroundImageOfNavBar)

- (void)applyImageBackgroundToTheNavigationBar:(NSString*)defaultImageName landscape:(NSString*)landscapeImageName titleColor:(UIColor*)titleColor
{
    //set title color
    NSDictionary * dict = @{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:23]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // These background images contain a small pattern which is displayed
    // in the lower right corner of the navigation bar.
    UIImage *backgroundImageForDefaultBarMetrics = [UIImage imageNamed:defaultImageName];
    UIImage *backgroundImageForLandscapePhoneBarMetrics = [UIImage imageNamed:landscapeImageName];
    
    // Both of the above images are smaller than the navigation bar's
    // size.  To enable the images to resize gracefully while keeping their
    // content pinned to the bottom right corner of the bar, the images are
    // converted into resizable images width edge insets extending from the
    // bottom up to the second row of pixels from the top, and from the
    // right over to the second column of pixels from the left.  This results
    // in the topmost and leftmost pixels being stretched when the images
    // are resized.  Not coincidentally, the pixels in these rows/columns
    // are empty.
    backgroundImageForDefaultBarMetrics = [backgroundImageForDefaultBarMetrics resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, backgroundImageForDefaultBarMetrics.size.height - 1, backgroundImageForDefaultBarMetrics.size.width - 1)];
    backgroundImageForLandscapePhoneBarMetrics = [backgroundImageForLandscapePhoneBarMetrics resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, backgroundImageForLandscapePhoneBarMetrics.size.height - 1, backgroundImageForLandscapePhoneBarMetrics.size.width - 1)];
    
    // You should use the appearance proxy to customize the appearance of
    // UIKit elements.  However changes made to an element's appearance
    // proxy do not effect any existing instances of that element currently
    // in the view hierarchy.  Normally this is not an issue because you
    // will likely be performing your appearance customizations in
    // -application:didFinishLaunchingWithOptions:.  However, this example
    // allows you to toggle between appearances at runtime which necessitates
    // applying appearance customizations directly to the navigation bar.
    /* id navigationBarAppearance = [UINavigationBar appearanceWhenContainedIn:[NavigationController class], nil]; */
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    // The bar metrics associated with a background image determine when it
    // is used.  The background image associated with the Default bar metrics
    // is used when a more suitable background image can not be found.
    [navigationBarAppearance setBackgroundImage:backgroundImageForDefaultBarMetrics forBarMetrics:UIBarMetricsDefault];
    // The background image associated with the LandscapePhone bar metrics
    // is used by the shorter variant of the navigation bar that is used on
    // iPhone when in landscape.
    [navigationBarAppearance setBackgroundImage:backgroundImageForLandscapePhoneBarMetrics forBarMetrics:UIBarMetricsCompact];
}

@end
