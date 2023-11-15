//
//  PlayScheduleView.h
//  pickfun
//
//  Created by Carl on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayScheduleView : UIView

/// 进度
@property(nonatomic,assign) float schedule;

/// 时长
@property(nonatomic,assign) float duration;

@end

NS_ASSUME_NONNULL_END
