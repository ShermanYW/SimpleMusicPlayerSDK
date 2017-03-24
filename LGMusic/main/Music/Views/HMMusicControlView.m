//
//  HMMusicControlView.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/15.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "HMMusicControlView.h"
#import "Common.h"
#import "Masonry.h"
#import "LGMusicSlider.h"

@interface HMMusicControlView (){
    NSMutableArray *_allButton;
    UILabel *_songTitleLabel;
    UILabel *_artistLabel;
    LGMusicSlider *_slider;
}

@end

@implementation HMMusicControlView

- (instancetype)init {
    
    if (self = [super init]) {
        _allButton = [NSMutableArray array];
        [self createControlBtn];
    }
    return self;
}

/**
    创建本view时，同步创建对应按钮
 */
- (void)createControlBtn{
    __weak typeof(self) me = self;
    
    NSArray *btnImageArray = @[@"music_mode_cycle", @"music_back", @"music_play", @"music_next", @"music_list"];
    CGFloat padding = 10.0f;
    CGFloat btnWH = (SCREENWIDTH-(btnImageArray.count +1)*padding)/btnImageArray.count;
    
    UIButton *lastBtn = nil;
    for (int i = 0; i < btnImageArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:IMAGE([btnImageArray objectAtIndex:i]) forState:UIControlStateNormal];
        btn.tag = 101 + i;
        btn.reversesTitleShadowWhenHighlighted = NO;
        [self addSubview:btn];
        if (i != 2) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
        } else {
            [btn setImage:IMAGE(@"music_pause") forState:UIControlStateSelected];
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([NSNumber numberWithFloat:btnWH]);
            make.width.mas_equalTo([NSNumber numberWithFloat:btnWH]);
            make.bottom.equalTo(me.mas_bottom).with.offset(-3*padding);
            if (!lastBtn) {
                make.left.equalTo(me.mas_left).with.offset(padding);
            } else {
                make.left.equalTo(lastBtn.mas_right).with.offset(padding);
            }
        }];
        lastBtn = btn;
        [_allButton addObject:btn];
    }
    
    _songTitleLabel = [[UILabel alloc] init];
    _songTitleLabel.textAlignment = NSTextAlignmentCenter; 
    _songTitleLabel.textColor = COLOR(255.0, 255.0, 255.0, 1.0);
    _songTitleLabel.text = @"暂无歌曲";
    [self addSubview:_songTitleLabel];
    
    _artistLabel = [[UILabel alloc] init];
    _artistLabel.font = [UIFont systemFontOfSize:12];
    _artistLabel.textAlignment = NSTextAlignmentCenter;
    _artistLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_artistLabel];
    
    [_songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(me);
        make.left.equalTo(me.mas_left).with.offset(40);
        make.right.equalTo(me.mas_right).with.offset(-40);
        make.height.equalTo(@40);
    }];
    
    [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_songTitleLabel.mas_bottom);
        make.left.equalTo(me.mas_left).with.offset(40);
        make.right.equalTo(me.mas_right).with.offset(-40);
        make.height.equalTo(@20);
    }];
    
    _slider = [[LGMusicSlider alloc] init];
    [self addSubview:_slider];
    
    UIButton *btn = _allButton.firstObject;
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_artistLabel.mas_bottom);
        make.left.equalTo(me.mas_left);
        make.right.equalTo(me.mas_right);
        make.bottom.equalTo(btn.mas_top);
    }];
    _slider.valueChanged = ^(CGFloat value){
        me.sliderValueChanged(value);
    };
}

// 按钮点击事件响应方法
- (void)controlButtonClicked:(UIButton *)btn {
    self.clickControlButton(btn.tag);
}


- (void)modifyMusicInfos:(NSMutableDictionary *)musicInfos {
    _songTitleLabel.text = [musicInfos objectForKey:@"musicTitle"];
    _artistLabel.text = [musicInfos objectForKey:@"musicArtist"];
}

- (void)modifyMusicPlayLoopDisplay:(NSInteger)loop {
    UIButton *btn = _allButton.firstObject;
    NSString *btnImageString = @"music_mode_cycle";
    switch (loop) {
        case 1:{
            btnImageString = @"music_mode_single";
        }break;
        case 2:{
            btnImageString = @"music_mode_rand";
        }break;
        default:
            break;
    }
    [btn setImage:IMAGE(btnImageString) forState:UIControlStateNormal];
    btnImageString = nil;
    btn = nil;
//    [[UIView alloc] viewWithTag:<#(NSInteger)#>];
}

// 当前音乐进度同步
- (void)modfifyMusicPlayProgress:(CGFloat)progress {
    [_slider translateProgress:progress];
}

- (void)modifyPlayButtonImage:(BOOL)isPlaying {
    UIButton *btn = [_allButton objectAtIndex:2];//[(UIButton *)[UIView alloc] viewWithTag:103];
    btn.selected = isPlaying;
}
@end
