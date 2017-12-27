//
//  ViewController.m
//  ZBPinchGridView
//
//  Created by sungrow on 2017/12/23.
//  Copyright © 2017年 picoluster. All rights reserved.
//

#import "ViewController.h"
#import "ZBPinchGridView.h"

@interface ViewController ()<ZBPinchGridViewDelegate>

@property (weak, nonatomic) IBOutlet ZBPinchGridView *gridView;

@end

@implementation ViewController {
    NSMutableDictionary *_positions;
}

- (void)loadView {
    [super loadView];
    self.gridView.delegate = self;
    _positions = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (void)gridView:(ZBPinchGridView *)gridView didTapAtColumn:(NSInteger)column row:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row];
    if (_positions[indexPath]) {
        [_positions removeObjectForKey:indexPath];
    } else {
        [_positions setObject:@(1) forKey:indexPath];
    }
    [gridView setNeedsDisplay];
}

- (void)gridView:(ZBPinchGridView *)gridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame {
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    if (_positions[[NSIndexPath indexPathForItem:column inSection:row]]) {
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    [path fill];
    [path stroke];
}

- (void)shouldLandscape {
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}



@end
