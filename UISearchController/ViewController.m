//
//  ViewController.m
//  UISearchController
//
//  Created by Mac on 2019/1/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

//颜色
#define UIColorFromRGB(value,a)            [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a]

//获取状态栏的高度 iPhone X - 44pt  其他20pt
#define StatusBarHeight                     [[UIApplication sharedApplication] statusBarFrame].size.height

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong) UITableViewController *searchResultsController;

@property (nonatomic, retain) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark --  Life Circle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"选择人员";
    
    self.tableView.backgroundColor = [UIColor grayColor];
    
    //调用初始化searchController - 会使tableView底部出现大块空白
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    // know where you want UISearchController to be displayed
    //self.definesPresentationContext = YES;
    
}

-(void)viewDidLayoutSubviews {
    if(self.searchController.active) {
        _searchResultsController.tableView.frame = CGRectMake(0, StatusBarHeight+self.searchController.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (20+54));
        [self.tableView setFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - 49)];
    }else {
        self.tableView.frame = CGRectMake(0, StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - 49);
    }
}

#pragma mark --  UUITableViewDelagte

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchResultsController.tableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"search -- %ld",(long)indexPath.row];
        return cell;
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"cell -- %ld",(long)indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchResultsController.tableView) {
        return [UIView new];
    }
    
    UIView  *view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.searchResultsController.tableView) {
        return 0;
    }
    
    if (section == 0) {
        return 139;
    }else{
        return 98;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark -- UISearchViewControllerDelagte
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    

    for(UIView *view in  [[[self.searchController.searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - StatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor blackColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UITableViewController *)searchResultsController{
    if (!_searchResultsController) {
        _searchResultsController = [[UITableViewController alloc]init];
        _searchResultsController.tableView.delegate = self;
        _searchResultsController.tableView.dataSource = self;
        _searchResultsController.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchResultsController.tableView.backgroundColor = [UIColor grayColor];
        
        _searchResultsController.tableView.frame = CGRectMake(0, 54, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _searchResultsController;
}

-(UISearchController *)searchController{
    if (!_searchController) {
        
        //指定显示控制器
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
        
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 54);
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.barTintColor = [UIColor grayColor];
        
        
        //_searchController.hidesNavigationBarDuringPresentation = YES;
        //_searchController.definesPresentationContext = YES;
        
        
        [[[[_searchController.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        
        //以此来设置搜索框中的颜色
        UITextField *searchField=[_searchController.searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = UIColorFromRGB(0xEFF1FB, 1.0);
        //改变搜索框中的placeholder的颜色
        [searchField setValue:UIColorFromRGB(0x93A0DF, 1.0) forKeyPath:@"placeholderLabel.textColor"];
    }
    return _searchController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
