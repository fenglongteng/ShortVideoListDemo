//
//  VideoTableViewCell.h
//  Demo
//
//  Created by 冯龙腾 on 2023/11/13.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <SDWebImage/SDWebImage.h>


#import "PlayScheduleView.h"
#import "CustomSlider.h"

//尺寸
#define APP_BOUNDS_SIZE [UIScreen mainScreen].bounds.size

//weakself
#define WeakSelf __weak typeof(self) weakSelf = self

@protocol PlayCellDelegate <NSObject>

@optional

/// 单击事件
-(void)cellClickSingleTap:(UITableViewCell*)cell;

/// 双击事件
-(void)cellClickDoubleTap:(UITableViewCell*)cell;

/// 手指滑动
-(void)cellSliderValueChanged:(UITableViewCell*)cell;

/// 手指滑动结束
-(void)cellSliderTouchUpInside:(UITableViewCell*)cell;

/// 点击头像
-(void)cellClickProfileButton:(UITableViewCell*)cell;





@end


NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewCell : UITableViewCell

@property (nonatomic,weak) id <PlayCellDelegate> delegate;

/// 播放器地板view
@property(nonatomic,strong) UIView *videoBgView;

/// 用户头像
@property(nonatomic,strong) UIImageView *headerImgV;

/// 背景封面图片，用于预加载的时候显示
@property(nonatomic,strong) UIImageView *bgdImgV;

/// 播放标志
@property(nonatomic,strong) UIImageView *playImageView;

/// 滑块
@property(nonatomic,strong) CustomSlider *slider;

/// 播放进度view
@property(nonatomic,strong) PlayScheduleView *playScheduleView;


/// 赋值方法
-(void)setData:(VideoModel *)model;

@end

NS_ASSUME_NONNULL_END




