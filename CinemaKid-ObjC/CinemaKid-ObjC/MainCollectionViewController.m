//
//  MainCollectionViewController.m
//  CinemaKid-ObjC
//
//  Created by Abraham Park on 5/21/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

#import "PosterModel.h"

#import "MainCollectionViewController.h"
#import "CinemaKid_ObjC-Swift.h"

@interface MainCollectionViewController ()

@property (nonatomic, strong) CinemaModel *modelCinema;
@property (nonatomic, strong) PosterModel *modelPoster;
@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (PosterModel *)modelPoster{
    if (_modelPoster == nil) {
        _modelPoster = [[PosterModel alloc] init];
    }
    return _modelPoster;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelCinema = [[CinemaModel alloc] init];
    id __weak selfWeak = self;
    
    self.modelCinema.closureUpdateUI = ^{
        MainCollectionViewController *selfStrong = selfWeak;
        
        if (selfStrong) {
            [selfStrong.collectionView reloadData];
        }
    };
    
    [self.modelCinema requestToServer];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelCinema.arrayResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *dicInfo = self.modelCinema.arrayResult[indexPath.row];
    
    // Configure the cell
    UILabel *label = [cell viewWithTag:1];
    UIImageView *viewImage = [cell viewWithTag:2];
    
    label.text = dicInfo[@"title"];
    
    [self.modelPoster requestPoster:dicInfo[@"posterCode"]
                        afterUpdate:^(NSData * _Nullable dataImage) {
                            viewImage.image = [UIImage imageWithData:dataImage]; // UI Update
                        }];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
