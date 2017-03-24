//
//  LGMusicSlider.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/19.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sliderValueChanged)(CGFloat value);

@interface LGMusicSlider : UIView

+ (instancetype)musicSlider:(void (^)(CGFloat value)) value;

- (void)translateProgress:(CGFloat)progress;

@property(nonatomic,copy)sliderValueChanged valueChanged;




@end
