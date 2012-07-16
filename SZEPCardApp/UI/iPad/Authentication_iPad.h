//
//  Authentication_iPad.h
//  SZEPCardApp
//
//  Created by Karesz on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkflowPoller.h"

@interface Authentication_iPad : UIViewController <WorkflowPollerDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *inputPanel;

@property (retain, nonatomic) IBOutlet UITextField *tfCardNumber;

@property (retain, nonatomic) IBOutlet UITextField *tfTeleCode;

@property (retain, nonatomic) IBOutlet UIView *resultPanel;

@property (retain, nonatomic) IBOutlet UILabel *lbHospitalityValue;

@property (retain, nonatomic) IBOutlet UILabel *lbLeisureValue;

@property (retain, nonatomic) IBOutlet UILabel *lbLodgingValue;

@property (retain, nonatomic) IBOutlet UILabel *lbQueryDateValue;

- (IBAction)doneEditing:(id)sender;

- (IBAction)startTransaction:(id)sender;


@end
