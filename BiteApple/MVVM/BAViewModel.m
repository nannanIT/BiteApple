//
//  BAViewModel.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/7.
//

#import "BAViewModel.h"

@implementation BAViewModel

/**
 1、fetch && parse（json -> BAItemModels）
 2、BAItemModels -> BACellModels
 3、实现UITableViewDataSource，dataSource可以独立一个adapter，用以数据处理相关的回调等
 4、loadMore/pullDown
 */

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
