//
//  BAMultiPageViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/10/29.
//

#import "BAMultiPageViewController.h"
#import "BAMultiPageView.h"

@interface BAMultiPageViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property(nonatomic, strong) BAMultiPageView *pageView;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation BAMultiPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageView = [[BAMultiPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.pageView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    self.pageView.backgroundColor = UIColor.orangeColor;
    self.pageView.delegate = self;
    self.pageView.scrollEnabled = YES;
    [self.view addSubview:self.pageView];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.headView.backgroundColor = UIColor.blueColor;
    [self.pageView addSubview:self.headView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height)];
    [self.pageView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.dataSource = self;
    UIResponder *res = self.view.nextResponder;
    UIResponder *res1 = self.pageView.nextResponder;
    UIResponder *res2 = res1.nextResponder;
    UIResponder *res3 = res.nextResponder;
    UIResponder *res4 = self.tableView.nextResponder;
    NSLog(@"");
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll");
    if (scrollView == self.pageView) {
        NSLog(@"A");
        CGFloat offset = scrollView.contentOffset.y;
        if (offset < 100) {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        } else {
            [self.pageView setContentOffset:CGPointMake(0, 100)];
        }
    } else if (scrollView == self.tableView) {
        NSLog(@"B");
    }
}

@end
