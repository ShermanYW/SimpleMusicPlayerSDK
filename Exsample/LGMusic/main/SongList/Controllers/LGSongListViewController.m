//
//  LGSongListViewController.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGSongListViewController.h"
#import "Common.h"
#import "LGMusic.h"
#import "Masonry.h"
#import "LGMusicFrame.h"
#import "LGSongListTableViewCell.h"
#import "LGMusicManager.h"


@interface LGSongListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_songListTableView;
}

@property(nonatomic,strong)NSMutableArray *statuFrams;

@end

@implementation LGSongListViewController

-(NSMutableArray *)statuFrams {
    if (!_statuFrams) {
        _statuFrams = [NSMutableArray array];
        NSArray *musics = [[LGMusicManager sharedMusicManager] selectAllMusics];
        for (LGMusic *music in musics) {
            LGMusicFrame *frame = [[LGMusicFrame alloc] init];
            frame.music = music;
            [_statuFrams addObject:frame];
        }
    }
    return _statuFrams;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:RELOAD_MUSIC_NAME_NOTI object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_MUSIC_NAME_NOTI object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubView];
}

- (void)recieveNotification: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_songListTableView reloadData];
    });
    [_songListTableView reloadData];
//    NSLog(@"我收到通知了%@",noti);
}
#pragma mark- 视图创建方法集合
- (void)createSubView{
    _songListTableView = [[UITableView alloc] init];
    _songListTableView.delegate = self;
    _songListTableView.dataSource = self;
    _songListTableView.backgroundColor = [UIColor lightGrayColor];
    _songListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_songListTableView];
    
    __weak typeof(self) me = self;
    [_songListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(me.view);
    }];
}


#pragma mark- TableView delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGSongListTableViewCell *cell = [LGSongListTableViewCell songListCellWithTableView:tableView];
    cell.musicFrame = self.statuFrams[indexPath.row];
    
    __weak typeof(self) me = self;
    cell.musicUniquFlag = ^(NSString *musicUniquFlag) {
        NSString *message = [[NSString alloc] initWithFormat:@"确定删除歌曲：%@ ?",[musicUniquFlag componentsSeparatedByString:@"LGMUSIC"].firstObject];
        //NSString *musicTitle = musicUniquFlag;
        
        HWLog(@"%@", musicUniquFlag);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[me dismissViewControllerAnimated:YES completion:nil];
            
            [[LGMusicManager sharedMusicManager] deleteMusic:musicUniquFlag completion:^{
                [me reloadTableView];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[me dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        [me presentViewController:alertController animated:YES completion:nil];

    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.statuFrams.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGMusicFrame *musicFrame = self.statuFrams[indexPath.row];
    return musicFrame.cellHeight;
}

- (void)reloadTableView {
    [_songListTableView reloadData];
}

@end
