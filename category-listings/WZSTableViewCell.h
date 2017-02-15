//
//  WZSTableViewCell.h
//  category-listings
//
//  Created by 王战胜 on 2017/2/15.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray * detailArr;
- (void)createButton;
@end
