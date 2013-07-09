//
//  FMSImageDetailsViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/8/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "FMSImageDetailsViewController.h"
#import "Shot.h"
#import "Player.h"
#import "FMSArtistDetailViewController.h"

@interface FMSImageDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;



@end

@implementation FMSImageDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.imageDetails.title;
    
    
    // Load the image // TODO: DRY this up.
    
    NSURL *imageURL = [NSURL URLWithString:self.imageDetails.imageUrl];
    
   self.detailImageView.image = [UIImage imageNamed:@"placeholder1.jpg"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailImageView.image = image;
            });
        });
    

    // add the artist name
    self.artistName.text = self.imageDetails.player.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"artistDetail"]) {
       
        FMSArtistDetailViewController *detail = (FMSArtistDetailViewController*)[segue destinationViewController];
        detail.artist = self.imageDetails;
    }
}


@end
