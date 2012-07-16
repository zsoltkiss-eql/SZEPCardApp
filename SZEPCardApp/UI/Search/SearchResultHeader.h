//
//  SearchResultHeader.h
//  SZEPCardApp
//
//  Created by Karesz on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    A SearchResult.m-ben megjelenitett table view fejlecet reprezentalo kontroller illetve view.
    Ez felel az elfogadohelyek nev-, illetve tavolsag szeirnti ujrarendezeseert.
 
    A SearchRoot mint kliens implementalja a ModelReorderDelegate protokolt es igy ertesitest kap arrol, hogy a modell at lett rendezve.
 
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol ModelReorderDelegate <NSObject>

- (void)reorderController:(UIViewController *)viewController didResultIn:(NSArray *)reorderedResult;

@end

@interface SearchResultHeader : UIViewController 

//nev szerinti rendezes gombja
@property (retain, nonatomic) IBOutlet UIButton *btn1;

//tavolsag szerinti rendezes gombja
@property (retain, nonatomic) IBOutlet UIButton *btn2;

//arra szamitunk, hogy AcceptaincePoint objektumok lesznek a tombben
@property (nonatomic, retain) NSArray *datasource;

@property (nonatomic, retain) CLLocation *deviceLocation;

@property (nonatomic, assign) id<ModelReorderDelegate> delegate;

- (IBAction)orderResults:(id)sender;





@end
