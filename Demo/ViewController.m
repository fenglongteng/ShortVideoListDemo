//
//  ViewController.m
//  Demo
//
//  Created by 冯龙腾 on 2023/11/13.
//

#import "ViewController.h"

#import "ShortVideoListVC.h"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShortVideoListVC *vc = [ShortVideoListVC new];
    [self addChildViewController:vc];
    
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
}


@end
