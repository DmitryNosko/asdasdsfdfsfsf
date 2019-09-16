//
//  FeedItemServiceProtocol.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "FeedResource.h"

@protocol FeedItemServiceProtocol <NSObject>

@required

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks;
- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks;

@optional

#pragma mark -SQL

- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items;//analog createAndSaveFeedItems
- (NSMutableArray<FeedItem *>*) feedItemsForResource:(FeedResource *) resource;
- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index forResource:(FeedResource *) resource; // analog updateFeedItem ind filename
- (void) removeFeedItem:(FeedItem *) item fromResource:(FeedResource *) resource;//analog removeString
- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources;
- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources;

#pragma mark - FILE

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName;
- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName;
- (void) removeFeedItem:(FeedItem *) item  fromFile:(NSString *) fileName;
- (void) saveString:(NSString *) itemURLString toFile:(NSString*) fileName;
- (NSMutableArray<NSString *>*) readStringsFromFile:(NSString *) fileName;



@end


