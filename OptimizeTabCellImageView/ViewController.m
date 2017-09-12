//
//  ViewController.m
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "ViewController.h"

//VC
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tab;
@property (strong, nonatomic) NSMutableArray *sourceArr;

@end

static NSString *cellIndifner = @"cellIndifner";
static CGFloat CELL_HEIGHT = 90.0f;

@implementation ViewController

#pragma mark - systemMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupDatas];
    self.navigationItem.title = @"一级";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tab];
}

#pragma mark - customMethod
- (void)setupDatas
{
    _sourceArr = [NSMutableArray array];
    [_sourceArr addObject:[NSDictionary dictionaryWithObjects:@[@"一、原始版本", @"未做过任何优化，因为cell.ImageView和图片大小不匹配，在一个runloop中处理多个任务，会造成卡顿，极大影响用户体验！"] forKeys:@[@"name", @"detail"]]];
    [_sourceArr addObject:[NSDictionary dictionaryWithObjects:@[@"二、利用ImageContext优化", @"优化方式是根据cell.ImageView的大小以及原始图进行异步绘制，保证两者大小相同，不会触发渲染，成功后主线程返回。"] forKeys:@[@"name", @"detail"]]];
    [_sourceArr addObject:[NSDictionary dictionaryWithObjects:@[@"三、利用runloop优化", @"优化方式runloop，对比方式1主要是减轻单个runloop的压力，由1个runloop处理多个任务，变成了多个runloop处理多个任务，这样会变得很高效。"] forKeys:@[@"name", @"detail"]]];
}


#pragma mark - UI
- (UITableView *)tab
{
    if (!_tab) {
        _tab = ({
            UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
            tab.delegate = self;
            tab.dataSource = self;
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndifner];
            tab;
        });
    }
    return _tab;
}

#pragma mark - tabDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndifner];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    for (int i = 99; i <= 100; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, [UIScreen mainScreen].bounds.size.width - 30.0f, 15.0f)];
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor magentaColor];
    titleLabel.tag = 99;
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = _sourceArr[indexPath.row][@"name"];

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 20.0f, [UIScreen mainScreen].bounds.size.width - 30.0f, 15.0f)];
    contentLabel.font = [UIFont systemFontOfSize:11.0f];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 100;
    [cell.contentView addSubview:contentLabel];
    
    contentLabel.text = _sourceArr[indexPath.row][@"detail"];
    [contentLabel sizeToFit];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.titleStr = _sourceArr[indexPath.row][@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
