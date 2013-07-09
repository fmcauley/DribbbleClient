//
//  FMSArtistDetailViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/8/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "FMSArtistDetailViewController.h"
#import "FMSAppDelegate.h"
#import "Shot.h"
#import "Player.h"
#import "FMSFetchDribbbleData.h"
#import "FMSDribbbleImageCell.h"

@interface FMSArtistDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,FMSFetchDribbbleData>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSCache *imageArtistCache;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *fetchedItems;
@property (nonatomic, strong) FMSFetchDribbbleData *dribbleData;

@end

@implementation FMSArtistDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.artist.player.name;
    
    self.imageArtistCache = [[NSCache alloc]init];
    
    self.dribbleData = [[FMSFetchDribbbleData alloc]init];
    self.dribbleData.delegate = self;
    [self.dribbleData fetchArtistDataFromDribbble:self.artist.player.playerId];
    
    FMSAppDelegate *appDelegate=(FMSAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.imageArtistCache = nil;
    self.fetchedItems = nil;
}


#pragma mark UICollectionViewController DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedItems count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMSDribbbleImageCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                                forIndexPath:indexPath];
    [self configureCell:newCell atIndexPath:indexPath];
    return newCell;
}


- (void)configureCell:(FMSDribbbleImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Shot *info = self.fetchedItems[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:info.imageTeaseUrl];
    NSString *key = info.imageTeaseUrl;
    NSData *data = [self.imageArtistCache objectForKey:key];
    
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        cell.artistImage.image = image;
    }
    
    else {
        cell.artistImage.image = [UIImage imageNamed:@"placeholder1.jpg"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [self.imageArtistCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.artistImage.image = image;
            });
        });
    }
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"I was selected");
}

#pragma mark FMSFetchDribbbleData

- (void)refreshContextData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Shot" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // add the predicate for the player id
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:30];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF.player.playerId == %@", self.artist.player.playerId];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    
    self.fetchedItems = [[NSArray alloc]initWithArray:mutableFetchResults];
    
    [self.collectionView reloadData];
}

@end
