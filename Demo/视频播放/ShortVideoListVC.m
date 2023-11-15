//
//  ShortVideoListVC.m
//  pickfun
//
//  Created by Carl on 2021/7/6.
//  弱网络环境有： 准备中，准备完成，加载中，加载完成  这几个确实的ui提示

#import "ShortVideoListVC.h"
#import "ShortVideoListVC.h"


@interface ShortVideoListVC ()<UITableViewDelegate,UITableViewDataSource,PlayCellDelegate>


@property(nonatomic,strong)UITableView *tableView;

/// 数据源
@property(nonatomic,strong)NSMutableArray *dataArray;

///播放状态
@property(nonatomic,assign)AVPStatus playStatus;

@end

@implementation ShortVideoListVC


//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

#pragma mark - 生命周期函数 页面即将显示
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - 生命周期函数 页面已经显示
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

#pragma mark - 生命周期函数 页面即将消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


#pragma mark - 生命周期函数 页面已经消失
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 停止所有延时方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // 页面消失就暂停播放
    [self pausePlay];
    
}


#pragma mark - 页面加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createPlayView];
    
    self.page = 1;
    [self getListData];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"其他控制器" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(pushOtherVC) forControlEvents:UIControlEventTouchUpInside];
    [bt sizeToFit];
    [self.view addSubview:bt];
    bt.frame = CGRectMake(200, 20, 150, 50);
}


-(void)pushOtherVC{
    UINavigationController *naVi = self.navigationController;
    [naVi pushViewController:[UIViewController new] animated:YES];

}

#pragma mark - 创建表格
-(void)createTableView{
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.scrollsToTop = NO;
    self.tableView.rowHeight = self.view.frame.size.height;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    
}




#pragma mark - 创建播放器
-(void)createPlayView{
    
    self.player = [[AliListPlayer alloc] init];
    self.player.delegate = self;
    self.player.autoPlay = YES;//自动播放
    self.player.enableHardwareDecoder = YES;//开启硬解码
    self.player.preloadCount = 3;//设置预加载的个数
    self.player.loop = YES;//循环播放
    
    [self.player setVideoBackgroundColor:[UIColor clearColor]];
    [AliListPlayer setEnableLog:NO];
    AVPCacheConfig *cacheConfig = [[AVPCacheConfig alloc] init];
    cacheConfig.enable = YES;//开启缓存功能
    cacheConfig.maxDuration = 100;//能够缓存的单个文件最大时长。超过此长度则不缓存
    cacheConfig.path = NSTemporaryDirectory (); //缓存目录的位置，需替换成app期望的路径
    cacheConfig.maxSizeMB = 400;//缓存目录的最大大小。超过此大小，将会删除最旧的缓存文件
    //设置缓存配置给到播放器
    [self.player setCacheConfig:cacheConfig];
    
    AVPConfig *config = [[AVPConfig alloc] init];
    config.clearShowWhenStop = NO;//设置停止播放不保留最后一帧
    config.networkRetryCount = 5;//网络重试次数 5
    [self.player setConfig:config];
    
}


#pragma mark - 添加监听者
-(void)addListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenVideoDataChangeWithModel:) name:@"video_data_change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenFollowStateChangeWithModel:) name:@"follow_state_change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayTaskFinish) name:@"play_task_finish" object:nil];
    
}




#pragma mark - 暂停播放
-(void)pausePlay{
    [self.player pause];
    self.player.autoPlay = NO;
}

#pragma mark - 继续播放
-(void)replay{
    // 如果不是用户手动进行的暂停 就继续播放视频
    if (!self.accordPausePlay) {
        self.player.autoPlay = YES;
        [self.player start];
    }
}




#pragma mark - 代理方法 填充cell
- (VideoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableViewCell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    VideoModel *model = self.dataArray[indexPath.row];
    [cell setData:model];
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}




#pragma mark - 代理方法 返回cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MAX(APP_BOUNDS_SIZE.width, APP_BOUNDS_SIZE.height);
    
}




