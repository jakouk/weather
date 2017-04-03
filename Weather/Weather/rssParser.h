//
//  rssParser.h
//  Weather
//
//  Created by jakouk on 2017. 4. 3..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface rssParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSArray *books;
@property (nonatomic, retain) AppDelegate *appdelegate;
@property (nonatomic, retain) NSMutableString *curElem;

- (rssParser *) initXMLParser;


@end
