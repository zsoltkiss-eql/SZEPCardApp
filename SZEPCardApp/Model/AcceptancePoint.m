//
//  AcceptancePoint.m
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "AcceptancePoint.h"


@implementation AcceptancePoint
@synthesize acceptancePointID, name, lodgingAccepted, hospitalityAccepted, leisureAccepted, imageUrl1, imageUrl2, imageUrl3, imageUrl4, imageUrl5, settlementName, settlementZipCode, address, latitude, longitude, category, phone, email, website, paymentInAdvance, desc;

//az MKAnnotation protokoll altal eloirt (reszben optional) property-k
@dynamic coordinate, title, subtitle;

- (CLLocationDistance)calculateDistanceFrom:(CLLocation *)there {
    
    CLLocation *here = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    
    CLLocationDistance dist = [here distanceFromLocation:there];
    
    return dist;
}


#pragma mark - custom getters
- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    return coord;
}

- (NSString *)title {
    //TODO: az MKAnnotation protokoll copy attributumu property-kent irja elo! Lhet, hogy [name copy] kell???
    
    //return [name copy];
    
    return name;
    
    
}

- (NSString *)subtitle {
    
    
    //Utalvany tipusok formazasa 
    NSMutableString *ms1 = [[NSMutableString alloc]init];
    
    //ez segit eldonteni, hogy kell-e vesszot appendelni
    BOOL chainAlreadyHasElement = NO;
    
    [ms1 appendString:NSLocalizedString(@"Accepted voucher types: ", @"Leading text for voucher types label of a map view annotation")];
    
    if(self.lodgingAccepted ) {
        [ms1 appendString:NSLocalizedString(@"Lodging", nil)];
        chainAlreadyHasElement = YES;
    }
    
    if(self.hospitalityAccepted) {
        if(chainAlreadyHasElement) {
            [ms1 appendString:@", "];
        }
        
        [ms1 appendString:NSLocalizedString(@"Hospitality", nil)];
        chainAlreadyHasElement = YES;
    }
    
    if(self.leisureAccepted) {
        if(chainAlreadyHasElement) {
            [ms1 appendString:@", "];
        }
        
        [ms1 appendString:NSLocalizedString(@"Leisure", nil)];
        chainAlreadyHasElement = YES;
    }
    
    return [ms1 autorelease];

    
}

#pragma mark - dealloc
- (void)dealloc {
    [name release];
    [imageUrl1 release];
    [imageUrl2 release];
    [imageUrl3 release];
    [imageUrl4 release];
    [imageUrl5 release];
    
    [settlementName release];
    [settlementZipCode release];
    [address release];
    
    [category release];
    
    [phone release];
    [email release];
    [website release];
    
    [desc release];
    
    [super dealloc];
}

@end