#pragma mark - 代理方法 cell已经离开屏幕
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - 代理方法 cell 即将离开屏幕
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}





#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tableView) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
            //首先 UITableView禁止响应其他滑动手势
            scrollView.panGestureRecognizer.enabled = NO;
            
            // 如果无数据 不处理
            if (self.currentIndex > self.dataArray.count || self.dataArray.count == 0) {
                scrollView.panGestureRecognizer.enabled = YES;
                return;
            }
            
            
            NSInteger page = 0;
            
            // 由下往上滑动 查看下一个 但是没有下一个了
            if (translatedPoint.y < -60 && self.currentIndex >= self.dataArray.count - 1 && self.noneMoreShowHud) {
                NSLog(@"没有更多了");
            }
            
            // 由下往上滑动 查看下一个
            if(translatedPoint.y <= -60 && self.currentIndex < self.dataArray.count - 1) {
                self.currentIndex ++;   //向下滑动索引递增
                page = 1;
            }
            
            // 由上往下滑动 查看下上个 同时有上一个的情况下 查看上一个
            if(translatedPoint.y >= 60 && self.currentIndex > 0) {
                page = -1;
                self.currentIndex --;   //向上滑动索引递减
            }
            
            // 当当前下标已经到了 最后2个的时候 请求下一页数据
            if (self.currentIndex >= self.dataArray.count - 2 && self.page > 1) {
                [self getListData];
            }
            
            if (page == 0) {
                // page = 0 不进行上下翻页操作
                [UIView animateWithDuration:0.2
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseOut animations:^{
                    //滑动回原本的位置
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                } completion:^(BOOL finished) {
                    scrollView.panGestureRecognizer.enabled = YES;
                }];
            }else{
                
                
                /// 切换视频 取消所有延时执行方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                
                
                if (page == 1) {
                    [self.player moveToNext];
                }
                if (page == -1) {
                    [self.player moveToPre];
                }
                
                
                // 查看上一个或者下一个 进行翻页
                [UIView animateWithDuration:0.2
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseOut animations:^{
                    //UITableView滑动到指定cell
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                } completion:^(BOOL finished) {
                    //顺序播放视频
                    [self orderPlayVideo];
                    scrollView.panGestureRecognizer.enabled = YES;
                    
                }];
            }
        });
    }
}


#pragma mark - 顺序播放视频
-(void)orderPlayVideo{
    // 重置统计的 播放时间
    // 打开自动播放
    self.player.autoPlay = YES;
    self.currentModel = self.dataArray[self.currentIndex];
    self.currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [self.currentCell setData:self.currentModel];
    self.player.playerView = self.currentCell.videoBgView;
}






#pragma mark - 播放器 错误代理回调
/**
 @brief 错误代理回调
 @param player 播放器player指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
    //提示错误，及stop播放
    NSLog(@"错误 ------- 错误:%@",errorModel.message);
    /// 当前视频404错误 跳过当前视频 播放下一个
    if (errorModel.code == ERROR_NETWORK_HTTP_404) {
        if (self.dataArray.count - 1  > self.currentIndex) {
            NSLog(@"视频异常，已为您自动跳过");
            self.currentIndex ++;   //向下滑动索引递增
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            //            [self.player stop];
            [self.player moveToNext];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self orderPlayVideo];
            
        }
    }
}

#pragma mark - 播放器事件回调

- (void)onPlayerStatusChanged:(AliPlayer*)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    self.playStatus = newStatus;
    
    switch (newStatus) {
        case AVPStatusIdle:{
            // 空转，闲时，静态
        }
            break;
        case AVPStatusInitialzed:{
            // 初始化完成
        }
            break;
        case AVPStatusPrepared:{
            // 准备完成
        }
            break;
        case AVPStatusStarted:{
            // 正在播放
        }
            break;
        case AVPStatusPaused:{
            // 播放暂停
        }
            break;
        case AVPStatusStopped:{
            // 播放停止
        }
            break;
        case AVPStatusCompletion:{
            // 播放完成
        }
            break;
        case AVPStatusError:{
            // 播放错误
        }
            break;
        default:
            break;
    }
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventType 播放器事件类型，@see AVPEventType
 */
