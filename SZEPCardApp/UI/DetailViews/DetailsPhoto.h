//
//  DetailsPhoto.h
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.08..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsPhoto : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *imageViewForPhoto;
@property (retain, nonatomic) UIImage *photoImage;

@property (retain, nonatomic) IBOutlet UIImageView *imageViewForHeader;

- (IBAction)disMiss:(id)sender;

@end
