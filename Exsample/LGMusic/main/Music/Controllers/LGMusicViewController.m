//
//  LGMusicViewController.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGMusicViewController.h"
//#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "HMMusicControlView.h"
#import "HMMusicAnimationView.h"
#import "Masonry.h"
#import "LGMusicPlayer.h"
#import "LGMusicManager.h"
#import "LPPopup.h"
#import "MBProgressHUD.h"

@interface LGMusicViewController (){
    HMMusicControlView *_controlView;
    HMMusicAnimationView *_animationView; 
    BOOL isPlaying;
    
    LPPopup *_lpppupAlert;
    NSTimer *_readMusicInfoTimer;
}

@end

@implementation LGMusicViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isPlaying = NO;
    [self createMusicView];
    
    [[LGMusicPlayer sharedLGMusicPlayer] configureMusics:[[LGMusicManager sharedMusicManager] selectAllMusics] musicInfos:^(NSMutableDictionary *musicInfos, BOOL success) {
        [_controlView modifyMusicInfos:musicInfos];
        [_controlView modifyMusicPlayLoopDisplay:[[musicInfos objectForKey:MUSIC_LOOP_TYPE] integerValue]];
    }];
}

- (void)createMusicView {
    __weak typeof(self) weakSelf = self;
    _animationView = [[HMMusicAnimationView alloc] init];
    [self.view addSubview:_animationView];
    
    _controlView = [[HMMusicControlView alloc] init];
    [self.view addSubview:_controlView];
    
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@((SCREENHEIGHT-64)*0.6));
        make.bottom.equalTo(_controlView.mas_top);
    }];
    
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@((SCREENHEIGHT-64)*0.4));
        make.top.equalTo(_animationView.mas_bottom);
    }];
    
    _controlView.clickControlButton = ^(NSInteger tagValue){
        HWLog(@"点击按钮啦！%ld", tagValue);
        [weakSelf startAnimationWhenPlayOrStop:tagValue];
    };
    
    _controlView.sliderValueChanged = ^(CGFloat sliderValue) {
        HWLog(@"当前value为：%lf", sliderValue);
        [[LGMusicPlayer sharedLGMusicPlayer] playUptoProgress:sliderValue completion:^{
            
        }];
    };
    
    [LGMusicPlayer sharedLGMusicPlayer].finishPlay = ^{
        [[LGMusicPlayer sharedLGMusicPlayer] playNext:^(NSMutableDictionary *musicInfos, BOOL success) {
            [_controlView modifyMusicInfos:musicInfos];
        }];
    };
}

- (void)startAnimationWhenPlayOrStop: (NSInteger)tagValue {
    __weak typeof(&*self) me = self;
    switch (tagValue) {
        case 101:{
            [[LGMusicPlayer sharedLGMusicPlayer]  playConfigLoopCurrentType:^(MusicLoopType type) {
                HWLog(@"%ld", type);
                [_controlView modifyMusicPlayLoopDisplay:type];
                
                NSString *showPopupTitle;
                switch (type) {
                    case MusicLoopRand:
                        showPopupTitle = @"随机播放";
                        break;
                    case MusicLoopCycle:
                        showPopupTitle = @"循环播放";
                        break;
                    default:
                        showPopupTitle = @"单曲循环";
                        break;
                }
                [me showLppopupText:showPopupTitle superView:me.view center:me.view.center];
            }];
        }break;
        case 102:{
            [[LGMusicPlayer sharedLGMusicPlayer] playBack:^(NSMutableDictionary *musicInfos, BOOL success) {
                [_controlView modifyMusicInfos:musicInfos];
            }];
        }break;
        case 103:{
            isPlaying = !isPlaying;
            if (isPlaying) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[LGMusicPlayer sharedLGMusicPlayer] playStart:^{
                    [MBProgressHUD hideHUDForView:me.view animated:YES];
                    _animationView.animation = isPlaying;
                    [me startReadMusicinfos];
                }];
            } else {
                [[LGMusicPlayer sharedLGMusicPlayer] playPause:^{
                    _animationView.animation = isPlaying;
                    [me stopReadMusicInfos];
                }];
            }
            [_controlView modifyPlayButtonImage:isPlaying];
        }break;
        case 104:{
            [[LGMusicPlayer sharedLGMusicPlayer] playNext:^(NSMutableDictionary *musicInfos, BOOL success) {
                [_controlView modifyMusicInfos:musicInfos];
            }];
        }break;
        case 105:{
        
        }break;
        default:
            break;
    }
}

- (void)showLppopupText:(NSString *)text superView:(UIView *)superView center:(CGPoint)center {
    if (_lpppupAlert) {
        [_lpppupAlert removeFromSuperview];
        _lpppupAlert = nil;
    }
    _lpppupAlert = [LPPopup popupWithText:text];
    _lpppupAlert.popupColor = COLOR(0.0, 0.0, 0.0, 0.6);
    _lpppupAlert.textColor = [UIColor whiteColor];
    [_lpppupAlert showInView:superView centerAtPoint:center duration:1.0 completion:^{
    }];
}

#pragma mark- 定时器读取音乐播放左右声道以及当前歌曲进度
- (void)startReadMusicinfos {
    [self stopReadMusicInfos];
    _readMusicInfoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startRead) userInfo:nil repeats:YES];
}

- (void)startRead {
    [[LGMusicPlayer sharedLGMusicPlayer] readSongPandAndProgress:^(NSMutableDictionary *musicInofs, BOOL success) {
        NSInteger progress = [[musicInofs objectForKey:MUSIC_PROGRESS] integerValue];
        [_controlView modfifyMusicPlayProgress:progress];
        NSLog(@"进度与左右声道: %@ %d", musicInofs, success);
    }];
}

- (void)stopReadMusicInfos {
    if (_readMusicInfoTimer) {
        [_readMusicInfoTimer invalidate];
        _readMusicInfoTimer = nil;
    }
}


@end
