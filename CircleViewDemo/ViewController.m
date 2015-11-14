//
//  ViewController.m
//  CircleViewDemo
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "CircleView/CircleView.h"

@interface ViewController ()<CircleViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (nonatomic, strong) NSMutableArray *circleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _circleArr = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        CircleInfo *circleInfo = [[CircleInfo alloc] init];
        circleInfo.title = [NSString stringWithFormat:@"%zd",i+1];
        circleInfo.image = [NSString stringWithFormat:@"home%zd",i+1];
        [_circleArr addObject:circleInfo];
    }
    
    CircleView *circleView = [CircleView circleView];
    circleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _circleView.bounds.size.height);
    circleView.circleInfoArrM = _circleArr;
    [_circleView addSubview:circleView];
}

#pragma mark- 点击轮播图片代理方法
- (void)circleView:(CircleView *)circleView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
