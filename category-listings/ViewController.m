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
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UICOLOR_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SectionDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) NSArray *classifyArr;
@property (nonatomic, assign) NSInteger LastNum;
@property (nonatomic, assign) NSInteger NowNum;
@property (nonatomic, assign) BOOL first;
@end

static NSString * const JPHeaderId = @"header";

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"全部分类";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RecipesCatalog" ofType:@"plist"];
    _classifyArr = [NSArray arrayWithContentsOfFile:plistPath][0];
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=UICOLOR_RGBA(240, 240, 240, 1);
    [self.view addSubview:self.tableView];
    //注册自定义组头
    [self.tableView registerClass:[JPCommentHeaderView class] forHeaderFooterViewReuseIdentifier:JPHeaderId];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_first) {
        if (_NowNum-1000==section) {
            return 1;
        }
    }else{
        if (_NowNum==_LastNum) {
            return 0;
        }else{
            if (section==_NowNum-1000) {
                return 1;
            }
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *abc=_classifyArr[indexPath.section][@"tags"];
    return ((abc.count-1)/3+1)*50+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",indexPath.section,indexPath.row];//以indexPath来唯一确定cell
    
    WZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WZSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.detailArr=_classifyArr[indexPath.section][@"tags"];
    [cell createButton];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JPCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:JPHeaderId];
    header.groupLabel.text=_classifyArr[section][@"name"];
    NSString *url=_classifyArr[section][@"icon_f"];
    [header.groupLeftV sd_setImageWithURL:[NSURL URLWithString:url]];
    header.tag=section+1000;
    header.delegate=self;
    return header;
}

-(void)AddOrDelete:(NSInteger)tag{
    _NowNum=tag;
    if (!_first) {
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToInsert addObject:indexPathToInsert];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        _LastNum=_NowNum;
        _first=YES;
        return;
    }
    if (_NowNum==_LastNum) {
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToInsert addObject:indexPathToInsert];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        _first=NO;
    }else{
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToInsert addObject:indexPathToInsert];
        
        NSMutableArray* rowToInsert2 = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert2 = [NSIndexPath indexPathForRow:0 inSection:_LastNum-1000];
        [rowToInsert2 addObject:indexPathToInsert2];
        
        JPCommentHeaderView *header = [self.view viewWithTag:_LastNum];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = header.groupImageV.transform;
            // 在现在的基础上旋转指定角度
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI);
            header.groupImageV.transform = newTransform;
        }completion:nil];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView deleteRowsAtIndexPaths:rowToInsert2 withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        _LastNum=_NowNum;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
