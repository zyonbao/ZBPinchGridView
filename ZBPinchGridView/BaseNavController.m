//
//  BaseNavController.m
//  ZBPinchGridView
//
//  Created by sungrow on 2017/12/27.
//  Copyright © 2017年 picoluster. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations {
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
#endif
    if ([[self.viewControllers lastObject] isKindOfClass:[UIViewController class]]) {
        return [[self.viewControllers lastObject] supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if ([[self.viewControllers lastObject] isKindOfClass:[UIViewController class]]) {
        return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    }
    
    return UIInterfaceOrientationPortrait;
}
 */
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.visibleViewController supportedInterfaceOrientations];
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
//}


@end