-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone: {
            // 准备完成
            NSLog(@"准备完成");
        }
            break;
        case AVPEventAutoPlayStart:
            // 自动播放开始事件
            NSLog(@"自动播放开始");
            break;
        case AVPEventFirstRenderedStart:
            NSLog(@"首帧展示");
            // 首帧显示
            break;
        case AVPEventCompletion:
            // 播放完成
            NSLog(@"播放完成");
            break;
        case AVPEventLoadingStart:
            // 缓冲开始
            NSLog(@"缓冲开始");
            break;
        case AVPEventLoadingEnd:
            // 缓冲完成
            NSLog(@"缓冲完成");
            break;
        case AVPEventSeekEnd:
            // 跳转完成
            NSLog(@"拖动进度完成");
            break;
        case AVPEventLoopingStart:
            // 循环播放开始
            NSLog(@"开始循环播放");
            self.recordPlayTime = self.player.duration;
            break;
        default:
            break;
    }
}

-(void)onPlayerEvent:(AliPlayer*)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description{
    NSLog(@"AliPlayer事件:%ld,description:%@",eventWithString,description);
}

#pragma mark - 视频当前播放位置回调

/**
 @brief 视频当前播放位置回调
 @param player 播放器player指针
 @param position 视频当前播放位置
 */
- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    // 更新进度条
    if (!self.currentCell.slider.isSele) {
        self.currentCell.slider.value = (float)position / (float)player.duration;
    }
    // 记录当前播放时间
    if (self.recordPlayTime < position) {
        self.recordPlayTime = position;
    }
    self.currentCell.bgdImgV.hidden = self.currentCell.slider.value > 0.05;
    
}



