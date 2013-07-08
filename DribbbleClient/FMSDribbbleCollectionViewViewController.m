//
//  FMSDribbbleCollectionViewViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "FMSDribbbleCollectionViewViewController.h"
#import "FMSAppDelegate.h"
#import "FMSFetchDribbbleData.h"
#import "FMSDribbbleImageCell.h"
#import "Shot.h"
#import "FMSImageDetailsViewController.h"

@interface FMSDribbbleCollectionViewViewController () <FMSFetchDribbbleData>

@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *fetchedItems;
@property (nonatomic, strong) FMSFetchDribbbleData *dribbleData;

@end

@implementation FMSDribbbleCollectionViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageCache = [[NSCache alloc]init];

    self.dribbleData = [[FMSFetchDribbbleData alloc]init];
    self.dribbleData.delegate = self;
    [self.dribbleData fetchDribbbleData];
   
    FMSAppDelegate *appDelegate=(FMSAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.imageCache = nil;
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
    
    NSData *data = [self.imageCache objectForKey:key];
    
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        cell.dribbbleImage.image = image;
    }
    
    else {cell.dribbbleImage.image = [UIImage imageNamed:@"placeholder1.jpg"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [self.imageCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.dribbbleImage.image = image;
            });
        });
    }
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
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    
    self.fetchedItems = [[NSArray alloc]initWithArray:mutableFetchResults];
    
    [self.collectionView reloadData];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"imageDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        FMSImageDetailsViewController *detail = (FMSImageDetailsViewController*)[segue destinationViewController];
        detail.imageDetails = self.fetchedItems[indexPath.row];
    }
}

@end
