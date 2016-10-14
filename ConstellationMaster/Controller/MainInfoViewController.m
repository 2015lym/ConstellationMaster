//
//  MainInfoViewController.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "MainInfoViewController.h"
#import "MyCareViewController.h"
#import "AFNetworking.h"
#import "CoreDataBase+Query.h"
#import "Masonry.h"
#import "Like.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MainInfoViewController()
{
    NSMutableArray *CoreDatasArray;
}
@property (nonatomic,strong)UIButton *ILike;
@end

@implementation MainInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    
    [self netRequest];

}


#pragma mark - ---------- 初始化界面 ----------
- (void)configUI
{
    self.navigationController.navigationBar.barTintColor=[UIColor cyanColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ILike=[[UIButton alloc]initWithFrame:CGRectMake(20 , 150, SCREENWIDTH/4, SCREENWIDTH/10)];
    _ILike.backgroundColor=[UIColor greenColor];
    [_ILike setTitle:@"关注" forState:UIControlStateNormal];
    [_ILike addTarget:self action:@selector(followThisConstellation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ILike];
    [_ILike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/10));
        make.left.mas_equalTo(self.view).offset(SCREENWIDTH/20);
        make.centerY.mas_equalTo(self.view).offset(-SCREENWIDTH/2);
    }];
    
    //检测是否已经关注过了
    CoreDataBase *cdb = [CoreDataBase shardCoreDataBase];
    CoreDatasArray=[cdb queryEntityName:@"Like" Where:nil];
    for (int i=0; i<CoreDatasArray.count; i++) {
        Like *searchlike=CoreDatasArray[i];
        if ([self.ControlName isEqualToString:searchlike.name]) {  //字符串不能用==
            [_ILike setTitle:@"已关注" forState:UIControlStateNormal];
            break; //如果已经找到了就直接跳出循环
        }
    }
}

#pragma mark - ---------- 关注点击事件 ----------
-(void)followThisConstellation
{
    int Cnametest=0;
    CoreDataBase *cdb = [CoreDataBase shardCoreDataBase];
    CoreDatasArray=[cdb queryEntityName:@"Like" Where:nil];
    for (int i=0; i<CoreDatasArray.count; i++) {
        Like *searchlike=CoreDatasArray[i];
        if ([self.ControlName isEqualToString:searchlike.name]) {  //字符串不能用==
            Cnametest=1;
            break;
        }
    }
    
    if(Cnametest==0)
    {
        Like *newlike=[NSEntityDescription insertNewObjectForEntityForName:@"Like" inManagedObjectContext:cdb.managedObjectContext];
        newlike.name=self.ControlName;
        [cdb saveContext];
        [_ILike setTitle:@"已关注" forState:UIControlStateNormal];
        [self createSign:@"添加关注成功"];
    }
    else
    {
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
    
    dic[@"consName"] = self.ControlName;
    dic[@"type"] = @"today";
    dic[@"key"] = @"5af259fa1e1f066249cf10a1297b4023";
    
    [manager POST:@"http://web.juhe.cn:8080/constellation/getAll" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        UILabel *Constellation=[[UILabel alloc]init];
        Constellation.text=[responseObject objectForKey:@"name"];
        Constellation.font=[UIFont systemFontOfSize:SCREENWIDTH/22];
        Constellation.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:Constellation];
        [Constellation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/2, SCREENWIDTH/20));
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view).offset(-SCREENWIDTH/3);
        }];
        
        
        UILabel *LuckyColor=[[UILabel alloc]init];
        NSMutableString* ColorText=[NSMutableString stringWithString:@"幸运色:"];
        [ColorText appendString:[responseObject objectForKey:@"color"]];
        LuckyColor.text=ColorText;
        LuckyColor.font=[UIFont systemFontOfSize:SCREENWIDTH/22];
        LuckyColor.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:LuckyColor];
        [LuckyColor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWIDTH/2, SCREENWIDTH/20));
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(Constellation).offset(SCREENWIDTH/12);
        }];
        
        
        UILabel *Luck=[[UILabel alloc]init];
        NSMutableString* LuckText=[NSMutableString stringWithString:@"        "];
        [LuckText appendString:[responseObject objectForKey:@"summary"]];
        Luck.text=LuckText;
        Luck.numberOfLines=0;
        Luck.font=[UIFont systemFontOfSize:SCREENWIDTH/22];
        Luck.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:Luck];
        [Luck mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - 50, SCREENWIDTH/2));
            make.centerX.mas_equalTo(self.view);
            make.bottom.mas_equalTo(LuckyColor).offset(SCREENWIDTH/2);
        }];


        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取数据失败/n%@",error);
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)createSign:(NSString *)sign  //AlertController提示方法 BY Lym
{
    UIAlertController *Sign=[UIAlertController alertControllerWithTitle:sign message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Yes=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [Sign addAction:Yes];
    [self presentViewController:Sign animated:YES completion:nil];
}
@end
