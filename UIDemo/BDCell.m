//
//  BDCell.m
//  UIDemo
//
//  Created by YuYihao on 2020/7/17.
//  Copyright © 2020 YuYihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDCell.h"
#import "CellDataModel.h"
#import <SDWebImage/SDWebImage.h>

#define SCREENBOUND [[UIScreen mainScreen] bounds]
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BDCell()<SDWebImageManagerDelegate>
- (void)config:(CellDataModel *)model;

@property (nonatomic, strong) SDAnimatedImageView * lineImage;
@property (nonatomic, strong) UILabel * lineTitle;
@property (nonatomic, strong) UILabel * lineContent;
@property (nonatomic, strong) UILabel * lineTime;
@property (nonatomic, strong) UILabel * lineUnread;

@end

@implementation BDCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lineCell";
    BDCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[BDCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.lineImage = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//        [self.lineImage clipsToBounds:YES];
        [self.lineImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:self.lineImage];
        
        self.lineTitle = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 200, 20)];
        [self.contentView addSubview:self.lineTitle];
        
        self.lineTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 5, 60, 20)];
        [self.contentView addSubview:self.lineTime];
        
        self.lineContent = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, SCREENWIDTH - 80 - 20, 40)];
        [self.contentView addSubview:self.lineContent];
        
        self.lineUnread = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 200, 20)];
        [self.contentView addSubview:self.lineUnread];
        
    }
    return self;
}


- (void)config:(CellDataModel *)model
 {
     //显示头像
     [self.lineImage sd_setImageWithURL:model.imagePath placeholderImage:nil
                                 options:SDWebImageProgressiveLoad|SDWebImageDownloaderScaleDownLargeImages];

     //显示姓名
     self.lineTitle.text = model.name;
     
     //显示时间
     NSDateFormatter * form = [[NSDateFormatter alloc] init];
     form.dateFormat = @"HH:mm";
     self.lineTime.text = [form stringFromDate:model.time];
     
     //显示消息内容
     self.lineContent.text = model.content;
     
     //显示未读消息数量
     self.lineUnread.text = model.unreadCount > 999 ? @"999+" : [NSString stringWithFormat:@"[%ld条消息未读]",model.unreadCount];
     if(model.unreadCount == 0)
     {
         self.lineUnread.hidden = YES;
     }
 }

@end
