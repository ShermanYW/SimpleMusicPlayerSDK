//
//  LGSongListTableViewCell.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGSongListTableViewCell.h"
#import "Common.h"
#import "LGMusic.h"
#import "LGMusicFrame.h"
#import "UIImage+Color.h"

@implementation LGSongListTableViewCell {
    UILabel *_songTitleLable;
    UILabel *_songArtistLable;
    UIImageView *_iconImageView;
    UIImageView *_selectImageView;
    UIImageView *_lineImageView;
}

+ (instancetype)songListCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"Cell";
    LGSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LGSongListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =  [UIColor clearColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        _songTitleLable = [[UILabel alloc] init];
        [self.contentView addSubview:_songTitleLable];
        
        _songArtistLable = [[UILabel alloc] init];
        _songArtistLable.font = [UIFont systemFontOfSize:12];
        _songArtistLable.textColor = COLOR(30.0, 30.0, 30.0, 1.0);
        [self.contentView addSubview:_songArtistLable];
        
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = IMAGE(@"dance02");
        [self.contentView addSubview:_selectImageView];
        
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageWithColor:[UIColor grayColor] Size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1.0)];
        [self.contentView addSubview:_lineImageView];
        
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
        [self addGestureRecognizer:press];
        press = nil;
    }
    return self;
}

- (void)longPressCell:(id)cell {
    //NSLog(@"长按单元格啦%@", _musicFrame.music.musicUniquFlag);
    if (_musicUniquFlag) {
        _musicUniquFlag(_musicFrame.music.musicUniquFlag);
    }
}

- (void)setMusicFrame:(LGMusicFrame *)musicFrame {
    _musicFrame = musicFrame;
    [self settingData];
    [self settingFrame];
}

- (void)settingData {
    LGMusic *music = self.musicFrame.music;
    _iconImageView.image = IMAGE(music.musicImage);
    _songTitleLable.text = music.musicName;
    _songArtistLable.text = music.musicArtist;
    if (music.musicSelected) {
        _selectImageView.hidden = NO;
    } else {
        _selectImageView.hidden = YES;
    }
}

- (void)settingFrame {
    _iconImageView.frame = self.musicFrame.songImageF;
    _songTitleLable.frame = self.musicFrame.songTitleF;
    _selectImageView.frame = self.musicFrame.songSelectF;
    _songArtistLable.frame = self.musicFrame.songArtistF;
    _lineImageView.frame = self.musicFrame.lineImageF;
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
//28     CGSize nameSize = [self sizeWithString:_weibo.name font:NJNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    
}

@end
