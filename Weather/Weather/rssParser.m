//
//  rssParser.m
//  Weather
//
//  Created by jakouk on 2017. 4. 3..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "rssParser.h"
@class AppDelegate;

@implementation rssParser

- (rssParser *) initXMLParser {
    
    self = [super init];
    self.appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

//-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
//{
//    if([elementName isEqualToString:@"Books"]) {
//        //Initialize the array.
//        self.appdelegate.books = [[NSMutableArray alloc] init];
//    }
//    else if([elementName isEqualToString:@"Book"]) {
//        
//        //Initialize the book.
//        book = [[Book alloc] init];
//        
//        //Extract the attribute here.
//        book.bookID = [[attributeDict objectForKey:@"id"] integerValue];
//        
//        NSLog(@"Reading id value :%i", book.bookID);
//    }
//    
//    NSLog(@"Processing Element: %@", elementName);
//}
//
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    
//    if(!self.curElem)
//        self.curElem = [[NSMutableString alloc] initWithString:string];
//    else
//        [self.curElem appendString:string];
//    
//    NSLog(@"Processing Value: %@", self.curElem);
//    
//}
//
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    
//    if([elementName isEqualToString:@"Books"])
//        return;
//    
//    if([elementName isEqualToString:@"Book"]) {
//        [self.appdelegate.books addObject:book];
//        
//        [book release];
//        book = nil;
//    }
//    else
//        [book setValue:curElem forKey:elementName];
//    
//    [curElem release];
//    curElem = nil;
//}


@end
