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

#### 初始化播放源，block回调当前音乐标题，歌手，是否成功等信息

`[[LGMusicPlayer sharedLGMusicPlayer] configureMusics:[[LGMusicManager sharedMusicManager] selectAllMusics] musicInfos:^(NSMutableDictionary *musicInfos, BOOL success) { }]`

#### 设置播放循环, block回调当前循环模式

`[[LGMusicPlayer sharedLGMusicPlayer]  playConfigLoopCurrentType:^(MusicLoopType type) {  }]`
 
 #### 播放上一首,block回调当前音乐信息
 
 `[[LGMusicPlayer sharedLGMusicPlayer] playBack:^(NSMutableDictionary *musicInfos, BOOL success) {  }];`
 
 #### 播放，block回调播放完成后操作
 `[[LGMusicPlayer sharedLGMusicPlayer] playStart:^{ }];`
 
 #### 暂停，block回调暂停完成
 `[[LGMusicPlayer sharedLGMusicPlayer] playPause:^{ }]`
 
 #### 播放下一首，block回调是否成功以及歌曲相关信息
  `[[LGMusicPlayer sharedLGMusicPlayer] playNext:^(NSMutableDictionary *musicInfos, BOOL success) {  }];`

 #### 定时读取音乐当前播放进度, block回调是否成功以及音乐相关信息
 `[[LGMusicPlayer sharedLGMusicPlayer] readSongPandAndProgress:^(NSMutableDictionary *musicInofs, BOOL success) {  }]`
 
 
![](https://github.com/ShermanYW/SimpleMusicPlayerSDK/raw/master/Exsample/Images/IMG_3145.PNG)  
![](https://github.com/ShermanYW/SimpleMusicPlayerSDK/raw/master/Exsample/Images/IMG_3146.PNG)  


