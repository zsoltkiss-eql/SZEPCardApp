//
//  FieldErrorHighlighted.m
//  SZEPCardApp
//
//  Created by EQL_MACMINI_3 on 2012.06.01..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FieldErrorHighlighted.h"

#define GAP_BETWEEN_FIELD_ERROR_AND_NEXT_COMPONENT 10.0f
#define HIGHLIGHTED_VIEW_WIDTH_IPHONE 320.0f
#define HIGHLIGHTED_VIEW_WIDTH_IPAD 780.0f

@implementation FieldErrorHighlighted
@synthesize label, ownerComponent;
@dynamic growthInHeight;


- (id)initWithView:(UIView *)view andErrorKey:(NSString *)errorKey {
    
    self = [super initWithFrame:CGRectMake(0, view.frame.origin.y - 5.0f, 320, view.frame.size.height + 25.0f)];
    if (self) {
        
        //float widthToUse = (IPHONE) ? HIGHLIGHTED_VIEW_WIDTH_IPHONE : HIGHLIGHTED_VIEW_WIDTH_IPAD;
        float widthToUse = HIGHLIGHTED_VIEW_WIDTH_IPHONE;
        
        //az owner-re taroljunk egy sajat referenciat es setter reven noveljuk meg a retain count-ot, kulonben a field error eltavolitasakor exec_bad_access-et kapunk...
        self.ownerComponent = view;
        
        self.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:227.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
        
        label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = errorKey;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithRed:234.0f/255.0f green:17.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        
        //elofodulhat, hogy nem fer ki egyetlen sorba a hibauzenet!
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        CGSize sizeExpected = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(widthToUse - 5.0f, 200.0f) lineBreakMode:label.lineBreakMode];
        
        label.frame = CGRectMake(5, view.frame.size.height + 7.0f, sizeExpected.width, sizeExpected.height);
        [self addSubview:label];
        //[self sizeToFit];
        
        
        self.frame = CGRectMake(0, view.frame.origin.y - 5.0, widthToUse, 5.0f + view.frame.size.height + 7.0f + label.frame.size.height);
        
        
    }
    
    return self;
    
}

//Az owner component "novereve" teszi a FieldErrorHighlighted komponenst
- (void)insertFieldError {
    [ownerComponent.superview addSubview:self];
    [ownerComponent.superview sendSubviewToBack:self];
    
    //itt tudjuk megallapitani a highlighted error komponens szelesseget, mivel itt mar megvan az a parent view, akihez hozzaadtuk es a parant view szelessegevel azonosra kell allitani a hibauzenet szelesseget is. iPad-es rotation miatt is fontos ez, hogy elforgatas utan is jo legyen 
    //self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, self.superview.frame.size.width, self.frame.size.height);
    //self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    int offset = label.frame.size.height + GAP_BETWEEN_FIELD_ERROR_AND_NEXT_COMPONENT;
    
    //kozvetlenul az owner UTANI komponenst lejjebb tolja annyival, hogy a hibauzenet ne logjon ra, majd sorban az osszes tobbi lentebbit is eltolja
    for (UIView *aSubview in [ownerComponent.superview subviews]) {
        if(aSubview.frame.origin.y > CGRectGetMaxY(ownerComponent.frame)) {
            aSubview.frame = CGRectOffset(aSubview.frame, 0, offset);
        }
    }
    
}


//a field error komponens eltuntetese es az egyeb beviteli elemek visszapozicionalasa
- (void)dismissFieldError {
    int offset = (label.frame.size.height + GAP_BETWEEN_FIELD_ERROR_AND_NEXT_COMPONENT) * (-1);
    
    for (UIView *aSubview in [ownerComponent.superview subviews]) {
        if(aSubview.frame.origin.y > CGRectGetMaxY(ownerComponent.frame)) {
            aSubview.frame = CGRectOffset(aSubview.frame, 0, offset);
        }
    }
    
    [self removeFromSuperview];
}

- (float)growthInHeight {
    return self.frame.size.height - ownerComponent.frame.size.height;
}


#pragma mark - dealloc
- (void)dealloc {
    [label release];
    [ownerComponent release];
    
    [super dealloc];
    
}

@end
