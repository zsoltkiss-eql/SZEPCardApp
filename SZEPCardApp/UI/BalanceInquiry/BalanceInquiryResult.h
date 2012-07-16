//
//  BalanceInquiryResult.h
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutputBalanceQuery.h"

@interface BalanceInquiryResult : UIViewController 

@property (retain, nonatomic) IBOutlet UILabel *lbHospitalityValue;
@property (retain, nonatomic) IBOutlet UILabel *lbLeisureValue;
@property (retain, nonatomic) IBOutlet UILabel *lbLodgingValue;
@property (retain, nonatomic) IBOutlet UILabel *lbDateOfQuery;
@property (retain, nonatomic) IBOutlet UIView *tblBackgroundView;

@property (nonatomic, retain) OutputBalanceQuery *outputBalanceQuery;


- (IBAction)dismissModal:(id)sender;


@end
