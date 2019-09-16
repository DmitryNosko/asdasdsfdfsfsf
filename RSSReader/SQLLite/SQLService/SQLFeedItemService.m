//
//  SQLFeedItemService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "SQLFeedItemService.h"
#import "SQLFeedItemRepository.h"

@interface SQLFeedItemService()
@property (strong, nonatomic) SQLFeedItemRepository* feedItemRepository;
@end

@implementation SQLFeedItemService

static SQLFeedItemService* shared;

+(instancetype) sharedSQLFeedItemService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SQLFeedItemService new];
        shared.feedItemRepository = [SQLFeedItemRepository sharedSQLFeedItemRepository];
    });
    return shared;
}

- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items {
    FeedResource* resource = [items firstObject].resource;
    [self.feedItemRepository removeFeedItemForResource:resource.identifier];
    NSMutableArray<FeedItem *>* createdItems = [self addFeedItems:items];
    return createdItems;
}

- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items {
    
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    for (FeedItem* item in items) {
        [resultItems addObject:[self addFeedItem:item]];
    }
    
    return resultItems;
}

- (FeedItem *) addFeedItem:(FeedItem *) item {
    if ([self.feedItemRepository respondsToSelector:@selector(addFeedItem:)]) {
        return [self.feedItemRepository addFeedItem:item];
    } else {
        return nil;
    }
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(FeedResource *) resource; {
    return [self.feedItemRepository feedItemsForResource:resource.identifier];
}

- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index forResource:(FeedResource *) resource {
    [self.feedItemRepository updateFeedItem:item];
}

- (void) removeFeedItem:(FeedItem *) item fromResource:(FeedResource *) resource {
    [self.feedItemRepository removeFeedItem:item];
}

- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository favoriteFeedItems];
}

- (NSMutableArray<NSString *>*) favoriteFeedItemLinks:(NSMutableArray<FeedResource *>*) resources {
    return [self.feedItemRepository favoriteFeedItemLinks];
}

- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks {
    return [self.feedItemRepository readingInProgressFeedItemLinks];
}

- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks {
    return [self.feedItemRepository readingCompliteFeedItemLinks];
}


@end
