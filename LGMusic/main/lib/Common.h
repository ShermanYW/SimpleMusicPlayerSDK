//
//  Common.h
//  FeverMassageUnderwear
//
//  Created by go  on 15/12/17.
//  Copyright © 2015年 Sherman. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define UNIQU_FLAG @"LGMUSIC"

#define RELOAD_MUSIC_NAME_NOTI @"lg_reload"
#define RELOAD_MUSIC_OBJECT_NOTI @"lg_object"

#define ZeroFloat    0.0
#define HSFrame(x,y,W,H)  CGRectMake((x), (y), (W), (H))

#define COLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]

#define SCREENWIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT  ([UIScreen mainScreen].bounds.size.height)

#define ViewWidth  self.view.frame.size.width
#define ViewHeight  self.view.frame.size.height

#define JZNAVIGATION_BAR_MAX_Y CGRectGetMaxY(self.navigationController.navigationBar.frame)
#define DIFF_7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ? 0.0 : 20.0)//从ios6到ios7 y值的变化

//图片路径
#define IMAGE(string) [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:string ofType:@"png"]]

#ifdef DEBUG
#define HWLog(...) NSLog(__VA_ARGS__)
#else
#define HWLog(...)
#endif

#define DBPATH   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"DATABASE.db"]  //数据库路径


//字体比例

#define FontRate1 (IPhone5? 1.0000:(IPhone6? 1.1 :(IPhone6p? 1.2 : 1.0000)))

#define FontRate2 (IPhone5? 1.0000:(IPhone6? 1.2 :(IPhone6p? 1.4 : 1.0000)))

#define FontRate3 (IPhone5? 1.0000:(IPhone6? 1.3 :(IPhone6p? 1.6 : 1.0000)))

//字体大小
#define FONTSIZE(A,class) (A) * ( (class == 1) ? FontRate1:((class == 2)? FontRate2:FontRate3));

//用分辨率除
#define ScaleWide (IPhone5 ? 1.0000 : (IPhone6 ? 1.1718 :(IPhone6p ? 1.2937 : 1.0000)))
#define WIDTH(W)   ScaleWide * W

#define ScaleHighHS (IPhone5 ? 1.0000 : (IPhone6 ? 1.1743 :(IPhone6p ? 1.2958 : 0.85)))
#define HEIGHT(H)    ScaleHigh * H



#endif /* Common_h */
