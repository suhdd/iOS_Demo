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
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * reFreshButton;
@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSDictionary * jsonDic;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void) createData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UI Demo";
    CGRect buttonBounds = CGRectMake (0, SCREENHEIGHT-75, SCREENWIDTH, 50);
    CGRect tableViewBounds = CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-100);
    self.reFreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.reFreshButton.frame = buttonBounds;
    [self.reFreshButton setTitle:@"刷新页面" forState:UIControlStateNormal];
    [self.reFreshButton addTarget:self action:@selector(reloadInfo) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc] initWithFrame:tableViewBounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:BDCell.class forCellReuseIdentifier:CELLID];
//    [self.tableView registerClass:UITableViewCell.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.view addSubview:self.reFreshButton];
    [self.view addSubview:self.tableView];
    [self reloadInfo];
}

- (void) reloadInfo
{
    // loading session file
    //    NSString * filePath = [[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"bundle"] stringByAppendingString:@"/sessions.json"];
    //    NSError * fileError;
    //    NSString * fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
    //    NSData *jsonData = [fileData dataUsingEncoding:NSUTF8StringEncoding];
    //    NSMutableArray * jsonDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&fileError];
    NSURLSession *session = [NSURLSession sharedSession];
            // 发起任务
            NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://www.test.com/json"]
                                                     completionHandler:
                 ^(NSData *data, NSURLResponse *response, NSError *error) {
    //            NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    if (!error && data) {
                        // 反序列化
                        NSMutableArray * jsonDataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 更新UI;
                            NSLog(@"获取json成功");
                            [self createData:jsonDataArray];
                            [self.tableView reloadData];
                        });
                    }
                    else
                    {
                        NSLog(@"获取json错误");
                    }
                }];
                // 所有任务默认都是挂起的，需要继续才能执行
            [task resume];
            NSLog(@"loading file completed!");
}

- (void) createData:(NSMutableArray *) jsonDataArray
{
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
