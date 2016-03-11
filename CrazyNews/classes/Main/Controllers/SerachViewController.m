//
//  SerachViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/10.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "SerachViewController.h"
#import <AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "MainTableViewCell.h"
#import "DetailViewController.h"
#import "MainModel.h"

@interface SerachViewController ()<pushViewControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSString *keywords;
    NSString *page;
}
@property(nonatomic, strong) UISearchBar *customSearchBar;
@property(nonatomic, strong) LeftView *leftView;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SerachViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.customSearchBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //导航栏左按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_home_menu_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(newView:)];
    self.navigationItem.leftBarButtonItems = @[leftBarBtn];
    
    
    [self.navigationController.view addSubview:self.customSearchBar];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    page = @"1";
    [self request];
//    [self.tableView launchRefreshing];
}
#pragma mark     ------------ UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row <= self.dataArray.count) {
        cell.mainModel = self.dataArray[indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
#pragma mark     ------------ UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *model = self.dataArray[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
            if (model.share_url) {
                detailVC.urlString = model.share_url;
            } else {
                detailVC.urlString = model.link;
            }
            [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark     ------------ PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    page = @"1";
    [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page = @"2";
    [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
}


- (void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    keywords = self.customSearchBar.text;
    [manager POST:@"http://dailyapi.ibaozou.com/api/v1/articles/search" parameters:@{@"page":page, @"keywords":keywords} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        NSDictionary *responseDic = responseObject;
        NSArray *data1Array = responseDic[@"articles"];
        for (NSDictionary *dic in data1Array) {
            MainModel *mainModel = [MainModel getDictionary:dic];
            [self.dataArray addObject:mainModel];
        }
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
        
    } failure:nil];
}

- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)newView:(UIBarButtonItem *)btn{
    self.leftView = [[LeftView alloc] init];
    self.leftView.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark      ---------------- 点击搜索代理方法
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [self request];
    [self.view addSubview:self.tableView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self request];
    [self.view addSubview:self.tableView];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.customSearchBar resignFirstResponder];
}

#pragma mark      ---------------- LazyLoading
- (UISearchBar *)customSearchBar{
    if (_customSearchBar == nil) {
        CGRect mainViewBounds = self.navigationController.view.bounds;
        self.customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds) + 80,CGRectGetMinY(mainViewBounds) + 20,CGRectGetWidth(mainViewBounds) - 80,44)];
        self.customSearchBar.delegate = self;
        self.customSearchBar.showsBookmarkButton = YES;
        [self.customSearchBar setBackgroundImage:[[UIImage alloc] init]];
        self.customSearchBar.placeholder = @"输入关键字";
        self.customSearchBar.barTintColor = [UIColor redColor];
    }
    return _customSearchBar;
}

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 120;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.customSearchBar.hidden = YES;
    [self.customSearchBar resignFirstResponder];
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
