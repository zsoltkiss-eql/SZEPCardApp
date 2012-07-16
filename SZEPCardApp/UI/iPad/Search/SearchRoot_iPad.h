//
//  SearchRoot_iPad.h
//  SZEPCardApp
//
//  Created by Karesz on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Voucher.h"
#import "Settlement.h"

@interface SearchRoot_iPad : UIViewController <VoucherTypeSelecting>

@property (retain, nonatomic) IBOutlet UIView *searchPanel;

@property (retain, nonatomic) IBOutlet UISwitch *swLodging;
@property (retain, nonatomic) IBOutlet UISwitch *swHospitality;
@property (retain, nonatomic) IBOutlet UISwitch *swLeisure;


- (IBAction)switchValueChanged:(id)sender;

@end
