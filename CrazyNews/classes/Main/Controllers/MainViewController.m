//
//  MainViewController.m
//  CrazyNews
//
//  Created by wanghongxiao on 16/3/3.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <UIImageView+WebCache.h>
#import "MainModel.h"
#import "DetailViewController.h"
#import "LeftView.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoTableViewCell.h"



@interface MainViewController ()<PullingRefreshTableViewDelegate, UITableViewDelegate, UITableViewDataSource, pushViewControllerDelegate>
{
    NSInteger stampTime;
    NSInteger stampTime1;
    BOOL refresh;

}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) VOSegmentedControl *segment;
@property(nonatomic, strong) NSMutableArray *topArray;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) LeftView *leftView;
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) NSMutableArray *videoArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
    //推出视图
    
    refresh = NO;
    stampTime = [TimeStamp getNewStamp];
    stampTime1 = stampTime;
    //导航栏左按钮
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_home_menu_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(newView:)];
    //导航栏空白按钮
    UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame = CGRectMake(0, 0, 100, 44);
    emptyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [emptyBtn setTitle:@"暴走日报" forState:UIControlStateNormal];
    [emptyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *empty = [[UIBarButtonItem alloc] initWithCustomView:emptyBtn];
    self.navigationItem.leftBarButtonItems = @[leftBarBtn, empty];
    //segmentcontrol
    //推荐 视频
    [self.view addSubview:self.segment];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.tableView launchRefreshing];
    
}
#pragma mark     ------------ UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        if (indexPath.row <= self.dataArray.count) {
            cell.mainModel = self.dataArray[indexPath.row];
        }
        return cell;
    }
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCellIdentifier"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:nil options:nil] firstObject];
        if (indexPath.row <= self.videoArray.count) {
            cell.mainModel = self.videoArray[indexPath.row];
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segment.selectedSegmentIndex == 0) {
        return self.dataArray.count;
    }
    return self.videoArray.count;
}
#pragma mark     ------------ UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        MainModel *model = self.dataArray[indexPath.row];
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        if (model.share_url) {
            detailVC.urlString = model.share_url;
        } else {
            detailVC.urlString = model.link;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
           }
}


#pragma mark     ------------ PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    refresh = NO;
    if (self.segment.selectedSegmentIndex == 0) {
        [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
    } else {
        [self performSelector:@selector(videoRequest) withObject:nil afterDelay:1.f];
    }
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    refresh = YES;
    //如果选择第二个segment,网络请求改变
    if (self.segment.selectedSegmentIndex == 0) {
        if (stampTime > 3600 * 10) {
            stampTime -= 3600 * 10;
        }
        [self performSelector:@selector(request) withObject:nil afterDelay:1.f];
    } else {
        if (stampTime1 > 3600 * 10) {
            stampTime1 -= 3600 * 10;
        }
        [self performSelector:@selector(videoRequest) withObject:nil afterDelay:1.f];
    }
    
}
#pragma mark     -------------    自定义加载方法
- (void)configHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenWidth / 2 + 50)];
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.scrollView];
    
    for (int i = 0; i < self.topArray.count; i++) {
        //轮播图图片
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenWidth / 2 + 50)];
        MainModel *model = self.topArray[i];
        [headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"avatar_m"]];
        headImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:headImage];
        //轮播图按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenWidth / 2);
        [btn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        //label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + kScreenWidth * i, kScreenWidth / 2 + 50 - 45, kScreenWidth - 40, 40)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = model.title;
        label.textColor = [UIColor whiteColor];
        [self.scrollView addSubview:label];
    }
    [headView addSubview:self.pageControl];
}
#pragma mark ------------   ButtonAction
//推出侧边栏方法
- (void)newView:(UIBarButtonItem *)btn{
    self.leftView = [[LeftView alloc] init];
    self.leftView.delegate = self;
}
//代理方法
- (void)getWitchViewController:(UIViewController *)VC{
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)segmentCtrlValuechange:(VOSegmentedControl *)segment{
    if (self.segment.selectedSegmentIndex == 0) {
        self.tableView.rowHeight = 120;
        [self request];
    } else {
        self.tableView.rowHeight = 273;
        self.tableView.tableHeaderView = nil;
        [self videoRequest];
    }
}
- (void)headerAction:(UIButton *)btn{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    MainModel *model = self.topArray[btn.tag - 100];
    detailVC.urlString = model.share_url;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark   -------------    Lazy Loading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 120;
    }
    return _tableView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2 + 50)];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenWidth / 2);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenWidth / 2 - 20 + 50, kScreenWidth, 20)];
        self.pageControl.numberOfPages = 5;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self.pageControl addTarget:self action:@selector(pageControlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
}

- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"推荐"}, @{VOSegmentText:@"视频"}]];
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

- (NSMutableArray *)topArray{
    if (_topArray == nil) {
        self.topArray = [NSMutableArray new];
    }
    return _topArray;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)createTimer{
    if (_timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    }
    return;
}
- (NSMutableArray *)videoArray{
    if (_videoArray == nil) {
        self.videoArray = [NSMutableArray new];
    }
    return _videoArray;
}
#pragma mark    -----------    网络请求
- (void)request{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    NSString *urlString = kMainUrl;
    if (refresh) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?timestamp=%lu&", stampTime]];
        NSLog(@"%@", urlString);
    } else{
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
    }
    [sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        //top数据
        NSArray *top1Array = responseDic[@"top_stories"];
        for (NSDictionary *dic in top1Array) {
            MainModel *mainModel = [MainModel getDictionary:dic];
            [self.topArray addObject:mainModel];
        }
        //轮播图
        [self configHeadView];
        //cell数据
        NSArray *data1Array = responseDic[@"data"];
        for (NSDictionary *dic in data1Array) {
            MainModel *mainModel = [MainModel getDictionary:dic];
            [self.dataArray addObject:mainModel];
        }
        [self.tableView tableViewDidFinishedLoading];
        //        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (void)videoRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    NSString *urlString = kVideo;
    if (refresh) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?timestamp=%lu&", stampTime1]];
    } else{
        if (self.videoArray.count > 0) {
            [self.videoArray removeAllObjects];
        }
    }
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSArray *videoArray = responseDic[@"videos"];
        for (NSDictionary *dic in videoArray) {
            MainModel *model = [MainModel getDictionary:dic];
            [self.videoArray addObject:model];
        }
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark      -------------   轮播图实现

- (void)pageControlAction{
    NSInteger pageNumber = self.pageControl.currentPage;
    CGFloat offsetx = pageNumber * kScreenWidth;
    self.scrollView.contentOffset = CGPointMake(offsetx, 0);
}
- (void)timeAction{
    NSInteger i = self.pageControl.currentPage + 1;
    if (self.topArray.count > 0) {
        self.pageControl.currentPage = i % self.topArray.count;
    }
    CGPoint offset = CGPointMake(self.pageControl.currentPage * kScreenWidth, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
}
//轮播图定时器
- (void)viewWillAppear:(BOOL)animated{
    [self createTimer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [_timer invalidate], _timer = nil;
}

//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetx = scrollView.contentOffset.x;
    NSInteger number = offsetx / kScreenWidth;
    self.pageControl.currentPage = number;
    [self.tableView tableViewDidScroll:scrollView];
}

//拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer invalidate], _timer = nil;
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
    [self createTimer];
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
