//
//  FunctionCell.m
//  床垫页面
//
//  Created by PongBan on 16/10/19.
//  Copyright © 2016年 聂飞. All rights reserved.
//

#import "FunctionCell.h"
#import "UIView+SDAutoLayout.h"

@implementation FunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    
    return self;
    
}


-(void)setUpUI
{
    
    _headImg   = [[UIImageView alloc]init];
    _nameLabel = [[UILabel alloc]init];
    _FenGeXian = [[UIView alloc]init];
    
    [self addSubview:_headImg];
    [self addSubview:_nameLabel];
    [self addSubview:_FenGeXian];
    
    
    _headImg.sd_layout
    .leftSpaceToView (self,25)
    .bottomSpaceToView(self,12)
    .widthIs(13)
    .heightIs(14);
    
    
    _nameLabel.sd_layout
    .leftSpaceToView(self,44)
    .bottomSpaceToView(self,12)
    .rightSpaceToView(self,20)
    .heightIs(19);
    
    
    _FenGeXian.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self,20)
    .rightSpaceToView(self,20)
    .heightIs(0.7);
    
    _FenGeXian.backgroundColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:0.6];

    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
