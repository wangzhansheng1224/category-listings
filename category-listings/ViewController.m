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
    
    _first=YES;
    //导航栏设置
    self.title=@"全部分类";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont fontWithName:@"Geeza Pro" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]};
    
    //读取数据文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RecipesCatalog" ofType:@"plist"];
    _classifyArr = [NSArray arrayWithContentsOfFile:plistPath][0];
    
    //创建tableView
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
    if (_first) {
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
    return _classifyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算Cell高度(根据cell内容数量)
    NSArray *abc=_classifyArr[indexPath.section][@"tags"];
    return ((abc.count-1)/3+1)*50+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //解决cell复用问题
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",indexPath.section,indexPath.row];//以indexPath来唯一确定cell
    
    WZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WZSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //给Cell增加数据
    cell.detailArr=_classifyArr[indexPath.section][@"tags"];
    //需要在数据赋值之后在创建Button
    [cell createButton];
    //cell点击无效果
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
    //为了使记录点击了哪个组头
    header.tag=section+1000;
    header.delegate=self;
    return header;
}

-(void)AddOrDelete:(NSInteger)tag{
    _NowNum=tag;
    if (_first) {
        
        //增加Cell
        NSMutableArray * rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath * indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToInsert addObject:indexPathToInsert];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        _LastNum=_NowNum;
        _first=NO;
        
        //滑动tableView到点击的section位置
        NSIndexPath* currentSection = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [self.tableView scrollToRowAtIndexPath:currentSection atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return;
    }
    if (_NowNum==_LastNum) {
        
        //删除Cell
        NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToDelete = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToDelete addObject:indexPathToDelete];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        //变为初始化状态
        _first=YES;
        
    }else{
        
        //删除Cell
        NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToDelete = [NSIndexPath indexPathForRow:0 inSection:_LastNum-1000];
        [rowToDelete addObject:indexPathToDelete];
        
        //增加Cell
        NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [rowToInsert addObject:indexPathToInsert];
        
        //让上一个点击Cell变为初始状态
        JPCommentHeaderView *header = [self.view viewWithTag:_LastNum];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = header.groupImageV.transform;
            // 在现在的基础上旋转指定角度
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI);
            header.groupImageV.transform = newTransform;
        }completion:nil];
        
        //开始增加和删除Cell
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        _LastNum=_NowNum;
        
        //tableView滑动到点击Section的位置
        NSIndexPath* currentSection = [NSIndexPath indexPathForRow:0 inSection:_NowNum-1000];
        [self.tableView scrollToRowAtIndexPath:currentSection atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
