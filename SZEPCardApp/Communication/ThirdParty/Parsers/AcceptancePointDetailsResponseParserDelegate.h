//
//  AcceptancePointDetailsResponseParserDelegate.h
//  SZEPCardApp
//
//  Created by Karesz on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcceptancePoint.h"

@interface AcceptancePointDetailsResponseParserDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, readonly) AcceptancePoint *acceptancePoint;

@end
