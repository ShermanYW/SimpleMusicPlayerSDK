//
//  LGMusicFrame.m
//  LGMusic
//
//  Created by SHERMAN on 2017/3/16.
//  Copyright © 2017年 sherman. All rights reserved.
//

#import "LGMusicFrame.h"
#import "LGMusic.h"

@implementation LGMusicFrame

-(void)setMusic:(LGMusic *)music {
    _music = music;
    
    CGFloat padding = 10;
    
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 60;
    CGFloat iconH = 60;
    self.songImageF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGSize size = [self sizeWithString:music.musicName font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(200, 60)];
    
    CGFloat titleX = CGRectGetMaxX(self.songImageF) + padding;
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleY = iconY;
    self.songTitleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat artistX = titleX;
    CGSize artistSize = [self sizeWithString:music.musicArtist font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat artistW = artistSize.width;
    CGFloat artistH = artistSize.height;
    CGFloat artistY = CGRectGetMaxY(self.songTitleF);
    self.songArtistF = CGRectMake(artistX, artistY, artistW, artistH);
    
    CGFloat selectW_H = 30;
    CGFloat selectX = [UIScreen mainScreen].bounds.size.width - padding - selectW_H;
    CGFloat selectY = iconY + (iconH - selectW_H)/2.0;
    self.songSelectF = CGRectMake(selectX, selectY, selectW_H, selectW_H);
    
    
    CGFloat iconMaxY = CGRectGetMaxY(self.songImageF);
    CGFloat titleMaxY = CGRectGetMaxY(self.songArtistF);
    
    CGFloat lineY = 0;
    (iconMaxY >= titleMaxY)? (lineY = iconMaxY + padding):(lineY = titleMaxY + padding);
    
    CGFloat lineX = 0;
    CGFloat lineW = [UIScreen mainScreen].bounds.size.width;
    CGFloat lineH = 1.0f;
    self.lineImageF = CGRectMake(lineX, lineY, lineW, lineH);
    
    self.cellHeight = CGRectGetMaxY( self.lineImageF);
}


/**
*  计算文本的宽高
*
*  @param str     需要计算的文本
*  @param font    文本显示的字体
*  @param maxSize 文本显示的范围
*
*  @return 文本占用的真实宽高
*/
-(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
     NSDictionary *dict = @{NSFontAttributeName : font};
     // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
     // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
     CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
     return size;
 }
@end
