//
//  LGMusicPlayer.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LGMusic.h"

#define MUSIC_HISTORY_SONG_INDEX @"LGmusicHistoryPlayIndex"
#define MUSIC_PLAY_LOOP_TYPE    @"LGmusicPlayLoopType"

@interface LGMusicPlayer ()<AVAudioPlayerDelegate>

@end

@implementation LGMusicPlayer {
    AVAudioPlayer *_player;
    NSMutableArray *_allMusics;
    NSInteger currentPlayingMusicIndex;
    NSMutableDictionary *_currentMusicInfos;
}

+ (instancetype)sharedLGMusicPlayer {
    static LGMusicPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[LGMusicPlayer alloc] init];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        //初始化化方法
        _loopType = [[NSUserDefaults standardUserDefaults] integerForKey:MUSIC_PLAY_LOOP_TYPE];
        _currentMusicInfos = [NSMutableDictionary dictionary];
        [_currentMusicInfos setObject:[NSNumber numberWithInteger:_loopType] forKey:MUSIC_LOOP_TYPE];
        _playing = NO;
    }
    return self;
}

/**
 _currentMusicInfos : NSMutableDictionary，存放返回音乐相关信息
    key：@“musicLoopType”，value：_loopType 音乐播放模式
    key：@“musicTitle”，value：musicTitle 音乐名
    key：@“musicArtist”，value：musicArtist 歌手名
    key：@“musicLeftPond”，value：musicLeftPond 左声道
    key：@“musicRightPond”，value：musicRightPond 右声道
    key：@“musicProgress”，value：musicProgress 播放进度
 */
- (void)initializeMusic {
    LGMusic *music = [_allMusics objectAtIndex:currentPlayingMusicIndex];
    NSString *musicArtist = music.musicArtist;
    NSString *musicTitle = music.musicName;
    NSString *musicPath = music.musicPath;
    NSURL *musicUrl = [NSURL URLWithString:musicPath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    
    AudioFileID fileID = nil;
    OSStatus err = noErr;
    err = AudioFileOpenURL((__bridge CFURLRef)(musicUrl), kAudioFileReadPermission, 0, &fileID);
    if( err != noErr ) {
        NSLog( @"AudioFileOpenURL failed" );
        return;
    }
    UInt32 id3DataSize  = 0;
    err = AudioFileGetPropertyInfo( fileID,   kAudioFilePropertyID3Tag, &id3DataSize, NULL );
    
    if( err != noErr ) {
        NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );
    }
    NSDictionary *piDict = nil;
    UInt32 piDataSize   = sizeof( piDict );
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary" );
    }
    NSString * Artist = [(NSDictionary*)piDict objectForKey:
                           [NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
    NSString * Title = [(NSDictionary*)piDict objectForKey:
                        [NSString stringWithUTF8String: kAFInfoDictionary_Title]];
    if(Title == nil) Title=@"";
    if(Artist== nil) Artist=@"";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    [dict setObject:Title forKey:MPMediaItemPropertyTitle];
    [dict setObject:Artist forKey:MPMediaItemPropertyArtist];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    
    [_currentMusicInfos setObject:musicTitle forKey:MUSIC_TITLE];
    [_currentMusicInfos setObject:musicArtist forKey:MUSIC_ARTIST];
}

/**
 初始化设置音乐变量数组以及开始播放音乐下标

 @param musics 数组，内部元素是音乐模型
 @param index 待播放的音乐下标，即从哪首歌开始播放
 */
- (void)setMusics:(NSMutableArray *)musics musicPlayAtIndex:(NSInteger)index musicInfos:(MusicInfos)infos {
    NSInteger count = musics.count;
    if (count == 0) {
        [_allMusics removeAllObjects];
    } else {
        if (index >= count) {
            currentPlayingMusicIndex = index;
#warning 开始播放音乐超出所有音乐数组下标
        } else {
            if (_player) {
                [_player stop];
                _player = nil;
            }
            
            [_allMusics removeAllObjects];
            _allMusics = [NSMutableArray arrayWithArray:musics];
            currentPlayingMusicIndex = index;
            [self initializeMusic];
        }
    }
    if (infos) infos(_currentMusicInfos, YES);
}

- (void)configureMusics:(NSMutableArray *)musics musicInfos:(MusicInfos)musicInfos {
    NSUInteger count = musics.count;
    if (count == 0) {
        [_allMusics removeAllObjects];
    } else {
        currentPlayingMusicIndex = [[NSUserDefaults standardUserDefaults] integerForKey:MUSIC_HISTORY_SONG_INDEX];
        
        if (_player) {
            [_player stop];
            _player = nil;
        }
        if (currentPlayingMusicIndex >= count) {
            currentPlayingMusicIndex = 0;
        }
        [_allMusics removeAllObjects];
        _allMusics = [NSMutableArray arrayWithArray:musics];
        [self initializeMusic];
    }
    if (musicInfos) musicInfos(_currentMusicInfos, YES);
}

// play music
- (void)playStart: (void (^)())completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player play];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        _playing = YES;
        if (completion) completion();
    });
}

