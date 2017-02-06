//
//  GCLMainViewController.m
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GCLMainViewController.h"
#import "GCLCaptureViewController.h"
#import "GCLBroadcastViewController.h"

@interface GCLMainViewController ()

@end

@implementation GCLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"直播功能";
}
//采集视频
- (IBAction)captureVideo:(id)sender {
    
    GCLCaptureViewController *captureVc = [[GCLCaptureViewController alloc]init];
    [self.navigationController pushViewController:captureVc animated:YES];
}
//主播列表
- (IBAction)playVideo:(id)sender {
    
    GCLBroadcastViewController *broadcastVc = [[GCLBroadcastViewController alloc]init];
    [self.navigationController pushViewController:broadcastVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
