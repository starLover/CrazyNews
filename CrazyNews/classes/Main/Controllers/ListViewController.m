//
//  ListViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ListViewController.h"
#import "PullingRefreshTableView.h"
#import "LeftView.h"
#import <AFHTTPSessionManager.h>
#import "MainModel.h"
#import "ListTableViewCell.h"
#import "DetailViewController.h"

@interface ListViewController ()<pushViewControllerDelegate, PullingRefreshTableViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) LeftView *leftView;
@property(nonatomic, strong) NSMutableArray *readArray;
@property(nonatomic, strong) PullingRefreshTableView *tableView;

@end

@implementation ListViewController

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

    
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self request];

}
#pragma mark    ------------      UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.mainModel = self.readArray[indexPath.row];
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
    
    [manager GET:kList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSArray *array = responseDic[@"data"];
        for (NSDictionary *dic in array) {
            MainModel *model = [MainModel getDictionary:dic];
            [self.readArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark   ------------   PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
}
- (NSMutableArray *)readArray{
    if (_readArray == nil) {
        self.readArray = [NSMutableArray new];
    }
    return _readArray;
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) pullingDelegate:self];
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
