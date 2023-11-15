//
//  HomeVideoModel.h
//  Demo
//
//  Created by 冯龙腾 on 2023/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject

/// 视频播放id
@property(nonatomic,copy) NSString *playId;

/// 视频封面
@property(nonatomic,copy,nullable) NSString *coverUrl;

/// 视频链接
@property(nonatomic,copy) NSString *url;



@end

NS_ASSUME_NONNULL_END
