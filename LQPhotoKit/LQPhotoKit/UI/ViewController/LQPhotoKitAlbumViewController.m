//
//  LQPhotoKitAlbumViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitAlbumViewController.h"
#import "LQPhotoKitImageListViewController.h"
#import "LQPhotoKitAlbumTableViewCell.h"
#import "LQPhotoKitAlbumModel.h"
#import "LQPhotoKitManager.h"
#import "NSObject+config.h"

@interface LQPhotoKitAlbumViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoAlbums;


@end

@implementation LQPhotoKitAlbumViewController

- (void)dealloc {
    [[LQPhotoKitManager defaultManager] removeAlbums];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相册";
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager]
     requestAuthorizationWithHandler:^(BOOL authorized) {
        if (!authorized) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册"
                                                            message:@"请在设置-隐私-相册中允许访问相册"
                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }]];
            return;
        }
        
        [wself requestAlbums];
        
    }];
}

#pragma mark - privite

- (void)requestAlbums {
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager] requestAllAlbumsWithCompletionBlock:^(NSArray<id<LQPhotoKitAlbumModel>> * _Nonnull albums) {
        for (id<LQPhotoKitAlbumModel> lq_model in albums) {
            LQPhotoKitAlbumModel *model = [LQPhotoKitAlbumModel creatWithPhotoAlbumModel:lq_model];
            [wself.photoAlbums addObject:model];
            [wself.tableView reloadData];
        }
    }];
}

#pragma mark - action

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LQPhotoKitAlbumTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LQPhotoKitAlbumTableViewCell";
    LQPhotoKitAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LQPhotoKitAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.model = self.photoAlbums[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LQPhotoKitImageListViewController *vc = [LQPhotoKitImageListViewController new];
    vc.model = self.photoAlbums[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [self lq_navigationBarHeight], [self lq_screenWidth], [self lq_screenHeight] - [self lq_navigationBarHeight]) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor  = [UIColor colorWithWhite:0.2 alpha:0.3];
        _tableView.separatorInset  = UIEdgeInsetsMake(0, 24, 0, 24);
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)photoAlbums {
    if (!_photoAlbums) {
        _photoAlbums = [NSMutableArray new];
    }
    return _photoAlbums;
}


@end
