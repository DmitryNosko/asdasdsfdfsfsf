//
//  FeedItemRepository.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/13/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import <sqlite3.h>

@interface SQLFeedItemRepository : NSObject {
    sqlite3* rssDataBase;
}

+ (instancetype) sharedSQLFeedItemRepository;
- (FeedItem *) addFeedItem:(FeedItem *) item;
- (NSMutableArray<FeedItem *>*) feedItemsForResource:(NSInteger) identifier;
- (void) updateFeedItem:(FeedItem *) item;
- (void) removeFeedItem:(FeedItem *) item;
- (void) removeFeedItemForResource:(NSInteger) identifier;
- (void) removeAllFeedItems;
- (NSMutableArray<FeedItem *>*) favoriteFeedItems;
- (NSMutableArray<NSString *>*) favoriteFeedItemLinks;
- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks;
- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks;
@end
