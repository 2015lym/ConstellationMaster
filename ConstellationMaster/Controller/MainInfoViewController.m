//
//  MainInfoViewController.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "MainInfoViewController.h"
#import "MyCareViewController.h"
#import "CoreDataBase+Query.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "Like.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MainInfoViewController()
@property (nonatomic, strong) UIButton *userAttention;
@property (nonatomic, strong) NSMutableArray *coreDatasArray;

@end

@implementation MainInfoViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- 初始化界面 ----------
- (void)configUI
{
    self.navigationItem.title = self.controlName;
    
    self.navigationController.navigationBar.barTintColor=[UIColor cyanColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userAttention = [[UIButton alloc]initWithFrame:CGRectMake(20 , 150, SCREENWIDTH/4, SCREENWIDTH/10)];
    _userAttention.backgroundColor = [UIColor greenColor];
    [_userAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_userAttention addTarget:self action:@selector(followThisConstellation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userAttention];
    [_userAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/10));
        make.left.mas_equalTo(self.view).offset(SCREENWIDTH/20);
        make.centerY.mas_equalTo(self.view).offset(-SCREENWIDTH/2);
    }];
    
    //检测是否已经关注过了
    CoreDataBase *cdb = [CoreDataBase shardCoreDataBase];
    _coreDatasArray = [cdb queryEntityName:@"Like" Where:nil];
    for (int i=0; i<_coreDatasArray.count; i++) {
        Like *searchlike = _coreDatasArray[i];
        if ([self.controlName isEqualToString:searchlike.name]) {
            [_userAttention setTitle:@"已关注" forState:UIControlStateNormal];
            break; //如果已经找到了就直接跳出循环
        }
    }
}

#pragma mark - ---------- 关注点击事件 ----------
-(void)followThisConstellation
{
    int Cnametest = 0;
    CoreDataBase *cdb = [CoreDataBase shardCoreDataBase];
    _coreDatasArray = [cdb queryEntityName:@"Like" Where:nil];
    for (int i=0; i<_coreDatasArray.count; i++) {
        Like *searchlike = _coreDatasArray[i];
        if ([self.controlName isEqualToString:searchlike.name]) {
            Cnametest = 1;
            break;
        }
    }
    
    if(Cnametest==0) {
        Like *newlike=[NSEntityDescription insertNewObjectForEntityForName:@"Like" inManagedObjectContext:cdb.managedObjectContext];
        newlike.name=self.controlName;
        [cdb saveContext];
        [_userAttention setTitle:@"已关注" forState:UIControlStateNormal];
        [self createSign:@"添加关注成功"];
    } else {
        [self createSign:@"你已经关注过了"];
    }
}


#pragma mark - ---------- 网络数据获取 ----------
- (void)netRequest
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"consName"] = self.controlName;
    dic[@"type"] = @"today";
    dic[@"key"] = @"5af259fa1e1f066249cf10a1297b4023";
    
    [manager POST:@"http://web.juhe.cn:8080/constellation/getAll" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //最近测试接口发现有时会出现没有数据，导致程序崩溃的问题
        //这里进行一下判断
        
        if (responseObject[@"reason"] == nil) {
            
            UILabel *constellation = [[UILabel alloc] init];
            constellation.text = self.controlName;
            constellation.font = [UIFont systemFontOfSize:SCREENWIDTH/22];
            constellation.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:constellation];
            [constellation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/2, SCREENWIDTH/20));
                make.centerX.mas_equalTo(self.view);
                make.centerY.mas_equalTo(self.view).offset(-SCREENWIDTH/3);
            }];
            
            UILabel *LuckyColor = [[UILabel alloc] init];
            LuckyColor.text = [NSMutableString stringWithFormat:@"幸运色:%@", responseObject[@"color"]];
            LuckyColor.font = [UIFont systemFontOfSize:SCREENWIDTH/22];
            LuckyColor.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:LuckyColor];
            [LuckyColor mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/2, SCREENWIDTH/20));
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(constellation).offset(SCREENWIDTH/12);
            }];
            
            
            UILabel *Luck = [[UILabel alloc] init];
            Luck.text = [NSMutableString stringWithFormat:@"       %@", responseObject[@"summary"]];
            Luck.numberOfLines = 0;
            Luck.font = [UIFont systemFontOfSize:SCREENWIDTH/22];
            Luck.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:Luck];
            [Luck mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - 50, SCREENWIDTH/2));
                make.centerX.mas_equalTo(self.view);
                make.bottom.mas_equalTo(LuckyColor).offset(SCREENWIDTH/2);
            }];
        } else {
            [self createSign:responseObject[@"reason"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取数据失败/n%@",error);
    }];

    
}

-(void)createSign:(NSString *)sign
{
    UIAlertController *Sign = [UIAlertController alertControllerWithTitle:sign
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Yes = [UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil];
    [Sign addAction:Yes];
    [self presentViewController:Sign
                       animated:YES
                     completion:nil];
}

@end
