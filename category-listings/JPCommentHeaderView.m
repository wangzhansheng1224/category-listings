//
//  JPCommentHeaderView.m
//  category-listings
//
//  Created by 王战胜 on 2017/2/14.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import "JPCommentHeaderView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation JPCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _groupLeftV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _groupLeftV.center=CGPointMake(35, 35);
        [self.contentView addSubview:_groupLeftV];
        
        _groupLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_groupLeftV.frame)+10, 0, SCREEN_WIDTH, 70)];
        _groupLabel.font=[UIFont systemFontOfSize:17];
        _groupLabel.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        [self.contentView addSubview:_groupLabel];
        
        _groupImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 8)];
        _groupImageV.image=[UIImage imageNamed:@"catalogs_arrow"];
        _groupImageV.center=CGPointMake(SCREEN_WIDTH-20, 35);
        [self.contentView addSubview:_groupImageV];
        
        UIImageView *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69.5, SCREEN_WIDTH, 0.5)];
        lineImageV.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
        [self.contentView addSubview:lineImageV];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
        [self.contentView addGestureRecognizer:tapGR];
    }
    return self;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform currentTransform = _groupImageV.transform;
        // 在现在的基础上旋转指定角度
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI);
        _groupImageV.transform = newTransform;

    }];

//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//        CGAffineTransform currentTransform = _groupImageV.transform;
//        // 在现在的基础上旋转指定角度
//        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI);
//        _groupImageV.transform = newTransform;
//    }completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(AddOrDelete:)]){
        [self.delegate AddOrDelete:self.tag];
    }
}

@end
