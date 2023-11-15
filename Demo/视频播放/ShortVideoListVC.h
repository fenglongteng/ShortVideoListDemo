//
//  ShortVideoListVC.h
//  pickfun
//
//  Created by Carl on 2021/8/26.
// 参考阿里短视频参考： https://help.aliyun.com/zh/vod/developer-reference/basic-features-2?spm=a2c4g.11186623.0.nextDoc.5f7b15fcgJRu56

// 版本对应   pod 'AliPlayerSDK_iOS', '~> 5.4.4.0'

#import <UIKit/UIKit.h>
#import <AliyunPlayer/AliyunPlayer.h>

#import "VideoTableViewCell.h"




NS_ASSUME_NONNULL_BEGIN

/// 所有视频播放的父类 写了一些视频播放的相关方法
@interface ShortVideoListVC : UIViewController<UIScrollViewDelegate,AVPDelegate>

/// 播放器
@property (nonatomic, strong) AliListPlayer  *player;


/// 当前选中model
@property(nonatomic,strong,nullable)VideoModel *currentModel;
 

/// 当前选中cell
@property(nonatomic,strong,nullable)VideoTableViewCell *currentCell;

/// 当前选中下标
@property(nonatomic,assign)NSInteger currentIndex;

/// 用户手动暂停播放
@property(nonatomic,assign)BOOL accordPausePlay;

/// 没有更多的时候显示hud提示框
@property(nonatomic,assign)BOOL noneMoreShowHud;

/// 记录已播放时长
@property(nonatomic,assign)int64_t recordPlayTime;


@property(nonatomic,assign)NSInteger page;


#pragma mark - 暂停播放
-(void)pausePlay;

#pragma mark - 继续播放
-(void)replay;

@end

NS_ASSUME_NONNULL_END
