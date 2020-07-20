//
//  CellDataModel.h
//  UIDemo
//
//  Created by YuYihao on 2020/7/17.
//  Copyright © 2020 YuYihao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellDataModel : NSObject

@property (nonatomic, strong) NSURL * imagePath;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong) NSString * idString;

//@property (nonatomic, strong) NSMutableArray * dataArray;

@end

NS_ASSUME_NONNULL_END
