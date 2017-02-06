//
//  GCLCreatorModel.h
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCLCreatorModel : NSObject

/*
 "id": 5565644,
 "level": 69,
 "gender": 0,
 "nick": "波加漫☀️",
 "portrait": "http://img2.inke.cn/MTQ4MjE4ODE3NjQ0NiMzNCNqcGc=.jpg"
 */
//主播名
@property (nonatomic,copy)NSString *nick;
//主播头像
@property (nonatomic,copy)NSString *portrait;

@end
