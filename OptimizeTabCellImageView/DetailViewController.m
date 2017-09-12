//
//  DetailViewController.m
//  OptimizeTabCellImageView
//
//  Created by zheng zhang on 2017/9/12.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "DetailViewController.h"

//V
#import "CommonTableCell.h"

@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tab;
@property (strong, nonatomic) NSDictionary *source;

@end

static NSString *cellIndifner = @"CommonTableCell";
static CGFloat CELL_HEIGHT = 135.f;

@implementation DetailViewController

#pragma mark - systemMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = _titleStr;
    [self setupDatas];
    [self.view addSubview:self.tab];
}


#pragma mark - customMethod
- (void)setupDatas
{
    _source = [NSDictionary dictionaryWithObjects:@[@"- Drawing index is top priority", @"spaceship", @"- Drawing large image is low priority. Should be distributed into different run loop passes."] forKeys:@[@"title", @"image", @"detail"]];
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
            [tab registerClass:[CommonTableCell class] forCellReuseIdentifier:cellIndifner];
            tab;
        });
    }
    return _tab;
}

#pragma mark - tabDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 399;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndifner];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titleStr;
    cell.index = indexPath.row;
    cell.source = self.source;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

@end
