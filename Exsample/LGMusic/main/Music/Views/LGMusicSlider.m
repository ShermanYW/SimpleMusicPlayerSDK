//
//  LGMusicSlider.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/19.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGMusicSlider.h"
#import "Masonry.h"
#import "Common.h"
#import "UIImage+Color.h"

@implementation LGMusicSlider {
    UISlider *_slider;
}

+ (instancetype)musicSlider:(void (^)(CGFloat))value {
    LGMusicSlider *slider = [[LGMusicSlider alloc] init];
    return slider;
}

- (instancetype)init {
    if (self = [super init]) {
        _slider = [[UISlider alloc] init];
        _slider.minimumTrackTintColor = [UIColor redColor];
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        UIImage *thumbImage = [UIImage imageWithColor:COLOR(255.0f, 255.0f, 255.0f, 1.0) Size:CGSizeMake(20, 20)];
        UIImage *newThumbImage = [UIImage circleImage:thumbImage borderWidth:1.0 borderColor:COLOR(0.0, 0.0, 0.0, 1.0f)]; 
        [_slider setThumbImage:newThumbImage forState:UIControlStateNormal];
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 100.0;
        _slider.continuous = NO;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        [self configFrameForSubViews];
    }
    return self;
}

- (void)configFrameForSubViews {
    __weak typeof(*&self) me = self;
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(me.mas_left).with.offset(20);
        make.right.equalTo(me.mas_right).with.offset(-20);
        make.center.equalTo(me);
        make.height.equalTo(@30);
    }]; 
}

- (void)translateProgress:(CGFloat)progress {
    CGFloat value = 0.0;
    value = progress;
    if (progress < 0.0) value = 0.0;
    if (progress > 100.0) value = 100.0;
//    NSLog(@"当前进度为: %lf", progress);
    [_slider setValue:value animated:YES];
}
#pragma mark- slider value changed
- (void)sliderValueChanged:(UISlider *)slider {
    CGFloat value = slider.value;
    self.valueChanged(value);
}


/**
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    _drawPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 40, 100)];
    
    // Drawing code
}
*/

@end
