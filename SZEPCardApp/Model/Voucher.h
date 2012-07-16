//
//  Voucher.h
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
    Utalvany uzleti objektum reprezentacioja.
 
 */

#import <Foundation/Foundation.h>

typedef enum {
    LODGING,            //SZALLASHELY
    HOSPITALITY,        //VENDEGLATAS
    LEISURE             //SZABADIDO
} VoucherType;

/*
 Egy arra alkalmas view kontrollernek implementalnia kell ezt a protokollt. Mivel celszeruen a view kontrollernek kell gyujtenie az egyes utalvanytipusokat leiro cellakban megejtett beallitasokat.
 
 */
@protocol VoucherTypeSelecting <NSObject>

//az Info gomb megerintesekor meg kell jeleniteni az alszamlat leiro oldalt
- (void)showInfoPageForVoucherType:(NSInteger)voucherType;

- (void)addVoucherTypeToSearchCriteria:(NSInteger)voucherType;
- (void)removeVoucherTypeFromSearchCriteria:(NSInteger)voucherType;

@end

@interface Voucher : NSObject

@end
