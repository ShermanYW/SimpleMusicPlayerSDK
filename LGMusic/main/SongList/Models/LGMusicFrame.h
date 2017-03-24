//
//  LGMusicFrame.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LGMusic;
@interface LGMusicFrame : NSObject

@property(nonatomic,strong)LGMusic *music;

@property(nonatomic, assign)CGRect songTitleF;

@property(nonatomic, assign)CGRect songArtistF;

@property(nonatomic, assign)CGRect songImageF;

@property(nonatomic, assign)CGRect songSelectF;

@property(nonatomic, assign)CGRect lineImageF;

@property(nonatomic, assign)CGFloat cellHeight;



@end