#pragma mark - 请求列表之后的数据 处理
// 父类实现 子类就不用写了 类似的页面有很多
-(void)getListDataNextHandle:(NSArray *)resultsObject{
    WeakSelf;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    // 下拉刷新
    if (!self.tableView.mj_header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf getListData];
        }];
    }
    // 上拉加载
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf getListData];
        }];
    }
    
    // 说明是第一次加载或者下拉刷新
    if (self.page == 1) {
        // 可以直接把dataArray初始化数据
        self.dataArray = [VideoModel mj_objectArrayWithKeyValuesArray:resultsObject];
        [self.player clear];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            VideoModel *model = self.dataArray[i];
            /// 播放器是使用uid来播放 保证视频唯一 所以就把视频ID+一个随机8位字符 本地处理区分
            [self.player addUrlSource:model.url uid:model.playId];
        }
        [self playFirst];
    }else{
        // 不是第一次刷新数据 在dataArray后面进行数据添加
        NSMutableArray *tempArr = [VideoModel mj_objectArrayWithKeyValuesArray:resultsObject];
        for (int i = 0; i < tempArr.count; i++) {
            VideoModel *model = tempArr[i];
            /// 播放器是使用uid来播放 保证视频唯一 所以就把视频ID+一个随机8位字符 本地处理区分
            [self.dataArray addObject:model];
            [self.player addUrlSource:model.url uid:model.playId];
        }
    }
    // 本次加载有数据 页数就+1
    if ([resultsObject count] > 0) {
        self.page++;
    }else{
        // 如果本次加载数据不足一页 说明下面没数据了 就展示无更多数据
        if ([resultsObject count] < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    
    // 刷新
    [self.tableView reloadData];
    
    
}


#pragma mark - 播放第一个视频
/// 播放第一个视频
-(void)playFirst{
    [self.tableView reloadData];
    if(self.currentIndex < 0){
        self.currentIndex = 0;
    }
    if (!self.currentIndex) {
        self.currentIndex = 0;
    }
    if (self.dataArray.count == 0) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    // 根据下标初始化当前选中的model
    self.currentModel = [self.dataArray objectAtIndex:self.currentIndex];
    // 根据下表初始化当前选中的cell
    self.currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    
    // 再把当前cell的播放器底板 设置成播放器的播放底板
    self.player.playerView = self.currentCell.videoBgView;
    
    // cell填充数据
    [self.currentCell setData:self.currentModel];
    
    // 播放器开始播放
    [self.player moveTo:self.currentModel.playId];
}

#pragma mark - 继续请求刷新数据方法
-(void)getListData{
    ///根据page请求每一页的数据
    ///
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dic0 = @{@"playId":@"0",@"coverUrl":@"https://img.pick-fun.com.cn/app/image/8a8080d58b6f0e06018bc41aff1d135e.jpg",@"url":@"https://img.pick-fun.com.cn/editor/2023/11/12/video/1723721426448474114/1723721426448474114.mp4"};
        NSDictionary *dic1 = @{@"playId":@"1",@"coverUrl":@"https://img.pick-fun.com.cn/editor/2023/11/12/video-compiled/1723613789806194690/1723613789806194690.mp4?x-oss-process=video/snapshot,t_2,f_jpg,w_0,h_0,m_fast",@"url":@"https://img.pick-fun.com.cn/editor/2023/11/12/video-compiled/1723613789806194690/1723613789806194690.mp4"};
        NSDictionary *dic2 = @{@"playId":@"2",@"coverUrl":@"https://img.pick-fun.com.cn/editor/2023/11/13/video-compiled/1723945445477933058/1723945445477933058.mp4?x-oss-process=video/snapshot,t_2,f_jpg,w_0,h_0,m_fast",@"url":@"https://img.pick-fun.com.cn/editor/2023/11/13/video-compiled/1723945445477933058/1723945445477933058.mp4"};
        NSDictionary *dic3 = @{@"playId":@"3",@"coverUrl":@"https://img.pick-fun.com.cn/editor/2023/11/13/video-compiled/1723982456704294913/1723982456704294913.mp4?x-oss-process=video/snapshot,t_2,f_jpg,w_0,h_0,m_fast",@"url":@"https://img.pick-fun.com.cn/editor/2023/11/13/video-compiled/1723982456704294913/1723982456704294913.mp4"};
        NSDictionary *dic4 = @{@"playId":@"4",@"coverUrl":@"https://img.pick-fun.com.cn/app/image/8a8080d58bc671b8018bc7fab338008f.jpg",@"url":@"https://img.pick-fun.com.cn/editor/2023/11/13/video/1723994030371561474/1723994030371561474.mp4"};
        
        [self  getListDataNextHandle: @[dic0,dic1,dic2,dic3,dic4]];
    });
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];

}



#pragma mark - 单击事件
-(void)cellClickSingleTap:(VideoTableViewCell*)cell{
    if(self.playStatus == AVPStatusStarted){
        [self.player pause];
        [cell.playImageView setHidden:NO];
        
        // 记录下 是用户手动点击的暂停 从其他页面回来 不进行自动恢复播放
        self.accordPausePlay = YES;
        
    }else{
        [self.player start];
        self.currentCell.playImageView.hidden = YES;
        
        // 将用户手动点击暂停的行为取消记录
        self.accordPausePlay = NO;
    }
}

#pragma mark -  进度条 手指滑动
-(void)cellSliderValueChanged:(VideoTableViewCell*)cell{
    /// cell内部无法获取到视频时长 所以在VC通过获取cell的成员变量的形式 更改页面展示
    cell.playScheduleView.schedule = cell.slider.value;
    cell.playScheduleView.duration = self.player.duration;
}

#pragma mark -  进度条 手指滑动结束
-(void)cellSliderTouchUpInside:(VideoTableViewCell*)cell{
    /// 根据slider.value 跳转到相应的位置
    [self.player seekToTime:self.player.duration * cell.slider.value seekMode:AVP_SEEKMODE_ACCURATE];
}



#pragma mark - 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setTableFooterView:[[UIView alloc]init]];
        _tableView.estimatedRowHeight = 0;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



@end
