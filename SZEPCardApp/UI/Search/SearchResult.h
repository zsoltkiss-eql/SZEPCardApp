//
//  SearchResult.h
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Elfogadohelyek listaja. Tablazatos nezet.
    A datasource egy webservice hivas eredmenyekent all elo.
 
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchResultHeader.h"

#import "SearchCriteria.h"


@interface SearchResult : UITableViewController <CLLocationManagerDelegate, ModelReorderDelegate> {
    NSMutableArray *acceptancePoints;
}

@property (nonatomic, retain) NSArray *acceptancePoints;
@property (nonatomic, retain) SearchCriteria *criteria;


@end
