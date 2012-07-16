//
//  VoucherTypeSelectorCell.h
//  SZEPCardApp
//
//  Created by Karesz on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voucher.h"



@interface VoucherTypeSelectorCell : UITableViewCell


//minden egyes cella egy konkret voucher type-ot reprezental (szallashely, vendeglatas vagy szabadido
@property (nonatomic) NSInteger voucherTypeForThisCell;

//a delegate-re jobb LENNE weak referencia! Ui. korkoros egymasra hivatkozas johet letre, ha a kontroller retain-eli a cellat, a cellat meg visszamutat a a delegate-jere akit retain-el. Ezt el akarnank kerulni... Viszont ha csak sima (nonatomic) property-t allitok be, akkor a default az "assign" viselkedes lesz, az meg csak garbage collectoros kornyzetben ertlemezett! Emiatt sarga warninggal jeloli az editor!!!
@property (nonatomic, assign) id<VoucherTypeSelecting> delegate;

@property (retain, nonatomic) IBOutlet UISwitch *swTypeSelection;
@property (retain, nonatomic) IBOutlet UIImageView *imgvInfo;
@property (retain, nonatomic) IBOutlet UILabel *lbVoucherType;


- (IBAction)switchValueChanged:(id)sender;

- (IBAction)someGestureRecognized:(id)sender;


@end
