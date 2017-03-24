//
//  HomeViewController.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/15.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "HomeViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "LGMusic.h"
#import "LGMusicManager.h"
#import "LGMusicViewController.h"
#import "LGSongListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HomeViewController ()<MPMediaPickerControllerDelegate>{
    LGMusicViewController       *_musicVC;
    LGSongListViewController    *_songListVC;
    UIViewController            *_currentVC;
    UIView                      *_containerView;
    UISegmentedControl          *_chooseSegmentControl;
    
}
@end

@implementation HomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = COLOR(0.0f, 0.0f, 0.0f, 0.5);
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _chooseSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"音乐播放", @"歌曲列表"]];
    _chooseSegmentControl.selectedSegmentIndex = 0; //设置默认选中的列
    _chooseSegmentControl.tintColor = COLOR(40, 63.0, 58.0, 1.0);
    _chooseSegmentControl.momentary = NO; //设置点击之后恢复原样
    
    [self changeNavigationBarLeftBarItem: 0];
    
    
    [_chooseSegmentControl addTarget:self action:@selector(changeSegmentValue:) forControlEvents:UIControlEventValueChanged];
    _chooseSegmentControl.frame = HSFrame(0, 0, 100, 30);
    self.navigationItem.titleView = _chooseSegmentControl;
    self.view.backgroundColor = COLOR(51, 53, 52, 1.0);
    
    _containerView = [[UIView alloc] init];
    _containerView.frame = HSFrame(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    [self.view addSubview:_containerView];
    [self addSubController];
    
    NSString *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    HWLog(@"%@", dbPath);
}

- (void)changeNavigationBarLeftBarItem: (NSInteger)segmentSelectIndex {
    
    NSString *itemTitle = @"";
    if (segmentSelectIndex == 1) {
        itemTitle = @"添加";
    }
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(addMusic:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)addMusic: (id)sender{
    switch (_chooseSegmentControl.selectedSegmentIndex) {
        case 0:
            //分享歌曲
            HWLog(@"点击分享歌曲");
            break;
        case 1: {
            //点击添加歌曲
            HWLog(@"点击添加歌曲");
            MPMediaPickerController *picker =
            [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
            picker.delegate	= self;
            picker.allowsPickingMultipleItems	= YES;
            [self presentViewController:picker animated:YES completion:nil];
//            picker = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark- private method 添加子控制器方法
- (void)addSubController{
    _musicVC = [[LGMusicViewController alloc] init];
    [self addChildViewController:_musicVC];
    
    _songListVC = [[LGSongListViewController alloc] init];
    [self addChildViewController:_songListVC];
    
    [self fitSubControllerView:_musicVC];
    [_containerView addSubview:_musicVC.view];
    _currentVC = _musicVC;
}

// 适配子控制器view到本控制器容器view
- (void)fitSubControllerView: (UIViewController *)subVC {
    CGRect frame = _containerView.frame;
    frame.origin.y = 0;
    subVC.view.frame = frame;
}

- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}
- (void)translateSubController{
    
}

#pragma mark- 事件响应方法
- (void)changeSegmentValue:(UISegmentedControl *) sender {
    if ((sender.selectedSegmentIndex == 0 && _currentVC == _musicVC) ||(sender.selectedSegmentIndex == 1 && _currentVC == _songListVC)) {
        return;
    }
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self fitSubControllerView:_musicVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_musicVC];
            
            [self.navigationItem.leftBarButtonItem setTitle:@""];
            break;
        case 1:
            [self fitSubControllerView:_songListVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_songListVC];
            [self.navigationItem.leftBarButtonItem setTitle:@"添加"];
            break;
        default:
            break;
    }
    
    [self changeNavigationBarLeftBarItem: sender.selectedSegmentIndex];
//    NSLog(@"%ld", sender.selectedSegmentIndex);
//    NSLog(@"aaa");
}

#pragma mark- 歌曲选取控制器回调
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    HWLog(@"%@", mediaItemCollection);
    HWLog(@"已选择完音乐");
    
    for (int i = 0; i < mediaItemCollection.count; i++) {
        MPMediaItem *selectedSong = [[mediaItemCollection items] objectAtIndex:i];
        NSURL *songURL = [selectedSong valueForProperty:MPMediaItemPropertyAssetURL]; // 歌曲的URL通常为ipod-library://item/
        NSString *songTitle = [selectedSong valueForProperty:MPMediaItemPropertyTitle];  // 歌曲的Title
        NSString *artist = [selectedSong valueForProperty:MPMediaItemPropertyArtist];  // 歌手
        NSString *songURLString = [songURL absoluteString];
        
        if (!artist) {
            artist = @"未知歌手";
        }
        
        LGMusic *music = [[LGMusic alloc] init];
        music.musicName = songTitle;
        music.musicPath = songURLString;
        music.musicImage = @"";
        music.musicArtist = artist;
        music.musicUniquFlag = [NSString stringWithFormat:@"%@%@%@", songTitle, UNIQU_FLAG, songURLString];
        [[LGMusicManager sharedMusicManager] addMusic:music];
    }
    
    [self dismissViewControllerAnimated:mediaPicker completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_MUSIC_NAME_NOTI object:nil]; 
    }];
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    HWLog(@"取消选择");
    [self dismissViewControllerAnimated:mediaPicker completion:^{
        
    }];
}


@end
