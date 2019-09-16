//
//  SQLFeedItemService.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/16/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItemServiceProtocol.h"

@interface SQLFeedItemService : NSObject <FeedItemServiceProtocol>
+(instancetype) sharedSQLFeedItemService;
@end

