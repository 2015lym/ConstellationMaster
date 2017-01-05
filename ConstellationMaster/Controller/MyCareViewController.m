//
//  MyCareViewController.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "MyCareViewController.h"
#import "CoreDataBase+Query.h"
#import "MJRefresh.h"
#import "Like.h"

#define SCEENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MyCareViewController()<UITableViewDelegate,UITableViewDataSource>
{
    CoreDataBase *cdb;
}
@property (nonatomic,strong) UITableView *myFellowTableView;
@property (nonatomic,strong) NSMutableArray *cellArray;

@end


@implementation MyCareViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    cdb= [CoreDataBase shardCoreDataBase];
    _cellArray=[cdb queryEntityName:@"Like" Where:nil];
    [self refreshScreen];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=[UIColor cyanColor];
    
    _myFellowTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCEENWIDTH , SCREENHEIGHT)];
    _myFellowTableView.delegate=self;
    _myFellowTableView.dataSource=self;
    [self.view addSubview:_myFellowTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- MJRefresh ----------
-(void)refreshScreen{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = NO;
    [header beginRefreshing];
    _myFellowTableView.mj_header = header;
}

#pragma mark - ---------- 读取数据 ----------
-(void)loadNewData
{
    //刷新表格 从数据库读取数据
    cdb= [CoreDataBase shardCoreDataBase];
    _cellArray=[cdb queryEntityName:@"Like" Where:nil];
    [_myFellowTableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [_myFellowTableView.mj_header endRefreshing];
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _cellArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //优化
    static NSString *identity=@"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    Like *likecell=_cellArray[indexPath.row];
    cell.textLabel.text=likecell.name;
    return cell;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100.f;
}

#pragma mark - ---------- Cell是否可被编辑 ----------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - ---------- 删除Cell ----------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteData:indexPath];
        [_cellArray removeObjectAtIndex:indexPath.row];
        [_myFellowTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark - ---------- 取消关注 ----------
-(void)deleteData:(NSIndexPath *)indexPath
{
         NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
         NSEntityDescription * entity = [NSEntityDescription entityForName:@"Like" inManagedObjectContext:cdb.managedObjectContext];
         [fetchRequest setEntity:entity];
    
         NSError * requestError = nil;
         NSArray * persons = [cdb.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
         if ([persons count] > 0) {
        
                 // 删除数据
                 [cdb.managedObjectContext deleteObject:_cellArray[indexPath.row]];
                 if ([_cellArray[indexPath.row] isDeleted]) {
                         NSLog(@"删除成功");
                         NSError * savingError = nil;
                     
                         if ([cdb.managedObjectContext save:&savingError]) {
                                 NSLog(@"储存成功");
                
                             }else {
                                     NSLog(@"储存失败 error = %@", savingError);
                                 }
                    }else {
                        
                             NSLog(@"删除失败");
                         }
             }else {
                     NSLog(@"没有找到实体");
                 }
}

@end
