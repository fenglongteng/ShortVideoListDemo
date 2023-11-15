//
//  VideoTableViewCell.m
//  Demo
//
//  Created by 冯龙腾 on 2023/11/13.
//

#import "VideoTableViewCell.h"








@implementation VideoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellView];
    }
    return self;
}

-(void)createCellView{
    
    /// 单击事件
    UITapGestureRecognizer * singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    singleTapGestureRecognizer.numberOfTapsRequired = 1;//单击
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    
    self.bgdImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.bgdImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.bgdImgV];
    [self.bgdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgdImgV setHidden:NO];

    
    ///视频播放页
    self.videoBgView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.videoBgView];
    [self.videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    /// 暂停/播放图标
    self.playImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.playImageView.image = [UIImage imageNamed:@"device_play"];
    [self.contentView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.playImageView.hidden = YES;

    self.headerImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.headerImgV];
    [self.headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    // 滑块
    self.slider = [[CustomSlider alloc]initWithFrame:CGRectMake(0, 0,APP_BOUNDS_SIZE.width, 16)];
    self.slider.userInteractionEnabled = YES;
    [self.slider addTarget:self action:@selector(sliderTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider setThumbImage:[UIImage imageNamed:@"video_slider_small_normal"] forState:0];
    [self.slider setThumbImage:[UIImage imageNamed:@"video_slider_small_selected"] forState:UIControlStateHighlighted];
    
    self.slider.maximumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.18];
    self.slider.minimumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.16];
    
    //最小值
    [self.slider setMinimumValue:0.0];
    //最大值
    [self.slider setMaximumValue:1.0];
    [self.contentView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(16);
    }];
    
    
    /// 播放进度view
    self.playScheduleView = [[PlayScheduleView alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(self.playImageView.frame) + 40, APP_BOUNDS_SIZE.width - 200, 60)];
    [self.playScheduleView setCenter:CGPointMake(APP_BOUNDS_SIZE.width / 2, APP_BOUNDS_SIZE.height / 2)];
    self.playScheduleView.layer.cornerRadius = 10;
    self.playScheduleView.hidden = YES;
    [self.contentView addSubview:self.playScheduleView];
    [self.playScheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.playImageView.mas_bottom).offset(40);
    }];
}

-(void)setData:(VideoModel *)model{
    self.bgdImgV.hidden = NO;
    [self.bgdImgV sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];

    ///头像
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];
    
}

#pragma mark - 单击事件
- (void)singleTap{
    [self.delegate cellClickSingleTap:self];
}

#pragma mark - 滑块手指开始出没
-(void)sliderTouchDown{
    NSLog(@"开始点击");
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    // 记录开始触摸滑动 slider内部进行宽高变化
    self.slider.isSele = YES;
    // 展示进度view
    self.playScheduleView.hidden = NO;
   
    
}

#pragma mark - 滑块手指滑动
-(void)sliderValueChanged:(id)aSender{
    //改变滑动value
    // 由于cell获取不到视频的长度 交予VC处理进度展示页面的展示数据变化
    [self.delegate cellSliderValueChanged:self];
}

#pragma mark - 滑块手指松开
-(void)sliderTouchUpInside{
    NSLog(@"结束滑动");
    self.slider.minimumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    // 记录停止触摸 slider内部进行宽高变化
    self.slider.isSele = NO;
    // 隐藏播放进度view
    self.playScheduleView.hidden = YES;
    
    //滑动停止 进行视频进度条转
    [self.delegate cellSliderTouchUpInside:self];
}

@end
