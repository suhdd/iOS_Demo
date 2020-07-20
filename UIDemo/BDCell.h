//
//  BDCell.h
//  UIDemo
//
//  Created by YuYihao on 2020/7/17.
//  Copyright © 2020 YuYihao. All rights reserved.
//

#ifndef BDCell_h
#define BDCell_h

#import <UIKit/UIKit.h>
#import "CellDataModel.h"

@interface BDCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)config:(CellDataModel *)model;

@end

#endif /* BDCell_h */
