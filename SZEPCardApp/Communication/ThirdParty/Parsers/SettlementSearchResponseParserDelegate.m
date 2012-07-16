//
//  SettlementSearchResponseParserDelegate.m
//  SZEPCardApp
//
//  Created by Karesz on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettlementSearchResponseParserDelegate.h"

#import "Settlement.h"


typedef enum {
    OUT_OF_SCOPE,
    IN_COLLECTION,
    IN_RECORD,
    IN_PROPERTY
} ParsePosition;

@interface SettlementSearchResponseParserDelegate() {
@private
    NSMutableString *currentProperty_;
    
    //mivel az adatstruktura tomb, ezert szerepe van a sorrendnek! Az index-bol tudjuk, melyik property-jerol van szo a Settlement objektumnak.
    int currentPropertyIndex_;
    
    //ebben gyujtjuk a Settlement objektumokat
    NSMutableArray *result_;
    
    Settlement *currentSettlement_;
    
    ParsePosition parsePos_;
}
@end

@implementation SettlementSearchResponseParserDelegate 
@dynamic listOfSettlements;

#pragma mark - initializer
- (id)init {
    self = [super init];
    
    if(self) {
        //mivel 2-szeresen egymasba agyazott <item> elemek vannak, a legkulso <item> elerese jelenti egy record-nak a hatarat
        parsePos_ = OUT_OF_SCOPE;
        currentProperty_ = [[NSMutableString alloc]init];
        
        currentPropertyIndex_ = -1;
    }
    
    return self;
}

#pragma mark - NSXMLParserDelegate protocol

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"return"]) {
        parsePos_ = IN_COLLECTION;
        result_ = [[NSMutableArray alloc]init];
    } else if([elementName isEqualToString:@"item"]) {
        
        if(parsePos_ == IN_COLLECTION) {
            //elertunk egy kulsoszintu <item> elemet 
            parsePos_ = IN_RECORD;
            
            if(currentSettlement_ != nil) {
                [currentSettlement_ release];
                currentSettlement_ = nil;
            }
            
            currentSettlement_ = [[Settlement alloc]init];
        } else if(parsePos_ == IN_RECORD) {
            parsePos_ = IN_PROPERTY;
            
            currentPropertyIndex_ ++;
            
            [currentProperty_ release];
            currentProperty_ = nil;
            
            currentProperty_ = [[NSMutableString alloc]init];
        }
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"item"]) {
        
        if(parsePos_ == IN_PROPERTY) {
            
            //elertuk egy beagyazott </item> reszt, azaz egy property hatarat...
            
            switch (currentPropertyIndex_) {
                case 0: {
                    [currentSettlement_ setZipCode:currentProperty_];
                    break;
                }
                    
                case 1: {
                    [currentSettlement_ setName:currentProperty_];
                    break;
                }
                    
                default:
                    break;
            }
            
            parsePos_ = IN_RECORD;

        } else if(parsePos_ == IN_RECORD) {
            [result_ addObject:currentSettlement_];
            parsePos_ = IN_COLLECTION;
            currentPropertyIndex_ = -1;
        } else if(parsePos_ == IN_COLLECTION) {
            //elhagyjuk az utolso bezaro </item> elemet is...
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [currentProperty_ appendString:string];
}

#pragma mark - custom getters/setters

- (NSArray *)listOfSettlements {
    return [NSArray arrayWithArray:result_];
}

#pragma mark - dealloc
- (void) dealloc {
    [currentProperty_ release];
    [result_ release];
    
    [super dealloc];
}

@end
