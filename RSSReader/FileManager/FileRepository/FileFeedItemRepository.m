//
//  FilefeedItemRepository.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FileFeedItemRepository.h"

@interface FileFeedItemRepository()
@property (strong, nonatomic) NSFileManager* fileManager;
@end

static NSString* TXT_FORMAT_NAME = @".txt";

@implementation FileFeedItemRepository

static FileFeedItemRepository* shared;

+(instancetype) sharedFileFeedItemRepository {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FileFeedItemRepository new];
        shared.fileManager = [NSFileManager defaultManager];
    });
    return shared;
}

#pragma mark - FeedItem

- (void)saveFeedItem:(FeedItem*) item toFileWithName:(NSString*) fileName {
    
    NSMutableArray* encodedItems = [[NSMutableArray alloc] initWithObjects:[NSKeyedArchiver archivedDataWithRootObject:item], nil];
    
    NSData* encodedArray = [NSKeyedArchiver archivedDataWithRootObject:encodedItems];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        //load file
        NSMutableArray<FeedItem *>* decodedItems = [self readFeedItemsFile:fileName];
        NSMutableArray<NSData *>* encodedFileContent = [[NSMutableArray alloc] init];
        for (FeedItem* decodedItem in decodedItems) {
            [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:decodedItem]];
        }
        
        [encodedFileContent addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:encodedFileContent];
        [encodedFileData writeToFile:filePath atomically:YES];
        
    } else {
        [self.fileManager createFileAtPath:filePath contents:encodedArray attributes:nil];
    }
}

- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index forResource:(FeedResource *) resource {
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
    if ([items count] > 1) {
        [items replaceObjectAtIndex:index withObject:item];
        [self cleanSaveFeedItems:items forResource:resource];
    }
}

//- (void) updateFeedItem:(FeedItem *) item atIndex:(NSUInteger) index inFile:(NSString *) fileName {
//    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
//    if ([items count] > 1) {
//        [items replaceObjectAtIndex:index withObject:item]; //// copy
//        [self createAndSaveFeedItems:items toFileWithName:fileName];
//    }
//}

- (NSMutableArray<FeedItem *> *) readFeedItemsFile:(NSString*) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData* fileContent = [fileHandle readDataToEndOfFile];
    
    NSMutableArray<NSData *>* encodedObjects = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    NSMutableArray<FeedItem *>* decodedItems = [[NSMutableArray alloc] init];
    
    for (NSData* data in encodedObjects) {
        FeedItem* item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (item) {
            [decodedItems addObject:item];
        }
    }
    
    return decodedItems;
}

- (void) removeFeedItem:(FeedItem *) item  fromFile:(NSString *) fileName {
    
    NSMutableArray<FeedItem *>* items = [self readFeedItemsFile:fileName];
    
    for (FeedItem* feedItem in [items copy]) {
        if ([feedItem.link isEqualToString:item.link]) {
            [items removeObject:feedItem];
        }
    }
    
    [self removeAllObjectsFormFile:fileName];
    
    for (FeedItem* fI in [items copy]) {
        [self saveFeedItem:fI toFileWithName:fileName];
    }
}

//- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items forResource:(FeedResource *) resource {
//    NSMutableArray<NSData*>* encodedItems = [[NSMutableArray alloc] init];
//
//    for (FeedItem* item in [items copy]) {
//        [encodedItems addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
//    }
//
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentDirectory = [paths objectAtIndex:0];
//    NSString* filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
//
//    [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:encodedItems] attributes:nil];
//    return [self readFeedItemsFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
//}

- (void)createAndSaveFeedItems:(NSMutableArray<FeedItem*>*) items toFileWithName:(NSString*) fileName {
    NSMutableArray<NSData*>* encodedItems = [[NSMutableArray alloc] init];

    for (FeedItem* item in [items copy]) {
        [encodedItems addObject:[NSKeyedArchiver archivedDataWithRootObject:item]];
    }

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];

    [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:encodedItems] attributes:nil];
}

- (NSMutableArray<NSString *>*) readStringsFromFile:(NSString *) fileName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData* fileContent = [fileHandle readDataToEndOfFile];
    NSMutableArray<NSString *>* decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
    return decodedArray ? decodedArray : [[NSMutableArray alloc] init];
}

- (void) saveString:(NSString *) stringToSave toFile:(NSString *) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData* fileContent = [fileHandle readDataToEndOfFile];
        NSMutableArray<NSString *>* savedItems = [NSKeyedUnarchiver unarchiveObjectWithData:fileContent];
        if (savedItems) {
            [savedItems addObject:stringToSave];
        } else {
            savedItems = [[NSMutableArray alloc] initWithObjects:stringToSave, nil];
        }
        
        
        NSData* encodedFileData = [NSKeyedArchiver archivedDataWithRootObject:savedItems];
        [encodedFileData writeToFile:filePath atomically:YES];
    } else {
        [self.fileManager createFileAtPath:filePath contents:[NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] initWithObjects:stringToSave, nil]] attributes:nil];
    }
}

- (void) removeFeedItem:(FeedItem *) item fromResource:(FeedResource *) resource {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:resource.favoritesNewsLinks];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        
        NSMutableArray<NSString *>* strings = [self readStringsFromFile:resource.favoritesNewsLinks];
        
        for (NSString* str in [strings copy]) {
            if ([str isEqualToString:item.link]) {
                [strings removeObject:str];
            }
        }
        
        [self removeAllObjectsFormFile:resource.favoritesNewsLinks];
        
        for (NSString* str in strings) {
            [self saveString:str toFile:resource.favoritesNewsLinks];
        }
        
    }
}


- (void) removeAllObjectsFormFile:(NSString *) fileName {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    [self.fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

@end
