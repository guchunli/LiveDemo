//
//  GCLLiveModel.h
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCLCreatorModel.h"

@interface GCLLiveModel : NSObject

/*
 "id": "1482457970215865",
 "name": "",
 "city": "",
 "share_addr": "http://mlive8.inke.cn/share/live.html?uid=5565644&liveid=1482457970215865&ctime=1482457970",
 "stream_addr": "http://pull99.a8.com/live/1482457970215865.flv",
 "version": 0,
 "slot": 3,
 "optimal": 0,
 "online_users": 18413,
 "group": 0,
 "link": 0,
 "multi": 0,
 "rotate": 0
 */
//主播
@property (nonatomic,strong)GCLCreatorModel *creator;
//城市
@property (nonatomic,copy)NSString *city;
//主播流地址
@property (nonatomic,copy)NSString *stream_addr;
//关注人数
@property (nonatomic,assign)NSInteger online_users;

@end
