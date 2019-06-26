//
//  ViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "ViewController.h"
#import "ImageChooseViewController.h"
#import "PhotoAlbumEditViewController.h"

#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *models;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"LQPhotoKit";
    
    [self setUI];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text         = self.models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            PhotoAlbumEditViewController *vc = [PhotoAlbumEditViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 1:{
            ImageChooseViewController *vc = [ImageChooseViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - setUI

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = YES;
    }];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)models {
    if (!_models) {
        _models = @[@"相册编辑",
                    @"照片多选"];
    }
    
    return _models;
}

@end
