//
//  WZSTableViewCell.m
//  category-listings
//
//  Created by 王战胜 on 2017/2/15.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import "WZSTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UICOLOR_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@implementation WZSTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor=UICOLOR_RGBA(240, 240, 240, 1);
    }
    return self;
}

- (void)createButton{
    for (NSInteger i=0; i<_detailArr.count; i++) {
        NSInteger a=i%3;
        NSInteger b=i/3;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-40)/3+10)*a, 10+50*b, (SCREEN_WIDTH-40)/3, 40)];
        btn.backgroundColor=[UIColor whiteColor];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitle:_detailArr[i][@"t"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.1 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"跳转到关于%@的界面",btn.titleLabel.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
