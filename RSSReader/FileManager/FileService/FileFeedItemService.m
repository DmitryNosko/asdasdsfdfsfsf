//
//  FeedItemFileService.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileFeedItemService.h"
#import "FileFeedItemRepository.h"

@interface FileFeedItemService ()
@property (strong, nonatomic) FileFeedItemRepository* fileFeedItemRepository;
@end

static NSString* READED_NEWS = @"readedNews.txt";
static NSString* READING_IN_PROGRESS = @"readingInProgressNews.txt";
static NSString* FAVORITES_NEWS_FILE_NIME = @"favoritiesNews.txt";
static NSString* TXT_FORMAT_NAME = @".txt";

@implementation FileFeedItemService

static FileFeedItemService* shared;

+(instancetype) sharedFileFeedItemService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FileFeedItemService new];
        shared.fileFeedItemRepository = [FileFeedItemRepository sharedFileFeedItemRepository];
    });
    return shared;
}

- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items {
    FeedResource* resource = [items firstObject].resource;
    [self.fileFeedItemRepository createAndSaveFeedItems:items toFileWithName:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
    return items;
}

- (NSMutableArray<FeedItem *>*) feedItemsForResource:(FeedResource *) resource {

}
//
//- (void) updateFeedItem:(FeedItem *) item {
//
//}
//
//- (void) removeFeedItem:(FeedItem *) item {
//
//}
//
//- (NSMutableArray<FeedItem *>*) favoriteFeedItems:(FeedResource*) resource { //add FeedResource as parametr
//    return [self.fileFeedItemRepository readFeedItemsFile:FAVORITES_NEWS_FILE_NIME];
//}
//
//- (NSMutableArray<NSString *>*) favoriteFeedItemLinks {
//
//}
//
//- (NSMutableArray<NSString *>*) readingInProgressFeedItemLinks {
//    return [self.fileFeedItemRepository readStringsFromFile:READING_IN_PROGRESS];
//}
//
//- (NSMutableArray<NSString *>*) readingCompliteFeedItemLinks {
//    return [self.fileFeedItemRepository readStringsFromFile:READED_NEWS];
//}

@end
