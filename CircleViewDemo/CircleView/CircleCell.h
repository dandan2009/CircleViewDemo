//
//  CircleCell.h
//  gydmall
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 fec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@end


@interface CircleCell : UICollectionViewCell

@property (nonatomic, strong) CircleInfo *circleInfo;

@end
