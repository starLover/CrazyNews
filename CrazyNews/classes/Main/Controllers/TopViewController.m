//
//  TopViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "TopViewController.h"
#import "PullingRefreshTableView.h"
#import "LeftView.h"
#import "VOSegmentedControl.h"
#import <AFHTTPSessionManager.h>
#import "MainModel.h"
#import "MainTableViewCell.h"
#import "DetailViewController.h"


@interface TopViewController ()<pushViewControllerDelegate, PullingRefreshTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) LeftView *leftView;
@property(nonatomic, strong) VOSegmentedControl *segment;
@property(nonatomic, strong) NSMutableArray *readArray;
@property(nonatomic, strong) PullingRefreshTableView *tableView;

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏左按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_home_menu_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(newView:)];
    //导航栏空白按钮
    UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    emptyBtn.frame = CGRectMake(0, 0, 100, 44);
    [emptyBtn setTitle:@"排行榜" forState:UIControlStateNormal];
    [emptyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *empty = [[UIBarButtonItem alloc] initWithCustomView:emptyBtn];
    self.navigationItem.leftBarButtonItems = @[leftBarBtn, empty];
    //segmentcontrol
    [self.view addSubview:self.segment];
    
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self request];
}
#pragma mark    ------------      UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.mainModel = self.readArray[indexPath.row];
    MainModel *model = self.readArray[indexPath.row];
    cell.countLabel.text = model.author_name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.readArray.count;
}
#pragma mark    ------------      UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    MainModel *model = self.readArray[indexPath.row];
    
    detailVC.urlString = model.share_url;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark    ------------      自定义方法
- (void)segmentCtrlValuechange:(VOSegmentedControl *)segment{
    if (self.readArray.count > 0) {
        [self.readArray removeAllObjects];
    }
    [self request];
//    switch (segment.selectedSegmentIndex) {
//        case 1:
//        {
//        
//            
//        }
//            break;
//        case 2:
//        {
//        }
//            break;
//        case 3:
//        {
//        }
//            break;
//            
//        default:
//            break;
//    }
    
}
- (void)newView:(UIBarButtonItem *)btn{
    self.leftView = [[LeftView alloc] init];
    self.leftView.delegate = self;
}
- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark   ------------    网络请求
- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    NSString *strUrl;
    if (self.segment.selectedSegmentIndex == 0) {
        strUrl = [NSString stringWithFormat:kRankingList, @"read"];
    } else if (self.segment.selectedSegmentIndex == 1) {
        strUrl = [NSString stringWithFormat:kRankingList, @"vote"];
    } else {
        strUrl = [NSString stringWithFormat:kRankingList, @"comment"];
    }
    
    [manager GET:strUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDic = responseObject;
        NSArray *array = responseDic[@"articles"];
        for (NSDictionary *dic in array) {
            MainModel *model = [MainModel getDictionary:dic];
            [self.readArray addObject:model];
        }
        NSLog(@"123456789%lu",self.readArray.count);
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark   ------------   PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
}

#pragma mark   ------------   LazyLoading
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"阅读"}, @{VOSegmentText:@"赞"}, @{VOSegmentText:@"评论"}]];
        self.segment.animationType = VOSegCtrlAnimationTypeSmooth;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.selectedIndicatorColor = [UIColor redColor];
        self.segment.backgroundColor = [UIColor whiteColor];
        self.segment.textColor = [UIColor redColor];
        self.segment.selectedBackgroundColor = [UIColor whiteColor];
        self.segment.allowNoSelection = NO;
        self.segment.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segment.indicatorThickness = 3;
        [self.segment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (NSMutableArray *)readArray{
    if (_readArray == nil) {
        self.readArray = [NSMutableArray new];
    }
    return _readArray;
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 108) pullingDelegate:self];
        self.tableView.rowHeight = 120;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
