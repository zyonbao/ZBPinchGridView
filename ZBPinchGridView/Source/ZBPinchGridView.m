//
//  ZBPinchGridView.m
//  ZBPinchGridView
//
//  Created by sungrow on 2017/12/23.
//  Copyright © 2017年 picoluster. All rights reserved.
//

#import "ZBPinchGridView.h"

@interface ZBPinchGridView()<UIGestureRecognizerDelegate, CALayerDelegate>

@property (nonatomic, assign, readwrite) CGFloat currentScale; // 当前缩放
@property (nonatomic, assign, readwrite) CGRect innerBounds; // 当前内部视图所在的 bounds

@property (nonatomic, assign) CGRect innerBoundsBeforeGesture;
@property (nonatomic, assign) CGFloat scaleBoforePinch;

@end

@implementation ZBPinchGridView {
    UIPanGestureRecognizer *_panRecognizer;
    UIPinchGestureRecognizer *_pinchRecognizer;
    UITapGestureRecognizer *_tapRecognizer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialConfig];
        [self initialRecognizers];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialConfig];
    [self initialRecognizers];
}

- (void)initialConfig {
    _rowsCount = 24;
    _columnsCount = 50;
    _itemWidth = 120;
    _itemHeight = 60;
    _marginH = 4;
    _marginV = 4;
    _contentInsets = UIEdgeInsetsMake(20, 20, 2, 2);
    _innerBounds = CGRectZero;
    
    _currentScale = 1.0f;
    _minScale = 0.1f;
    _maxScale = 1.0f;
}

- (CGSize)contentSize {
    return CGSizeMake((_columnsCount * (_itemWidth + _marginH)),
                      (_rowsCount * (_itemHeight + _marginV)));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _innerBounds = (CGRect){-_contentInsets.left, -_contentInsets.top,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)};
}

- (void)initialRecognizers {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecogAction:)];
    }
    if (!_pinchRecognizer) {
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecogAction:)];
    }
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecogAction:)];
    }
    [self addGestureRecognizer:_panRecognizer];
    [self addGestureRecognizer:_pinchRecognizer];
    [self addGestureRecognizer:_tapRecognizer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 这里做一下说明, 坐标系以当前 View 的尺寸为准.
// 即: content 的坐标也要转换成当前 View 的尺寸单位, 如果 content 进行了缩放, 则需要再缩放到 View 的坐标内, 再计算当前 View 的 innerBounds.
- (void)drawRect:(CGRect)rect {
    CGContextRef context =  UIGraphicsGetCurrentContext();
    // Drawing code
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    [self drawGridViews:context];
    [self drawHIndexIndicator:context];
    [self drawVIndexIndicator:context];

}

- (void)drawHIndexIndicator:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:CGFLOAT_MIN alpha:.6].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width,20));
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:11],
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    for (int j = 0; j< _columnsCount; j++) {
        NSString *text = [@(j) stringValue];
        CGFloat currentX = (j*(_itemWidth+_marginH)-_innerBounds.origin.x) * _currentScale;
        [text drawAtPoint:CGPointMake(currentX, 0) withAttributes:attrs];
    }
    
    CGContextRestoreGState(context);
}

- (void)drawVIndexIndicator:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:CGFLOAT_MIN alpha:.6].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 20, self.bounds.size.height));
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:11],
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    for (int i = 0; i< _rowsCount; i++) {
        NSString *text = [@(i) stringValue];
        CGFloat currentY = (i*(_itemHeight+_marginV)-_innerBounds.origin.y) * _currentScale;
        [text drawAtPoint:CGPointMake(0, currentY) withAttributes:attrs];
    }
    CGContextRestoreGState(context);
}

- (void)drawGridViews:(CGContextRef)context {
    for (int i = 0; i < _rowsCount; i++) {
        for (int j = 0; j< _columnsCount; j++) {
            CGRect currentRect = CGRectMake(j*(_itemWidth+_marginH),
                                            i*(_itemHeight+_marginV),
                                            _itemWidth,
                                            _itemHeight);
            
            if (CGRectIntersectsRect(currentRect, _innerBounds)) {
                // 转换为当前用户坐标下的坐标
                CGRect rectInBounds = CGRectMake(
                                                 (CGRectGetMinX(currentRect)-_innerBounds.origin.x) * _currentScale,
                                                 (CGRectGetMinY(currentRect)-_innerBounds.origin.y) * _currentScale,
                                                 CGRectGetWidth(currentRect) * _currentScale,
                                                 CGRectGetHeight(currentRect) * _currentScale
                                                 );
                if (i==20 && j==32) {
                    NSLog(@"(20,32):%@",[NSValue valueWithCGRect:currentRect]);
                }
                CGContextSaveGState(context);
                if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:drawInContext:forColumn:row:frame:)]) {
                    [self.delegate gridView:self drawInContext:context forColumn:j row:i frame:rectInBounds];
                }
                CGContextRestoreGState(context);
            } else {
                continue;
            }
        }
    }
}

