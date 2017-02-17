//
//  JPCommentHeaderView.h
//  category-listings
//
//  Created by 王战胜 on 2017/2/14.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SectionDelegate <NSObject>
//协议方法
-(void)AddOrDelete:(NSInteger)tag;
@end

@interface JPCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel * groupLabel;
@property (nonatomic, strong) UIImageView *groupImageV;
@property (nonatomic, strong) UIImageView *groupLeftV;
@property (nonatomic, weak) id<SectionDelegate>delegate;
@end
