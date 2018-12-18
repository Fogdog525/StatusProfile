//
//  FDAlbumViewController.m
//  新浪个人中心
//
//  Created by 首牛科技 on 2018/12/17.
//  Copyright © 2018 黄智浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDAlbumViewController.h"
#import "SinaFile.h"
#import "FDAlbumHeader.h"

@interface FDAlbumItemCell:UICollectionViewCell
@property(strong,nonatomic)UIImageView *coverImageView;
- (void)setCoverImageURL:(NSString *)url;
@end

@implementation FDAlbumItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:self.coverImageView];
    }
    return self;
}
- (void)setCoverImageURL:(NSString *)url{
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end

@interface FDAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(strong,nonatomic)UICollectionView *collectionView;

@end

@implementation FDAlbumViewController
- (UIScrollView *)swipeTableView{
    return self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
static NSString *const imageURL = @"https://wx3.sinaimg.cn/large/84f038e1gy1flqlknvlagj20hs0a0ta2.jpg";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FDAlbumItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAlbumCellIdentifier forIndexPath:indexPath];
    [cell setCoverImageURL:imageURL];
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(WIDTH, 5);
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAlbumHeaderIdentifier forIndexPath:indexPath];
}
static NSString *const kAlbumCellIdentifier = @"kAlbumCellIdentifier";
static NSString *const kAlbumHeaderIdentifier = @"kAlbumHeaderIdentifier";
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat spacing = 10;
        CGFloat itemWidth = (WIDTH - 4 * spacing) / 3;
        CGFloat itemHeight = itemWidth;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = spacing;
        layout.minimumInteritemSpacing = spacing;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, spacing, spacing, spacing);
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FDAlbumHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAlbumHeaderIdentifier];
        [_collectionView registerClass:[FDAlbumItemCell class] forCellWithReuseIdentifier:kAlbumCellIdentifier];
    }
    return _collectionView;
}

@end
