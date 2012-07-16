//
//  SearchRoot.h
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Voucher.h"
#import "Settlement.h"



@interface SearchRoot : UIViewController <UITableViewDataSource, VoucherTypeSelecting, UISearchBarDelegate> {
    
    
}

//az a UIView, aki a UISwitch-eket es az info gombokat tartalmazza
@property (retain, nonatomic) IBOutlet UIView *voucherTypeSelectorHolder;


@property (retain, nonatomic) IBOutlet UISegmentedControl *scSearchType;

//az alabbi 2 outlet csak azert kell, mert amikor dinamikus beszurunk egy UISearchBar-t, akkor ezeket lejjeb kell mozgatni!
@property (retain, nonatomic) IBOutlet UISegmentedControl *scSearchRadius;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;

@property (nonatomic, retain) Settlement *settlementSelected;

- (IBAction)doSearch:(id)sender;

- (IBAction)toggleSearchType:(id)sender;

- (IBAction)toggleSearchRadius:(id)sender;

- (IBAction)switchValueChanged:(id)sender;

- (IBAction)someGestureRecognized:(id)sender;



@end
