//
//  LGMusicManager.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#define MUSIC_TABLE_NAME @"lgmusics"
#define MUSIC_NAME @"musicName"
#define MUSIC_PATH @"musicPath"
#define MUSIC_IMAGE @"musicImage"
#define MUSIC_ARTIST @"musicArtist"
#define MUSIC_UNIQU_FLAG @"musicUniquFlag"

#import "LGMusicManager.h"
#import "LGMusic.h"
#import "Common.h"
#import "FMResultSet.h"


@implementation LGMusicManager

+ (LGMusicManager *)sharedMusicManager {
    static LGMusicManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[LGMusicManager alloc] initWithPath:DOCEMENT_PATH];
    });
    [mgr createTable];
    return mgr;
}

- (void)createTable {
    NSDictionary *musicDict = [NSDictionary dictionaryWithObjects:@[@"varchar(255)",@"varchar(255)",@"varchar(255)",@"varchar(255)", @"varchar(255)"] forKeys:@[MUSIC_NAME, MUSIC_PATH, MUSIC_IMAGE, MUSIC_ARTIST, MUSIC_UNIQU_FLAG]];
    [self createTable:MUSIC_TABLE_NAME columns:musicDict];
}

- (void)addMusic:(LGMusic *)music {
    if (![self isFindMusic:music]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[music.musicName, music.musicPath, music.musicImage, music.musicArtist, music.musicUniquFlag] forKeys:@[MUSIC_NAME, MUSIC_PATH, MUSIC_IMAGE, MUSIC_ARTIST, MUSIC_UNIQU_FLAG]];
        NSLog(@"%@", dict);
        BOOL ret = [self insertValueByColumns:dict intoTable:MUSIC_TABLE_NAME];
//        NSLog(@"%d",ret);
    }
}

- (void)deleteMusic:(NSString *)musicUniquFlag completion:(void (^)())completion {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:musicUniquFlag, MUSIC_UNIQU_FLAG, nil];
    [self deleteValueFromTable:MUSIC_TABLE_NAME conditions:dict];
    
    if (completion) {
        completion();
    }
}

- (NSMutableArray *)selectAllMusics {
    FMResultSet *result =  [self queryValueFromTable:MUSIC_TABLE_NAME selects:nil conditions:nil];  
    NSMutableArray *allMusic = [NSMutableArray array];
    while ([result next]) {
        LGMusic *music = [[LGMusic alloc] init];
        music.musicName = [result stringForColumn:MUSIC_NAME];
        music.musicImage = [result stringForColumn:MUSIC_IMAGE];
        music.musicArtist = [result stringForColumn:MUSIC_ARTIST];
        music.musicPath = [result stringForColumn:MUSIC_PATH];
        music.musicUniquFlag = [result stringForColumn:MUSIC_UNIQU_FLAG];
        [allMusic addObject:music];
        music = nil;
    }
//    NSLog(@"%@", allMusic);
    return allMusic;
}

- (BOOL)isFindMusic:(LGMusic *)music {
    NSDictionary *condition = [NSDictionary dictionaryWithObjectsAndKeys:music.musicUniquFlag, MUSIC_UNIQU_FLAG, nil];
    FMResultSet *result =  [self queryValueFromTable:MUSIC_TABLE_NAME selects:nil conditions:condition];
    BOOL isFind = NO;
    while ([result next]) {
        isFind = YES;
        break;
    }
//    NSLog(@"歌曲是否存在？%d", isFind);
    return isFind;
}


@end
