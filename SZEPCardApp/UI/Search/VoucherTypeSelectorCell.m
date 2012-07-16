//
//  VoucherTypeSelectorCell.m
//  SZEPCardApp
//
//  Created by Karesz on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoucherTypeSelectorCell.h"

@implementation VoucherTypeSelectorCell
@synthesize swTypeSelection;
@synthesize imgvInfo;
@synthesize lbVoucherType;
@synthesize voucherTypeForThisCell;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - event handlers
- (IBAction)switchValueChanged:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    if(aSwitch.isOn) {
        NSLog(@"this switch %@ is ON", aSwitch);
        
        [delegate addVoucherTypeToSearchCriteria:voucherTypeForThisCell];
    } else {
        NSLog(@"this switch %@ is OFF", aSwitch);
        [delegate removeVoucherTypeFromSearchCriteria:voucherTypeForThisCell];
    }
    
    
    
}


/*
    Ez a gesture recignizer az IB-ben arra a UIImageView-ra lett felteve, amely az info.png-t tartalmazza. Tehat elvileg ez a metodus CSAK AKKOR hivodhat, ha az info ikont megerinti a user
 */
- (IBAction)someGestureRecognized:(id)sender {
    
    NSLog(@"info button tapped? %@", sender);
    
    [delegate showInfoPageForVoucherType:voucherTypeForThisCell];
   
}

/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"info button tapped?");
    
    //[delegate showInfoPageForVoucherType:voucherTypeForThisCell];
}
 */

#pragma mark - dealloc

- (void)dealloc {
    [delegate release];
    [swTypeSelection release];
    [imgvInfo release];
    [lbVoucherType release];
    [super dealloc];
}
@end
