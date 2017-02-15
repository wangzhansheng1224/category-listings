//
//  ViewController.m
//  category-listings
//
//  Created by 王战胜 on 2017/2/13.
//  Copyright © 2017年 gocomtech. All rights reserved.
//

#import "ViewController.h"
#import "JPCommentHeaderView.h"
#import "WZSTableViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UICOLOR_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SectionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) NSArray *classifyArr;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation ViewController
static NSString * const JPHeaderId = @"header";
static NSString * const WZSCell = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"全部分类";
    _detailArr=@[@"牛肉",@"排骨",@"鸡肉",@"苹果",@"西红柿",@"黄瓜",@"豌豆",@"茄子",@"糯米",@"羊肉",@"南瓜",@"茭白",@"山楂",@"毛豆",@"芋头",@"土豆"];
    _classifyArr=@[@"时令食材",@"热门",@"口味",@"蔬菜",@"肉类",@"水产",@"主食",@"菜系",@"神奇芝士",@"烘焙天堂",@"母婴专区",@"食疗养生",@"美容瘦身",@"蛋奶豆制品",@"水果干果",@"米面杂粮",@"烹饪方法及工具"];
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=UICOLOR_RGBA(240, 240, 240, 1);
    [self.view addSubview:self.tableView];
    //注册自定义组头
    [self.tableView registerClass:[JPCommentHeaderView class] forHeaderFooterViewReuseIdentifier:JPHeaderId];
    //注册自定义Cell
    [self.tableView registerClass:[WZSTableViewCell class] forCellReuseIdentifier:WZSCell];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    for (NSInteger i=0; i<_selectedArr.count; i++) {
        if (section==[_selectedArr[i] integerValue]) {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (_detailArr.count/3+1)*50+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WZSCell];
    cell.detailArr=_detailArr;
    [cell createButton];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JPCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:JPHeaderId];
    header.groupLabel.text=_classifyArr[section];
    header.tag=section;
    header.delegate=self;
    return header;
}

-(void)AddOrDelete:(NSInteger)tag andselected:(BOOL)selected{
    NSNumber *objNum = [NSNumber numberWithInteger:tag];
    if (selected) {
        [self.selectedArr addObject:objNum];
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:tag];
        [rowToInsert addObject:indexPathToInsert];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }else{
        [self.selectedArr removeObject:objNum];
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:tag];
        [rowToInsert addObject:indexPathToInsert];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr=[[NSMutableArray alloc]init];
    }
    return _selectedArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
