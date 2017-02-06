//
//  GCLLiveViewController.m
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GCLLiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface GCLLiveViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation GCLLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.liveData.creator.portrait] placeholderImage:nil];
    
    //
//    NSURL *liveUrl = [NSURL URLWithString:_liveData.stream_addr];
    IJKFFMoviePlayerController *playerCtrl = [[IJKFFMoviePlayerController alloc]initWithContentURLString:_liveData.stream_addr withOptions:nil];
    
    //
    [playerCtrl prepareToPlay];
    
    //强引用，防止被销毁
    _player = playerCtrl;
    
    playerCtrl.view.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:playerCtrl.view atIndex:1];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_player pause];
    [_player stop];
    [_player shutdown];
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
