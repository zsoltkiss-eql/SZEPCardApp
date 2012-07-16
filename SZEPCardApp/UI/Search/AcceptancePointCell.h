//
//  AcceptancePointCell.h
//  SZEPCardApp
//
//  Created by Karesz on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcceptancePointCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lbName;
@property (retain, nonatomic) IBOutlet UILabel *lbDistance;
@property (retain, nonatomic) IBOutlet UILabel *lbVouchers;

@property (retain, nonatomic) IBOutlet UIImageView *imgvBackground;


@end
