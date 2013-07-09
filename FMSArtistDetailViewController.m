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

@interface FMSArtistDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDelegate,UITableViewDataSource, FMSFetchDribbbleData>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSCache *imageArtistCache;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *fetchedItems;
@property (nonatomic, strong) FMSFetchDribbbleData *dribbleData;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

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
    // add the logic to save to disk
}

#pragma mark FMSFetchDribbbleData

- (void)refreshContextData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Shot" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:30];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF.player.playerId == %@", self.artist.player.playerId];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // TODD: Handle the error.
    }
    
    self.fetchedItems = [[NSArray alloc]initWithArray:mutableFetchResults];
    
    [self.collectionView reloadData];
    [self.tableVIew reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    Shot *artist = self.fetchedItems[0]; //index 0 because all artist data is the same.
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = artist.player.name;
            cell.detailTextLabel.text = @"Artist Name";
            break;
        case 1:
            cell.textLabel.text = artist.player.userName;
            cell.detailTextLabel.text = @"Artist User Name";
            break;
        case 2:
            cell.textLabel.text = artist.player.url;
            cell.detailTextLabel.text = @"Artist URL";
            break;
        case 3:
            cell.textLabel.text = artist.player.avatarUrl;
            cell.detailTextLabel.text = @"Artist Avatar URL";
            break;
        case 4:
            cell.textLabel.text = artist.player.location;
            cell.detailTextLabel.text = @"Artist Location";
            break;
        default:
            cell.textLabel.text = artist.player.twitterScreenName;
            cell.detailTextLabel.text = @"Artist Twitter Handle";
            break;
    }
    
    
    
    return cell;
}



#pragma mark UITableViewDelegate

@end
