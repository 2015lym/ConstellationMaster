//
//  ConstellFlowLayoutCell.h
//  ConstellationMaster
//
//  Created by Lym on 16/3/27.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstellFlowLayoutCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *CellImg;
@property(nonatomic,strong)UILabel *CellText;
-(void)initContent;
@end
