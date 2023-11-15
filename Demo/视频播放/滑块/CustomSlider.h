//
//  CustomSlider.h
//  pickfun
//
//  Created by Carl on 2021/7/30.
//

#import <UIKit/UIKit.h>
#define thumbBound_x 10

#define thumbBound_y 20

NS_ASSUME_NONNULL_BEGIN

@interface CustomSlider : UISlider

@property(nonatomic,assign)BOOL isSele;
@property (nonatomic, assign) CGRect  lastBounds;


@end

NS_ASSUME_NONNULL_END
