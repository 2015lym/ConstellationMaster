//
//  MainViewController.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "MainViewController.h"
#import "MainInfoViewController.h"
#import "ConstellFlowLayoutCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MainViewController()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView * FLowLayoutView;
@property (strong, nonatomic) NSArray *ConstellationImg;
@property (strong, nonatomic) NSArray *ConstellationName;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor=[UIColor cyanColor];
    
    [self initDefaultArray];
    [self initCollectionView];

}

#pragma mark - ---------- 初始化数组 ----------
- (void)initDefaultArray
{
    _ConstellationImg=[NSArray arrayWithObjects:@"baiyang",@"jinniu",@"shuangzi",@"juxie",@"shizi",@"chunv",@"tianping",@"tianxie",@"sheshou",@"mojie",@"shuiping",@"shuangyu", nil];
    _ConstellationName=[NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
}

#pragma mark - ---------- 初始化CollectionView ----------
- (void)initCollectionView
{
    UICollectionViewFlowLayout *constellatioFlowLayout=[[UICollectionViewFlowLayout alloc]init];
    constellatioFlowLayout.itemSize=CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/4);
    constellatioFlowLayout.sectionInset=UIEdgeInsetsMake(10, 18, 18, 18);   //往中间的距离 上 左 下 右
    constellatioFlowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    _FLowLayoutView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT-50) collectionViewLayout:constellatioFlowLayout];
    _FLowLayoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_FLowLayoutView];
    [_FLowLayoutView registerClass:[ConstellFlowLayoutCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.FLowLayoutView.dataSource=self;
    self.FLowLayoutView.delegate=self;
}

#pragma mark - ---------- Collection的数量 ----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ConstellationImg.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity=@"cell";
    ConstellFlowLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    [cell initContent];
    cell.CellImg.image=[UIImage imageNamed:_ConstellationImg[indexPath.row]];
    cell.CellText.text=_ConstellationName[indexPath.row];
    return cell;
}

#pragma mark - ---------- 每个Cell的点击事件 ----------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainInfoViewController *vc=[[MainInfoViewController alloc]init];
    vc.controlName = _ConstellationName[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
