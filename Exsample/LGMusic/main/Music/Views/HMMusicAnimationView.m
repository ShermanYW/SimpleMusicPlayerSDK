//
//  HMMusicAnimationView.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "HMMusicAnimationView.h"
#import "Common.h"
#import "Masonry.h"

@implementation HMMusicAnimationView {
    CGFloat _animationCordius;
    NSTimer *_rotationTimer;
    
    UIImageView *_circleImageView;
    UIImageView *_danceGirlImageView;
    UIView *_noticeFlagImageView;
}

- (instancetype)init  {
    if (self = [super init ]) {
        [self newSubViews];
    }
    return self;
}

- (void)newSubViews {
    __weak typeof(self) me = self;
    CGFloat padding = 30.0;
    _circleImageView = [[UIImageView alloc] init];
    _circleImageView.image = IMAGE(@"circlePan");
    [self addSubview:_circleImageView];
    
    _danceGirlImageView = [[UIImageView alloc] init];
    _danceGirlImageView.image = IMAGE(@"dance32");
    [self addSubview:_danceGirlImageView];
    
    _noticeFlagImageView = [[UIView alloc] init];
    _noticeFlagImageView.backgroundColor = [UIColor greenColor];
    _noticeFlagImageView.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [self addSubview:_noticeFlagImageView];
    
    [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(me);
        make.left.equalTo(me.mas_left).with.offset(padding);
        make.right.equalTo(me.mas_right).with.offset(-padding);
        make.height.equalTo(_circleImageView.mas_width);
    }];
    
    [_danceGirlImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_circleImageView);
        make.height.equalTo(_circleImageView.mas_height).multipliedBy(0.5);
        make.width.equalTo(_circleImageView.mas_width).multipliedBy(0.5);
    }];
    
//    [_noticeFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_danceGirlImageView.mas_top).with.offset(0);
//        make.centerX.equalTo(me.mas_centerX);
//        make.width.mas_equalTo(@40);
//        make.top.equalTo(me.mas_top).with.offset(0);
//    }];
}

- (void)setAnimation:(BOOL)animation {
    _animation = animation;
    if (_animation) {
        [self startDance];
        [self startRotationCircleView];
        [self startRotationFlagView];
    } else {
        [self stopDance];
        [self stopRatationCircleView];
        [self stopRotationFlagView];
    }
}

#pragma mark- 动效方法
- (void)startDance {
    NSMutableArray *danceGirlImages = [@[] mutableCopy];
    NSString *imageString;
    for (int i = 1; i <= 35; i++) {
        if (i < 10) {
            imageString = [NSString stringWithFormat:@"dance0%d", i];
        }else {
            imageString = [NSString stringWithFormat:@"dance%d", i];
        }
        [danceGirlImages addObject:IMAGE(imageString)];
        imageString = nil;
    }
    [_danceGirlImageView setAnimationImages:danceGirlImages];
    [_danceGirlImageView setAnimationRepeatCount:0];
    [_danceGirlImageView setAnimationDuration:35 * 0.3];
    [_danceGirlImageView startAnimating];
    [danceGirlImages removeAllObjects];
    danceGirlImages = nil;
}

- (void)stopDance {
    [_danceGirlImageView stopAnimating];
    _danceGirlImageView.image = IMAGE(@"dance32");
}

/**
 开启转动定时器
 */
- (void)startRotationCircleView{
    _rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(rotateCircleView) userInfo:nil repeats:YES];
}

- (void)rotateCircleView {
    _animationCordius += M_PI/100.0;
    _circleImageView.transform = CGAffineTransformMakeRotation(_animationCordius);
    if (_animationCordius > M_PI *2) {
        _animationCordius = 0.0;
    }
}

- (void)stopRatationCircleView{
    if (_rotationTimer) {
        [_rotationTimer invalidate];
        _rotationTimer = nil;
    }
    _animationCordius = 0.0;
    _circleImageView.transform = CGAffineTransformMakeRotation(_animationCordius);
}

- (void)startRotationFlagView{
    [UIView animateWithDuration:1.0 animations:^{
        _noticeFlagImageView.transform = CGAffineTransformMakeRotation(0.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)stopRotationFlagView{
    [UIView animateWithDuration:1.0 animations:^{
        _noticeFlagImageView.transform = CGAffineTransformMakeRotation(-M_PI_4);
    } completion:^(BOOL finished) {
        
    }];
}

@end
