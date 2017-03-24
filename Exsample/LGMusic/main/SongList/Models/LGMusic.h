//
//  LGMusic.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMusic : NSObject

@property(nonatomic, copy)NSString *musicName;
@property(nonatomic,copy)NSString *musicPath;
@property(nonatomic, copy)NSString *musicImage;
@property(nonatomic,copy)NSString *musicArtist;
@property(nonatomic,copy)NSString *musicUniquFlag;


@property(nonatomic, assign, getter=isMusicSelected)BOOL musicSelected;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)musicWithDict:(NSDictionary *)dict;
@end
