# SimpleMusicPlayerSDK

## A simple music player for iOS app. 
## 一个简单的iOS音乐播放器： 

### 支持功能：
- 播放/暂停
- 上一首/下一首
- 单曲循环/随机播放/循环播放
- 添加本地歌曲存入数据库，可以删除已存放歌曲 

#### 代码使用：
`import "LGMusicPlayer.h"`

#### 初始化播放源
`[[LGMusicPlayer sharedLGMusicPlayer] configureMusics:[[LGMusicManager sharedMusicManager] selectAllMusics] musicInfos:^(NSMutableDictionary *musicInfos, BOOL success) { 
    }];`
    
    
    
![](https://github.com/ShermanYW/SimpleMusicPlayerSDK/raw/master/Exsample/Images/IMG_3145.PNG)  
![](https://github.com/ShermanYW/SimpleMusicPlayerSDK/raw/master/Exsample/Images/IMG_3146.PNG)  


