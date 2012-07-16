//
//  SearchCriteria.h
//  SZEPCardApp
//
//  Created by Karesz on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Az aktualis kereses parameterit enkapszulalo osztaly.
    Ennek a peldanyat adogatjuk at a view kontrollerek kozott.
 
 */

#import <Foundation/Foundation.h>
#import "Settlement.h"

//a kereses vagy geolokacio- vagy telepules alapu
typedef enum {
    NOT_SELECTED = -1,
    GEOLOCATION_BASED,
    SETTLEMENT_BASED
} SearchType;

@interface SearchCriteria : NSObject

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

//az a telepulesnev, amelyen belul keressen (csak SETTLEMENT_BASED eseten ertelmezett)
@property (nonatomic, retain) Settlement *settlement;

//kereses sugara a felhasznalo aktualis poziciojatol
@property (nonatomic) int searchRadius;

@property (nonatomic) SearchType searchType;

//az egyes utalvanyotipusok kozul melyik az elvart; ezek is mint keresesi parameterek szerepelnek, szukitik a talalati listat. A 3rd party webservice elvarja oket mint bemeno parametereket.
@property (nonatomic) BOOL hospitalityExpected;
@property (nonatomic) BOOL lodgingExpected;
@property (nonatomic) BOOL leisureExpected;

@end
