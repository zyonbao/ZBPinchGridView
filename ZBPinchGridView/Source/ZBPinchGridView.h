//
//  ZBPinchGridView.h
//  ZBPinchGridView
//
//  Created by sungrow on 2017/12/23.
//  Copyright © 2017年 picoluster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBPinchGridView;
@protocol ZBPinchGridViewDelegate<NSObject>

- (void)gridView:(ZBPinchGridView *)gridView didTapAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)gridView:(ZBPinchGridView *)gridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame;

@end

IB_DESIGNABLE
@interface ZBPinchGridView : UIView

@property (nonatomic, assign) NSInteger rowsCount; // 行数
@property (nonatomic, assign) NSInteger columnsCount; // 列数

@property (nonatomic, assign) IBInspectable CGFloat itemWidth;
@property (nonatomic, assign) IBInspectable CGFloat itemHeight;
@property (nonatomic, assign) IBInspectable NSInteger marginV; // 纵向间距
@property (nonatomic, assign) IBInspectable NSInteger marginH; // 横向间距

@property (nonatomic, assign) UIEdgeInsets contentInsets; // gridview 的 insets. insets 不随 scale 变化而增大 而是固定的 scale

@property (nonatomic, assign, readonly) CGFloat currentScale; // 当前缩放
@property (nonatomic, assign, readonly) CGRect innerBounds; // 当前内部视图所在的 bounds

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;

@property (nonatomic, weak) IBInspectable id<ZBPinchGridViewDelegate> delegate;

@end
