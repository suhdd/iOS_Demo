//
//  ViewController.m
//  UIDemo
//
//  Created by YuYihao on 2020/7/17.
//  Copyright © 2020 YuYihao. All rights reserved.
//

#import "ViewController.h"
#import "BDCell.h"
#import "CellDataModel.h"
#define CELLID @"lineCell"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSDictionary * jsonDic;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void) createData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UI Demo";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:BDCell.class forCellReuseIdentifier:CELLID];
//    [self.tableView registerClass:UITableViewCell.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.view addSubview:self.tableView];
    [self createData];

}

- (void) createData
{
    // loading session file
    NSString * filePath = [[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"bundle"] stringByAppendingString:@"/sessions.json"];
    NSError * fileError;
    NSString * fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
    NSData *jsonData = [fileData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray * jsonDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&fileError];
    NSLog(@"loading file completed!");
    
    // 数据源数组
    _dataArray = [NSMutableArray array];
    
    for(int i = 0; i < jsonDataArray.count; i++)
    {
        CellDataModel * model = [[CellDataModel alloc] init];
        model.content = [jsonDataArray[i] objectForKey:@"message"];
        model.imagePath = [NSURL URLWithString:[jsonDataArray[i] objectForKey:@"picture"]];
        model.name = [jsonDataArray[i] objectForKey:@"name"];
        model.unreadCount = [jsonDataArray[i][@"unreadCount"] intValue];
        model.idString = [jsonDataArray[i] objectForKey:@"_id"];
        
        //解析时间NSString为NSDate
        NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        model.time = [timeFormatter dateFromString:[jsonDataArray[i] objectForKey:@"time"]];
        
        [_dataArray addObject:model];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog([NSString stringWithFormat:@"%d", self.jsonDic.count]);
    return self.dataArray.count;
//    return 20;
}

- (BDCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
     BDCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell)
    {
        cell = [[BDCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CELLID];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld", indexPath.section, indexPath.row];
//    cell.detailTextLabel.text = @"我是副文本";
//    cell.imageView.image = [UIImage imageNamed:@"1"];
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [cell config: self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"微信消息页Demo";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
