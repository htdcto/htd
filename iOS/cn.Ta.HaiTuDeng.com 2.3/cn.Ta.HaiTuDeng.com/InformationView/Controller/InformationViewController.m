//
//  InformationViewController.m
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "InformationViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"//上拉刷新，下啦加载
#import "DetaViewController.h"//详情


#define ZIXUN @"http://120.26.62.17/ta/ta/title.php"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface InformationViewController ()
@property (nonatomic,strong)NSString *filename;
@property (nonatomic,strong)NSString *_Uname;
@property (nonatomic,strong)NSString *Url;

@property BOOL localLoad;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createTableView];
    [self loadDataFromLocal];
    [self loadDataFromServer];
    
 }

-(void)viewWillAppear:(BOOL)animated
{
    self.isActive = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.isActive = NO;
}

-(void)initData
{
    _localLoad = NO;
    _Url = ZIXUN;
    self.dataArray = [NSMutableArray array];
    self.pagenum = 1;
}
-(void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,WIDTH,HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ManTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    //上拉刷新最新资讯
    //下拉加载以前的资讯
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)addHeaderRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //重置页数
        self.pagenum = 1;
        //清空数据源
        [self.dataArray removeAllObjects];
        
        [self loadDataFromServer];
    }];
    [header setTitle:@"马上就好" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
}
-(void)addFooterRefresh
{
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //页数增加
        self.pagenum ++;
        
        //重新请求数据
        [self loadDataFromServer];
        
    }];
    self.tableView.mj_footer = footer;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE" forIndexPath:indexPath];
    
    if (self.dataArray.count <=0) {
        return cell;
    }
    
    MainModel *model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell loadDataFromModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetaViewController *detail = [[DetaViewController alloc]init];
    MainModel *model =self.dataArray[indexPath.row];
    detail.contentid = model.Id;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
-(void)loadDataFromLocal{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* plistPath1 = [paths objectAtIndex:0];
    
    //在此处设置文件的名字补全其中的路径, 注意对于文件内存的修改是在内存之中完成的，然后直接把现在的数据一次性更新，这样减少了文件的读写的次数
    _filename =[plistPath1 stringByAppendingPathComponent:@"InforText.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_filename]) {
        //从本地读缓存文件
        NSArray *Ary = [NSArray arrayWithContentsOfFile:_filename];
        for (NSDictionary *newDict in Ary) {
            MainModel *model= [[MainModel alloc]init];
            [model setValuesForKeysWithDictionary:newDict];
            
            [self.dataArray addObject:model];
            _localLoad = YES;
        }
    }
}

-(void)loadDataFromServer
{
    __Uname = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    NSNumber *page = [NSNumber numberWithInt:self.pagenum];
    NSDictionary *dic = @{@"pagenum":page,@"Utel":__Uname};
    [LDXNetWork GetThePHPWithURL:ZIXUN par:dic success:^(id responseObject) {
        NSArray *resultAry = responseObject[@"date"];
        if ([resultAry isKindOfClass:[NSArray class]] && resultAry.count > 0) {
            if (self.pagenum == 1) {
            [resultAry writeToFile:_filename atomically:YES];
            }
            for (NSDictionary *newDict in resultAry) {
                MainModel *model= [[MainModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                if (_localLoad == YES) {
                    [_dataArray removeAllObjects];
                    _localLoad = NO;
                }
                [self.dataArray addObject:model];


            }
            [self.tableView reloadData];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    } error:^(NSError *error) {
         [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"加载失败，请检查网络", @"No network connection!")) message:@""];
    }];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
