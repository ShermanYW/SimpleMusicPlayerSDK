//
//  LGMusicManager.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/18.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "FMDBHelper.h"
@class LGMusic;

@interface LGMusicManager : FMDBHelper

+ (LGMusicManager *)sharedMusicManager;

- (void)addMusic:(LGMusic *)music;

- (void)deleteMusic:(NSString *)musicUniquFlag completion:(void (^)())completion;

- (NSMutableArray *)selectAllMusics;


@end
