//
//  FilefeedItemRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface FileFeedItemRepository : NSObject
+(instancetype) sharedFileFeedItemRepository;

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName;
- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName;
- (void) saveString:(NSString *) itemURLString toFile:(NSString*) fileName;
- (NSMutableArray<NSString *>*) readStringsFromFile:(NSString *) fileName;

- (void) removeFeedItem:(FeedItem *) item fromResource:(FeedResource *) resource;
- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index forResource:(FeedResource *) resource;

- (void)createAndSaveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName;

//

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(FeedResource *) resource;
- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(FeedResource *) resource;
- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(FeedResource *) resource;

@end

