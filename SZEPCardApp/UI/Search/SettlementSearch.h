//
//  SettlementSearch.h
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    Magyarorszagi telepuleseket listazo table view controller.
    Az osszes olyan telepules lejon a web service-tol, ahol letezik SZEP kartya elfogadohely. Ezekbol lehet keresni a search bar segitsegevel, ami gyakorlatilag egy szukites a WS alatal visszaadott talalati listan. A talalatok table view-ban jelennek meg.
 
    Amikor a user megerinti a cellat, visszanavigalunk az elozo view-ra (SearchRoot) es beallitjuk rajta a kivalasztott telepulest.
 
 
 
 
 Budapest - X.
 
 AMikor a WS visszaaadja az osszes telepulest, akkor a budapestieket ki kell szurni, helyette az osszes bp-i keruletet kell megjelniteni a fenit formatumban. Amikor a user kivalasztott egy bp-i keruletet a kereso metodusnak ugy kell atadni, hogy kerdojel legyen az ir. szamban, pl. 1???, Budapest.
    
 */

#import <UIKit/UIKit.h>

#import "SearchCriteria.h"

@interface SettlementSearch : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
    
}






@end
