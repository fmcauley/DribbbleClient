//
//  FMSFetchDribbbleData.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#define kDribbbleBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kDribbbleURLEveryoneURL [NSURL URLWithString:@"http://api.dribbble.com/shots/everyone?per_page=30"]

#import "FMSFetchDribbbleData.h"
#import "FMSAppDelegate.h"
#import "Shot.h"
#import "Player.h"

@interface FMSFetchDribbbleData ()

- (void)fetchInitalDataFromDribbble;
- (void)parseDribbbleData:(NSData *)responseData;

@end

@implementation FMSFetchDribbbleData

- (void)fetchDribbbleData
{
    
    [self fetchInitalDataFromDribbble];
    
}

- (void)fetchArtistDataFromDribbble:(NSString *)artistId
{
    NSString *urlArtist = [NSString stringWithFormat:@"http://api.dribbble.com/players/%@/shots", artistId];
    NSURL *artistURL = [NSURL URLWithString:urlArtist];
    
    dispatch_async(kDribbbleBGQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        artistURL];
        [self performSelectorOnMainThread:@selector(parseDribbbleData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

- (void)fetchInitalDataFromDribbble
{
    dispatch_async(kDribbbleBGQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kDribbbleURLEveryoneURL];
        [self performSelectorOnMainThread:@selector(parseDribbbleData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)parseDribbbleData:(NSData *)responseData
{
    FMSAppDelegate *appDelegate=(FMSAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* shots = [json objectForKey:@"shots"];
    
    for (NSDictionary *shotDic in shots) {
        
        // Shot Data
        NSEntityDescription *shotEntity = [NSEntityDescription entityForName:@"Shot"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
        Shot *newShot  = [[Shot alloc]initWithEntity:shotEntity
                      insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        
        /** Check if objects exists */
        NSError *error;
        NSFetchRequest *checkForDuplacate = [[NSFetchRequest alloc]init];
        checkForDuplacate.entity = shotEntity;
        checkForDuplacate.fetchLimit = 1;
        checkForDuplacate.predicate = [NSPredicate predicateWithFormat:@"shotId == %@", [shotDic[@"id"] stringValue]];
        Shot *shotsInDataBase = [[appDelegate.managedObjectContext executeFetchRequest:checkForDuplacate error:&error]lastObject];
        
       if (!shotsInDataBase)
       {
        newShot.shotId = [shotDic[@"id"] stringValue];
        newShot.title = shotDic[@"title"];
        newShot.height = shotDic[@"height"];
        newShot.width = shotDic[@"width"];
        newShot.likeCount = shotDic[@"likes_count"];
        newShot.commentsCount = shotDic[@"comments_count"];
        newShot.reboundsCount = shotDic[@"rebounds_count"];
        newShot.url = shotDic[@"url"];
        newShot.shortUrl = shotDic[@"short_url"];
        newShot.viewCount = shotDic[@"views_count"];
        newShot.reboundSourceId = [self validateNumberDataFromJSON:shotDic[@"rebound_source_id"]];
        newShot.imageUrl = shotDic[@"image_url"];
        newShot.imageTeaseUrl = shotDic[@"image_teaser_url"];
        newShot.createdAt = shotDic[@"created_at"];
        
        // Player Data
        NSEntityDescription *playerEntity = [NSEntityDescription entityForName:@"Player"
                                                        inManagedObjectContext:appDelegate.managedObjectContext];
        newShot.player =  [[Player alloc]initWithEntity:playerEntity
                            insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        
        newShot.player.playerId = [shotDic[@"player"][@"id"]stringValue];
        newShot.player.name = [self validateStringDataFromJSON:shotDic[@"player"][@"name"]];
        newShot.player.location = [self validateStringDataFromJSON:shotDic[@"player"][@"location"]];
        newShot.player.followersCount = shotDic[@"player"][@"followers_count"];
        newShot.player.drafteesCount = shotDic[@"player"][@"draftees_count"];
        newShot.player.likesCount = shotDic[@"player"][@"likes_count"];
        newShot.player.likesReceivedCount = shotDic[@"player"][@"likes_received_count"];
        newShot.player.commentsCount = shotDic[@"player"][@"comments_count"];
        newShot.player.commentsReceivedCount = shotDic[@"player"][@"comments_received_count"];
        newShot.player.reboundsCount = shotDic[@"player"][@"rebounds_count"];
        newShot.player.reboundsReceivedCount = shotDic[@"player"][@"rebounds_received_count"];
        newShot.player.url = [self validateStringDataFromJSON:shotDic[@"player"][@"url"]];
        newShot.player.avatarUrl = [self validateStringDataFromJSON:shotDic[@"player"][@"avatar_url"]];
        newShot.player.userName = [self validateStringDataFromJSON:shotDic[@"player"][@"user_name"]];
        newShot.player.twitterScreenName = [self validateStringDataFromJSON:shotDic[@"player"][@"twitter_screen_name"]];
        newShot.player.websiteUrl = [self validateStringDataFromJSON:shotDic[@"player"][@"website_url"]];
        newShot.player.draftedByPlayerId = [self validateNumberDataFromJSON:shotDic[@"player"][@"drafted_by_player_id"]];
        newShot.player.shotsCount = shotDic[@"player"][@"shots_count"];
        newShot.player.followingCount = shotDic[@"player"][@"following_count"];
        newShot.player.createdAt = shotDic[@"player"][@"created_at"];
        
        [appDelegate saveContext];
       }
    }
    
    [self.delegate refreshContextData];
}

- (NSString*)validateStringDataFromJSON:(NSString*)jsonString
{
    if (jsonString == (id)[NSNull null] || jsonString.length == 0)
    {
        return @"empty";
    } else
        return jsonString;
}

- (NSNumber*)validateNumberDataFromJSON:(NSNumber*)jsonNumber
{
    if (jsonNumber == (id)[NSNull null])
    {
        return [NSNumber numberWithInt:0];
    } else
        return jsonNumber;
}

@end
