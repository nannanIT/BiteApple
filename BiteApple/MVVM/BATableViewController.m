//
//  BATableViewController.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/7.
//

#import "BATableViewController.h"
#import "BAViewModel.h"

@interface BATableViewController ()
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) BAViewModel *viewModel;
@end

@implementation BATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    
    self.viewModel = [[BAViewModel alloc] init];
    self.tableView.dataSource = self.viewModel;
}

@end
