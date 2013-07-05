//
//  FMSDribbbleCollectionViewViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "FMSDribbbleCollectionViewViewController.h"
#import "FMSFetchDribbbleData.h"
#import "FMSDribbbleImageCell.h"

@interface FMSDribbbleCollectionViewViewController ()

@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation FMSDribbbleCollectionViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[FMSFetchDribbbleData fetchDribbbleData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.imageCache = nil;
}

#pragma mark UICollectionViewController Delegate Methods


#pragma mark UICollectionViewController DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMSDribbbleImageCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    //Configure the cell
    NSURL *imageURL = [NSURL URLWithString:@"http://dribbble.s3.amazonaws.com/users/339875/screenshots/1144149/creativity_teaser.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL]; // Kick off on a background and the place holder
    //also only load when the scrolling has stopped
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    // Setup NSCache for the image url and index.row position
   
    
    newCell.dribbbleImage.image = image;
    
    return newCell;
}

@end
