//
//  PlayScheduleView.m
//  pickfun
//
//  Created by Carl on 2021/8/3.
//

#import "PlayScheduleView.h"

@interface PlayScheduleView()

/// 当前进度label
@property(nonatomic,strong)UILabel *presentLabel;

/// 总进度label
@property(nonatomic,strong)UILabel *totalLabel;

@property(nonatomic,strong)UILabel *centerLabel;

@end
@implementation PlayScheduleView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self createView];
    }
    return self;
}

-(void)createView{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    self.presentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2 - 10, self.frame.size.height)];
    self.presentLabel.textColor = [UIColor whiteColor];
    self.presentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.presentLabel];
    
    
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 10, 0, self.frame.size.width / 2 - 10, self.frame.size.height)];
    self.totalLabel.textColor = [UIColor whiteColor];
    self.totalLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.totalLabel];

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 10, 0, 20, self.frame.size.height)];
    label.text = @"/";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.centerLabel = label;
    [self addSubview:label];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.presentLabel.frame = CGRectMake(0, 0, self.frame.size.width / 2 - 10, self.frame.size.height);
    self.totalLabel.frame = CGRectMake(self.frame.size.width / 2 + 10, 0, self.frame.size.width / 2 - 10, self.frame.size.height);
    self.centerLabel.frame = CGRectMake(self.frame.size.width / 2 - 10, 0, 20, self.frame.size.height);
}


-(void)setSchedule:(float)schedule{
    _schedule = schedule;
    [self changeText];

}


-(void)setDuration:(float)duration{
    _duration = duration;
    [self changeText];
}


/// 改变文字
-(void)changeText{
    self.presentLabel.text = [NSString stringWithFormat:@"%d:%.2d",(int)(_schedule * _duration / 1000 / 60),(int)(_schedule * _duration / 1000) % 60];
    self.totalLabel.text = [NSString stringWithFormat:@"%d:%.2d", (int)(_duration / 1000 / 60),  (int)(_duration / 1000) % 60];
}


@end