#pragma mark - Recognizers Actions
- (void)panRecogAction:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan translationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _innerBoundsBeforeGesture = _innerBounds;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGRect resultRect = CGRectMake(
                                  (CGRectGetMinX(_innerBoundsBeforeGesture)-(location.x/_currentScale)),
                                  (CGRectGetMinY(_innerBoundsBeforeGesture)-(location.y)/_currentScale),
                                  CGRectGetWidth(_innerBoundsBeforeGesture),
                                  CGRectGetHeight(_innerBoundsBeforeGesture));

        _innerBounds = [self checkBoundsEdge:resultRect];
        [self setNeedsDisplay];
    } else {
        // TODO: 判断边缘并回弹(可以考虑在 0.3s 内)
        _innerBoundsBeforeGesture = _innerBounds;
    }
}
- (void)tapRecogAction:(UITapGestureRecognizer *)tap {
    //拿到点击的 view 的坐标
    CGPoint location = [tap locationInView:self];
    CGPoint innerLocation = CGPointMake(location.x / _currentScale + _innerBounds.origin.x ,
                                        location.y / _currentScale + _innerBounds.origin.y );
    NSInteger column = innerLocation.x/(_itemWidth+_marginH);
    NSInteger row = innerLocation.y/(_itemHeight+_marginV);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didTapAtColumn:row:)]) {
        [self.delegate gridView:self didTapAtColumn:column row:row];
    }
}

// 判断缩放边界是否需要贴边处理,并返回需要的 rect
- (CGRect)checkBoundsEdge:(CGRect)resultRect {
    
    CGSize contentSize = [self contentSize];
    CGFloat x = CGRectGetMinX(resultRect);
    CGFloat y = CGRectGetMinY(resultRect);
    CGFloat width = CGRectGetWidth(resultRect);
    CGFloat height = CGRectGetHeight(resultRect);
    
    CGFloat lMargin = _contentInsets.left/_currentScale;
    CGFloat rMargin = _contentInsets.right/_currentScale;
    CGFloat tMargin = _contentInsets.top/_currentScale;
    CGFloat bMargin = _contentInsets.bottom/_currentScale;
    
    if ((contentSize.width+lMargin+rMargin) < CGRectGetWidth(_innerBounds)) {
        // 内宽度小于屏幕宽度
        x = -lMargin;
    } else {
        //只需要考虑边界, 按照边界对齐
        if (x < -lMargin) {
            x = -lMargin;
        }
        if ((x+width) > (contentSize.width + rMargin)) {
            x = contentSize.width + rMargin - width;
        }
    }
    
    if ((contentSize.height+tMargin+bMargin) < CGRectGetHeight(_innerBounds)) {
        // 内宽度小于屏幕宽度
        //需要左对齐
        y = -tMargin;
    } else {
        //只需要考虑边界, 按照边界对齐
        if (y < -tMargin) {
            y = -tMargin;
        }
        if ((y+height) > (contentSize.height + bMargin)) {
            y = contentSize.height + bMargin - height;
        }
    }
    return CGRectMake(x, y, width, height);
}

- (void)pinchRecogAction:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        _scaleBoforePinch = _currentScale;
        _innerBoundsBeforeGesture = _innerBounds;
    } else if (pinch.state == UIGestureRecognizerStateChanged) {
        CGFloat resultScale = _scaleBoforePinch * [pinch scale];
        if (resultScale>_maxScale) {
            return;
        }
        if (resultScale < _minScale) {
            return;
        }
        _currentScale = resultScale;
        // 这里需要计算 content 缩放后 innerBounds 的 bounds
        CGRect resultRect = CGRectMake(
                                  CGRectGetMinX(_innerBoundsBeforeGesture) + (CGRectGetWidth(_innerBoundsBeforeGesture)* (1-1/[pinch scale])/2),
                                  CGRectGetMinY(_innerBoundsBeforeGesture) + (CGRectGetHeight(_innerBoundsBeforeGesture)* (1-1/[pinch scale])/2),
                                  CGRectGetWidth(_innerBoundsBeforeGesture)/[pinch scale],
                                  CGRectGetHeight(_innerBoundsBeforeGesture)/[pinch scale]
                                  );
        _innerBounds = [self checkBoundsEdge:resultRect];
        [self setNeedsDisplay];
    } else {
        // TODO: 判断边缘并回弹(可以考虑在 0.3s 内)
        _scaleBoforePinch = _currentScale;
        _innerBoundsBeforeGesture = _innerBounds;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
/*
#pragma mark - View Touch Events 用于处理用户是否处于点击状态中
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
*/
@end
