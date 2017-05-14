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

@interface MainViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * fLowLayoutView;
@property (nonatomic, strong) NSArray *constellationImage;
@property (nonatomic, strong) NSArray *constellationName;

@end

@implementation MainViewController
#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];
    
    [self initDefaultArray];
    [self initCollectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- 初始化数组 ----------
- (void)initDefaultArray
{
    _constellationImage = [NSArray arrayWithObjects:
                           @"baiyang", @"jinniu", @"shuangzi", @"juxie",
                           @"shizi", @"chunv", @"tianping", @"tianxie",
                           @"sheshou", @"mojie", @"shuiping", @"shuangyu", nil];
    
    _constellationName=[NSArray arrayWithObjects:
                        @"白羊座", @"金牛座", @"双子座", @"巨蟹座",
                        @"狮子座", @"处女座", @"天秤座", @"天蝎座",
                        @"射手座", @"摩羯座", @"水瓶座", @"双鱼座", nil];
}

#pragma mark - ---------- 初始化CollectionView ----------
- (void)initCollectionView
{
    UICollectionViewFlowLayout *constellatioFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    constellatioFlowLayout.itemSize = CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/4);
    constellatioFlowLayout.sectionInset = UIEdgeInsetsMake(10, 18, 18, 18);
    constellatioFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.fLowLayoutView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT-50)
                                           collectionViewLayout:constellatioFlowLayout];
    _fLowLayoutView.backgroundColor = [UIColor whiteColor];
    _fLowLayoutView.dataSource = self;
    _fLowLayoutView.delegate = self;
    [self.view addSubview:_fLowLayoutView];
    [_fLowLayoutView registerClass:[ConstellFlowLayoutCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - ---------- Collection的数量 ----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _constellationImage.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identity=@"cell";
    ConstellFlowLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity
                                                                             forIndexPath:indexPath];
    [cell initContent];
    cell.constellationImageView.image = [UIImage imageNamed: _constellationImage[indexPath.item]];
    cell.constellationNameLabel.text = _constellationName[indexPath.item];
    return cell;
}

#pragma mark - ---------- 每个Cell的点击事件 ----------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainInfoViewController *vc = [[MainInfoViewController alloc]init];
    vc.controlName = _constellationName[indexPath.item];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
