//
//  CircleView.h
//  gydmall
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 fec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCell.h"

@class CircleView;

@protocol CircleViewDelegate <NSObject>

- (void) circleView:(CircleView *) circleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CircleView : UIView
//属性
@property (nonatomic, strong) NSMutableArray *circleInfoArrM;//这个数组中存放的是CircleInfo对象
@property (nonatomic, weak) id<CircleViewDelegate> delegate;

//方法
+ (instancetype) circleView;

@end
