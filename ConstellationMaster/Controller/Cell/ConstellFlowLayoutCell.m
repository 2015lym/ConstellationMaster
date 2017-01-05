//
//  ConstellFlowLayoutCell.m
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import "ConstellFlowLayoutCell.h"
#import "Masonry.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ConstellFlowLayoutCell

-(void)initContent
{
    _CellImg=[[UIImageView alloc]init];
    [self.contentView addSubview:_CellImg];
    [_CellImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/5, ScreenWidth/5));
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    _CellText=[[UILabel alloc]init];
    _CellText.font=[UIFont systemFontOfSize:ScreenWidth/25];
    _CellText.textAlignment = NSTextAlignmentCenter;  //文字居中
    [self.contentView addSubview:_CellText];
    [_CellText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/6, ScreenWidth/4-ScreenWidth/5));
        make.bottom.mas_equalTo(_CellImg).offset(ScreenWidth/4-ScreenWidth/5);
        make.centerX.mas_equalTo(_CellImg);
    }];
}
@end
