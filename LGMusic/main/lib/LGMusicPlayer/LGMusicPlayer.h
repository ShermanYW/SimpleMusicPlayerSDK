//
//  LGMusicPlayer.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define MUSIC_TITLE         @"musicTitle"
#define MUSIC_ARTIST        @"musicArtist"
#define MUSIC_LOOP_TYPE     @"musicLoopType"
#define MUSIC_LEFT_POND     @"musicLeftPond"
#define MUSIC_RIGHT_POND    @"musicRightPond"
#define MUSIC_PROGRESS      @"musicProgress"

typedef void(^MusicInfos)(NSMutableDictionary *musicInfos, BOOL success);
typedef void(^MusicPlayFinishBlock)(void);

typedef NS_OPTIONS(NSInteger, MusicLoopType) {
    MusicLoopCycle = 0,
    MusicLoopSingle = 1,
    MusicLoopRand = 2
};

@interface LGMusicPlayer : NSObject

+ (instancetype)sharedLGMusicPlayer;

/**
 是否正在播放中
 */
@property(nonatomic, assign, getter = isPlaying)BOOL playing;

/**
 歌曲播放流程机制，分别有三种：循环播放，单曲循环，随机播放
 MusicLoopType ： 枚举类型
 MusicLoopCycle：循环播放
 MusicLoopSingle：单曲循环
 MusicLoopRand：随机播放
 */
@property(nonatomic, assign)MusicLoopType loopType;

/**
 初始化设置音乐变量数组以及开始播放音乐下标
 
 @param musics 数组，内部元素是音乐模型
 @param index 待播放的音乐下标，即从哪首歌开始播放
 */
- (void)setMusics:(NSMutableArray *)musics musicPlayAtIndex:(NSInteger)index musicInfos:(MusicInfos)infos;

/**
 初始化歌曲播放数据源

 @param musics 歌曲源模型数据，必选；
 @param musicInfos 配置完成，block返回歌曲相关信息
 */
- (void)configureMusics:(NSMutableArray *)musics musicInfos:(MusicInfos)musicInfos;

/**
 歌曲播放进度设置

 @param value 歌曲进度值
 @param completion 完成回调
 */
- (void)playUptoProgress:(CGFloat)value completion:(void (^)(void))completion;

/**
 开始播放音乐

 @param completion 完成回调block
 */
- (void)playStart: (void (^)())completion;

/**
 暂停播放音乐

 @param completion 完成回调block
 */
- (void)playPause: (void (^)())completion;

/**
 停止音乐播放

 @param completion 完成回调block
 */
- (void)playStop: (void (^)())completion;

/**
 下一首

 @param infos 回调信息，包含当前歌曲名称，艺术家等信息
 */
- (void)playNext:(MusicInfos)infos;

/**
 上一首

 @param infos 回调信息，包含当前歌曲名称，艺术家等信息
 */
- (void)playBack:(MusicInfos)infos;

/**
 设置音乐播放循环机制

 @param loopType 完成设置播放机制后回调，loopType为当前循环机制
 */
- (void)playConfigLoopCurrentType:(void(^)(MusicLoopType type))loopType;

/**
 读取声道和进度

 @param infos 歌曲信息回调，包含左右声道及当前歌曲播放进度
 */
- (void)readSongPandAndProgress:(MusicInfos)infos;

/**
 完成歌曲播放block回调
 */
@property(nonatomic,copy)MusicPlayFinishBlock finishPlay;

@end
