//
//  PinAnnotationForAP.m
//  SZEPCardApp
//
//  Created by Karesz on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PinAnnotationForAP.h"

@interface PinAnnotationForAP() {
@private
    AcceptancePoint *acceptancePoint_;
}
@end

@implementation PinAnnotationForAP
@dynamic apId, apLocation;

#pragma mark - initializer

- (id)initWithAcceptancePoint:(AcceptancePoint *)ap andReuseIdentifier:(NSString *)reuseId {
    self = [super initWithAnnotation:ap reuseIdentifier:reuseId];
    
    if(self) {
        acceptancePoint_ = ap;
        [acceptancePoint_ retain];
    }
    
    return self;
}

#pragma mark - custom getter
- (NSInteger)apId {
    return [acceptancePoint_ acceptancePointID];
}

- (CLLocation *)apLocation {
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:acceptancePoint_.latitude longitude:acceptancePoint_.longitude];
    
    return [loc autorelease];
}

#pragma mark - dealloc

- (void)dealloc {
    [acceptancePoint_ release];
    [super dealloc];
}

@end
