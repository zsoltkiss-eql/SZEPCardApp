//
//  FieldErrorHighlighted.h
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.01..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldErrorHighlighted : UIView {
    UIView *ownerComponent;
    UILabel *label;
    float growthInHeight;       //az owner component es a letrehozott FiledErrorHighlighted view magassaganak a kulonbsege, amit neha jo ismerni ahhoz, hogy tudjuk, mennyivel "nyult meg" a view a hibauzenetek beillesztesenek hatasara
}

@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIView *ownerComponent;
@property(readonly) float growthInHeight;


- (id)initWithView:(UIView *)view andErrorKey:(NSString *)errorKey;

- (void)insertFieldError;

- (void)dismissFieldError;


@end
