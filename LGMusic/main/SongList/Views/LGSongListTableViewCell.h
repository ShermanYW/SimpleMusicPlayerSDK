//
//  LGSongListTableViewCell.h
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGMusicFrame;
typedef void(^LGSonglistCellBlock)(NSString *musicUniquFlag);

@interface LGSongListTableViewCell : UITableViewCell

+ (instancetype)songListCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)LGMusicFrame *musicFrame;

@property(nonatomic, copy)LGSonglistCellBlock musicUniquFlag;

@end
