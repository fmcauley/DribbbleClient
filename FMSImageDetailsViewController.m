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

@interface FMSImageDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@end

@implementation FMSImageDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
