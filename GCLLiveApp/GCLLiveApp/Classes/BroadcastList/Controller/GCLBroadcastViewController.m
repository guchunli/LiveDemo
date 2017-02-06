//
//  GCLBroadcastViewController.m
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GCLBroadcastViewController.h"
#import "GCLLiveViewController.h"
#import "GCLLiveModel.h"
#import "GCLLiveCell.h"

@interface GCLBroadcastViewController ()

@property (nonatomic,strong)NSMutableArray *lives;

@end

static NSString * const broadcastCell = @"broadcastCell";
@implementation GCLBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"直播列表";
    
    // 加载数据
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GCLLiveCell" bundle:nil] forCellReuseIdentifier:broadcastCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData
{
    // 映客数据url
    NSString *urlStr = YKURLStr;
    
    // 请求数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        self.lives = [GCLLiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.lives.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GCLLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:broadcastCell forIndexPath:indexPath];
    if (self.lives) {
        cell.model = self.lives[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GCLLiveViewController *liveVc = [[GCLLiveViewController alloc]init];
    if (self.lives) {
        liveVc.liveData = self.lives[indexPath.row];
    }
    [self presentViewController:liveVc animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 430;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
