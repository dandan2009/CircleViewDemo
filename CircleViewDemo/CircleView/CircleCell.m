//
//  CircleCell.m
//  gydmall
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 fec. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleInfo

@end

@interface CircleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation CircleCell

- (void)setCircleInfo:(CircleInfo *)circleInfo{
    _circleInfo = circleInfo;
    
    //判断是否是网络图片
    if ([circleInfo.image containsString:@"http://"] || [circleInfo.image containsString:@"https://"]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:circleInfo.image] placeholderImage:[UIImage imageNamed:kDefaultBigImage]];
    }else{
        _imgView.image = [UIImage imageNamed:circleInfo.image];
    }
    
    _titleLb.text = circleInfo.title;
    if (circleInfo.isHiddenTitle) {
        _titleView.hidden = YES;
    }else{
        _titleView.hidden = NO;
    }
}

@end