// 暂停播放
- (void)playPause: (void (^)())completion {
    [_player pause];
    _playing = NO;
    if (completion) completion();
}

// 停止播放
- (void)playStop: (void (^)())completion {
    [_player stop];
    _playing = NO;
    if (completion) completion();
}

- (void)playNext:(MusicInfos)infos {
    BOOL success = NO;
    if (_allMusics.count > 0) {
        switch (_loopType) {
            case MusicLoopCycle:
            {
                currentPlayingMusicIndex ++;
                if (currentPlayingMusicIndex >= _allMusics.count) currentPlayingMusicIndex = 0;
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
                
            }break;
            case MusicLoopRand:{
                int index = arc4random() % _allMusics.count;
                currentPlayingMusicIndex = index;
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
//                [self initializeMusic];
//                [self play_start:nil];
            }break;
            case MusicLoopSingle:{
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
//                [self initializeMusic];
//                [self play_start:nil];
            }break;
            default:
                break;
        }
        success = YES;
    }
    [self recordPlayHistoryMusicIndex];
    infos(_currentMusicInfos, success);
}

- (void)playBack:(MusicInfos)infos {
    BOOL success = NO;
    if (_allMusics.count != 0) {
        switch (_loopType) {
            case MusicLoopCycle:{
                currentPlayingMusicIndex --;
                if (currentPlayingMusicIndex < 0)
                    currentPlayingMusicIndex = _allMusics.count-1;
//                [_player stop];
//                _player = nil;
//                [self initializeMusic];
//                [self play_start:nil];
                
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
                
            }break;
            case MusicLoopSingle:{
//                [self initializeMusic];
//                [self play_start:nil];
                
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
            } break;
            case MusicLoopRand:{
                NSInteger index = arc4random() % _allMusics.count;
                currentPlayingMusicIndex = index;
//                [self initializeMusic];
//                [self play_start:nil];
                
                if (self.isPlaying) {
                    [_player stop];
                    _player = nil;
                    [self initializeMusic];
                    [self playStart:nil];
                } else {
                    [self initializeMusic];
                }
                
            } break;
            default:
                break;
        }
        success = YES;
    }
    [self recordPlayHistoryMusicIndex];
    infos(_currentMusicInfos, success);
}


- (void)playConfigLoopCurrentType:(void(^)(MusicLoopType type))loopType {
    _loopType ++;
    if (_loopType >2) _loopType = 0;
    loopType(_loopType);
    [self recordMusicPlayLoopType];
}

- (void)playUptoProgress:(CGFloat)value completion:(void (^)(void))completion {
    NSLog(@"改变slider值%lf", value);
    
    if (value < 0.0 || value > 100.0) {
        return;
    }
    CGFloat currentValue = _player.duration *(value/100.0);
    [_player setCurrentTime:currentValue];
    if (self.isPlaying) {
        [_player playAtTime:currentValue];
    }
    if (completion) completion();
}


- (void)readSongPandAndProgress:(MusicInfos)infos {
    _player.meteringEnabled = YES;//开启仪表计数功能
    [_player updateMeters];//更新仪表读数
    float power11 = [_player averagePowerForChannel:0];
    float power22 = [_player averagePowerForChannel:1];
    
    float fabpower11=fabsf(power11);
    float fabpower22=fabsf(power22);
    NSInteger progressValue = 0;
    if (_player.isPlaying)
    {
        progressValue = 100 * _player.currentTime/_player.duration;
    }
    
    [_currentMusicInfos setValue:[NSNumber numberWithFloat:fabpower11] forKey:MUSIC_LEFT_POND];
    [_currentMusicInfos setValue:[NSNumber numberWithFloat:fabpower22] forKey:MUSIC_RIGHT_POND];
    [_currentMusicInfos setValue:[NSNumber numberWithInteger:progressValue] forKey:MUSIC_PROGRESS];
    infos(_currentMusicInfos,YES);
}

#pragma mark- 记录循环模式偏好设置方法

/**
 说明：记录播放循环模式方法
 */
- (void)recordPlayHistoryMusicIndex {
    [[NSUserDefaults standardUserDefaults] setInteger:currentPlayingMusicIndex forKey:MUSIC_HISTORY_SONG_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 说明：记录音乐播放循环模式
 */
- (void)recordMusicPlayLoopType {
    [[NSUserDefaults standardUserDefaults] setInteger:_loopType forKey:MUSIC_PLAY_LOOP_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark- AVAudioPlayer Delegate

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.finishPlay();
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

//#if TARGET_OS_IPHONE

/* AVAudioPlayer INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {

} //NS_DEPRECATED_IOS(2_2, 8_0);

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {

} //NS_DEPRECATED_IOS(6_0, 8_0);

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    
}//NS_DEPRECATED_IOS(4_0, 6_0);

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    
}


@end
