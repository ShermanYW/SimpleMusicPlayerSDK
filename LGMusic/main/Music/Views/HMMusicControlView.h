//
//  HMMusicControlView.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/15.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HMMusicControlViewBtnClickBlock)(NSInteger tagValue);

typedef void(^HMMusicControlViewSliderValueChanged)(CGFloat value);

@interface HMMusicControlView : UIView

@property(nonatomic,copy)HMMusicControlViewBtnClickBlock clickControlButton;

@property(nonatomic,copy)HMMusicControlViewSliderValueChanged sliderValueChanged;


- (void)modifyMusicPlayLoopDisplay:(NSInteger)loop;

- (void)modifyMusicInfos:(NSMutableDictionary *)musicInfos;


/**
 实时更改音乐播放进度方法

 @param progress 当前音乐播放进度
 */
- (void)modfifyMusicPlayProgress:(CGFloat)progress;


/**
 开始播放音乐时，设置播放按钮为选中或取消选择

 @param isPlaying 是否正在播放
 */
- (void)modifyPlayButtonImage:(BOOL)isPlaying;

@end
