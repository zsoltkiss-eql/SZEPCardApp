//
//  Base64Impl.h
//  SZEPCardApp
//
//  Created by Karesz on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Impl : NSObject

+ (NSString *)encode:(NSData *)plainText;

@end
