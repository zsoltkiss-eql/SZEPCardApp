//
//  SettlementSearch.m
//  SZEPCardApp
//
//  Created by Karesz on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettlementSearch.h"
#import "SearchRoot.h"
#import "SearchResult.h"
#import "SoapUtil.h"
#import "SoapResponseSaver.h"
#import "SettlementSearchResponseParserDelegate.h"

@interface SettlementSearch() {
@private
    UIActivityIndicatorView *loadingIndicator_;
    
    //ez a table view datasource-a. Settlement tipusu elemeket tartalmaz.
    NSArray *allSettlements_;
    
    //ez a table view data source-a searhx "modban"
    NSArray *currentSearchResults_;
    
}

- (void)callWebService;
- (void)soapResponsePostProcess:(NSString *)soapResponse;

- (void)addIndicator;
- (void)removeIndicator;

@end

@implementation SettlementSearch



#pragma mark - private methods

- (void)callWebService {
    //telepuleslista service-hez nincs bemeno parameter
    //dummy ws eseten a soap template, amit hasznalni kell: elfogadohelyekTelepulesei.xml
    //NSString *soapMessage = [SoapUtil createSoapMessage:@"elfogadohelyekTelepulesei" withParams:nil];
    
    //FINIT (eles) ws eseten a soap template, amit hasznlani kell: ElfTelepulesek.xml
    NSString *soapMessage = [SoapUtil createSoapMessage:@"ElfTelepulesek" withParams:nil];
    
    SoapResponseSaver *responseSaver = [[[SoapResponseSaver alloc]init]autorelease];
    [responseSaver setController:self];
    
    [SoapUtil sendSoapMessage:soapMessage toUrl:SZEP_CARD_SERVICE_URL usingHeaders:nil andDelegate:responseSaver];
        
}

/*
 Itt a soap response xml-t feldolgozzuk es csinalunk belole datasource-ot
 */
- (void)soapResponsePostProcess:(NSMutableData *)soapResponse {
    
    //NSLog(@"This must be parsed yet: %@", soapResponse);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:soapResponse];
    SettlementSearchResponseParserDelegate *parserDelegate = [[SettlementSearchResponseParserDelegate alloc]init];
    [xmlParser setDelegate: parserDelegate];
    //[xmlParser setShouldResolveExternalEntities: YES];
    BOOL parseResultOK = [xmlParser parse];
    NSLog(@"parseResultOK: %d", parseResultOK);
    
    if(allSettlements_ != nil) {
        [allSettlements_ release];
        allSettlements_ = nil;
    }
    allSettlements_ = parserDelegate.listOfSettlements;
    [allSettlements_ retain];
    NSLog(@"All settlements: %@", allSettlements_);

    [parserDelegate release];
    [xmlParser release];
    
    [self removeIndicator];
    
    [self.tableView reloadData];
}

- (void)addIndicator {
    loadingIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    float centerX, centerY;
    
    centerX = self.tableView.frame.size.width / 2;
    centerY = self.tableView.frame.size.height / 2;
    
	loadingIndicator_.center = CGPointMake(centerX, centerY);
	loadingIndicator_.hidesWhenStopped = YES;
    
    [self.view addSubview:loadingIndicator_];
    
    [loadingIndicator_ startAnimating];
}

- (void)removeIndicator {
    
    [loadingIndicator_ stopAnimating];
    
    [loadingIndicator_ removeFromSuperview];
    
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self addIndicator];
    [self callWebService];
}

- (void)viewDidUnload
{
    //[self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        //ha a searchString-re illeszkedo talalati listat megjelenito table view az aktiv
        //ez az a pont, ahol a SZUREST MEGCSINALJUK! azaz a currentSearchResults_ adattagot itt toltjuk fel
        
        if(currentSearchResults_ != nil) {
            [currentSearchResults_ release];
            currentSearchResults_ = nil;
        }
        
        if([self.searchDisplayController.searchBar.text length] >= 3) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@) OR (zipCode contains[cd] %@)", self.searchDisplayController.searchBar.text, self.searchDisplayController.searchBar.text];
            
            currentSearchResults_ = [[allSettlements_ filteredArrayUsingPredicate:predicate]retain];
            
            NSLog(@"current search results: %@", currentSearchResults_);
        
        }
        
        
        return [currentSearchResults_ count];
    } else {
        //ha az eredeti, osszes telepules megjelenito table view az aktiv (szuretlen tablazat)
        return [allSettlements_ count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Settlement *aSettlement = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        aSettlement = [currentSearchResults_ objectAtIndex:indexPath.row];
    } else {
        aSettlement = [allSettlements_ objectAtIndex:indexPath.row];
    }
    
    NSString *cellText = [NSString stringWithFormat:@"%@, %@", aSettlement.zipCode, aSettlement.name];
    cell.textLabel.text = cellText;
    
    return cell;
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    /*
        Itt a kivalasztott telepulessel vissza kell terni az elozo view kontrollerre (SearchRoot) es visszairni ott a telepulest a UISearchBar-ba
     
     */
    
    int countOfAllControllers = [[self.navigationController viewControllers]count];
    int indexForPreviousController = countOfAllControllers - 2;
    
    UIViewController *previousView = [[self.navigationController viewControllers]objectAtIndex:indexForPreviousController];
    
    if([previousView isKindOfClass:[SearchRoot class]]) {
        SearchRoot *searchRoot = (SearchRoot *)previousView;
        Settlement *sSelected = nil;
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            sSelected = (Settlement *)[currentSearchResults_ objectAtIndex:indexPath.row];
        } else {
            sSelected = (Settlement *)[allSettlements_ objectAtIndex:indexPath.row];
        }
        searchRoot.settlementSelected = sSelected;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


#pragma mark - dealloc
- (void) dealloc {
     [loadingIndicator_ release];
    [allSettlements_ release];
    
    //[searchBar release];
    [super dealloc];
}

@end
