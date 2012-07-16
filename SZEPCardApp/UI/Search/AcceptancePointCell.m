//
//  AcceptancePointCell.m
//  SZEPCardApp
//
//  Created by Karesz on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AcceptancePointCell.h"

@implementation AcceptancePointCell
@synthesize lbName;
@synthesize lbDistance;
@synthesize lbVouchers;
@synthesize imgvBackground;

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
    if(selected) {
        [imgvBackground setImage:[UIImage imageNamed:@"listaelembg_selected.png"]];
    } else {
        [imgvBackground setImage:[UIImage imageNamed:@"listaelembg.png"]];
    }
    
    
}

- (void)dealloc {
    [lbDistance release];
    [lbName release];
    [lbVouchers release];
    [imgvBackground release];
    [super dealloc];
}
@end
