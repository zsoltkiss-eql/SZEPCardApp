//
//  Authentication.h
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkflowPoller.h"

#define INDICATOR_SIZE 25.0f
#define INDICATOR_MARGIN 25.0f
#define INDICATOR_CORNER_RADIOUS 7.0f

@interface Authentication : UIViewController <WorkflowPollerDelegate, UITextFieldDelegate>{

}

@property (retain, nonatomic) IBOutlet UITextField *tfCardNumber;

@property (retain, nonatomic) IBOutlet UITextField *tfTeleCode;

- (IBAction)balanceInquiry:(id)sender;

- (IBAction)doneEditing:(id)sender;

@end
