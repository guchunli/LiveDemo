//
//  GCLLiveCell.m
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GCLLiveCell.h"
#import "GCLCreatorModel.h"

@interface GCLLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;

@end

@implementation GCLLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.photoImgView.layer.cornerRadius = 5;
    self.photoImgView.layer.masksToBounds = YES;
    
    self.liveLabel.layer.cornerRadius = 5;
    self.liveLabel.layer.masksToBounds = YES;
}

-(void)setModel:(GCLLiveModel *)model{

    _model = model;
    
    NSURL *imageUrl = [NSURL URLWithString:model.creator.portrait];
    
    //主播头像
    [self.photoImgView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    //主播名
    self.nickLabel.text = model.creator.nick;
    
    //
    if (model.city.length <= 0) {
        self.addressLabel.text = @"难道是在火星？";
    }else{
        self.addressLabel.text = model.city;
    }
    [self.bigImageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    //用户人数
    NSString *fullNum;
    if (model.online_users >= 10000) {
        fullNum = [NSString stringWithFormat:@"%.2f万人在看",(float)model.online_users/10000];
    }else{
        fullNum = [NSString stringWithFormat:@"%ld人在看",model.online_users];
    }
    NSDictionary *attr = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:13],
                           NSForegroundColorAttributeName:Color(216, 41, 116)
                           };
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:fullNum attributes:attr];
    self.userNumLabel.attributedText = attrString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
