//
//  Authentication.m
//  SZEPCardApp
//
//  Created by Karesz on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Authentication.h"
#import "BalanceInquiryResult.h"
#import "SoapUtil.h"
#import "Input_BANKKARTYASZAMLAEGYENLEGLEKERDEZES.h"
#import "Input_HB_BEJELENTKEZES.h"
#import "ParserBalanceQuery.h"
#import "FieldErrorHighlighted.h"
#import "QuartzCore/QuartzCore.h"
#import "LoadingIndicator.h"
#import "About.h"


@interface Authentication() {

@private 
    UIView *loadingIndicator_;
    OutputBalanceQuery *outputBalanceQuery_;
    NSMutableArray *errors;
    UILabel *lbError;
    LoadingIndicator *indicator;
}

- (void) pollingBackground:(NSString *)pollString;
- (void) addIndicator;
- (void) removeIndicator;
- (void) transitionToResultView;
- (BOOL) validate;
- (void) removeFieldErrors;
- (void) insertErrorMW:(NSString *) errorKey;
- (void) removeMWError;
- (void) goToTheAboutView;


@end


@implementation Authentication
@synthesize tfCardNumber;
@synthesize tfTeleCode;


#pragma mark - private methods

- (void)pollingBackground:(NSString *)pollString{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    WorkflowPoller *wfpoller = [[WorkflowPoller alloc] initWithPollString:pollString];
    
    wfpoller.delegate = self;
    
    [wfpoller poll];
    
    
    [pool release];
}

- (void)addIndicator {
    
    indicator = [[LoadingIndicator alloc] initWithViewController:self];
    [indicator showLoadingIndicator:self];
    
}

- (void)removeIndicator {
    
    [indicator hideLoadingIndicator];
    
}

- (void)transitionToResultView {
    
    [self removeIndicator];
    
    NSLog(@"%@", outputBalanceQuery_.message);
    
    if (![outputBalanceQuery_.message isEqualToString:@"SIKER"]){
        
        [self insertErrorMW:outputBalanceQuery_.message];
        
    }
     
    else {
      
        
        BalanceInquiryResult *bir = [[BalanceInquiryResult alloc]initWithNibName:@"BalanceInquiryResult" bundle:[NSBundle mainBundle]];
        [bir setOutputBalanceQuery:outputBalanceQuery_];
        //[self presentModalViewController:bir animated:YES];
        [self.navigationController pushViewController:bir animated:YES];
        [bir release];
        
    }
    
}

- (BOOL)validate{
    
    [self removeMWError];
    [self removeFieldErrors];
    [errors release];
    errors = [[NSMutableArray alloc]init];
    NSLocalizedString(@"HIANYZIKAZONOSITO", @"Filling in the User Name field is mandatory.");
    NSLocalizedString(@"HIANYZIKTELEKOD", @"sdasda");
    NSLocalizedString(@"HIBASUGYFELAZONOSITO", @"Invalid bank account number format.");
    NSLocalizedString(@"TULSOKHIBASPROBA", @"Sikertelen bejelentkezés! Túl sok sikertelen próbálkozás!");
    NSLocalizedString(@"HIBASTITKOSKOD", @"adasdasda");
    
    NSLog(@"cardNumber numbers: %d, teleCode numbers: %d", [tfCardNumber.text length], [tfTeleCode.text length]);
    if ([tfCardNumber.text length] != 10 ){
        FieldErrorHighlighted *error = [[FieldErrorHighlighted alloc] initWithView:tfCardNumber andErrorKey:@"Wrong CardNumber"];
        [error insertFieldError];
        [errors addObject:error];    
        [error release];
        NSLog(@"wrong CardNumber!!!!");
    }
    if ([tfTeleCode.text length] != 3){
        FieldErrorHighlighted *error = [[FieldErrorHighlighted alloc] initWithView:tfTeleCode andErrorKey:@"Wrong Telecode"];
        [error insertFieldError];
        [errors addObject:error];
        [error release];
        NSLog(@"wrong TeleCode!!!!");

    }
     
    return [errors count] == 0;
}

- (void)removeFieldErrors {
    for (FieldErrorHighlighted *feh in errors) {
        [feh dismissFieldError];
    }
}


- (void)insertErrorMW:(NSString *)errorKey{
    
    tfCardNumber.text = nil;
    tfTeleCode.text = nil;
    
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.tag = 1111;
    errorLabel.text = errorKey;
    errorLabel.font = [UIFont systemFontOfSize:12.0f];
    errorLabel.textColor = [UIColor colorWithRed:234.0f/255.0f green:17.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
    errorLabel.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:227.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
    //elofodulhat, hogy nem fer ki egyetlen sorba a hibauzenet!
    errorLabel.lineBreakMode = UILineBreakModeWordWrap;
    errorLabel.numberOfLines = 0;

    
    CGSize sizeExpected = [errorLabel.text sizeWithFont:errorLabel.font constrainedToSize:CGSizeMake(tfTeleCode.frame.size.width, 200.0f) lineBreakMode:errorLabel.lineBreakMode];

    
    errorLabel.frame = CGRectMake(CGRectGetMinX(tfTeleCode.frame), 240, tfTeleCode.frame.size.width, sizeExpected.height);
    
    [self.view addSubview:errorLabel];
    
    UIButton *btn = (UIButton *) [self.view viewWithTag:2222];
    btn.frame = CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(errorLabel.frame) + 10.0, btn.frame.size.width, btn.frame.size.height);
        
}

- (void) removeMWError{
    
    for (UIView* aSubView in [self.view subviews]){
        
        if (aSubView.tag == 1111){
        
            UILabel *errorLabel = (UILabel *) [self.view viewWithTag:1111];
            [errorLabel removeFromSuperview];
            
            UIButton *btn = (UIButton *) [self.view viewWithTag:2222];
            // a széllességet és magasságot a xib fájl konstans értékei alapján állítiom be...
            btn.frame = CGRectMake(CGRectGetMinX(tfTeleCode.frame), CGRectGetMaxY(tfTeleCode.frame) + 20.0, 292.0f, 50.0f);
            
        }
    
    }
    
    
}

- (void)goToTheAboutView{

    About *about = [[About alloc] init];
    
    [self.navigationController pushViewController:about animated:YES];
    
    [about release];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    rButton.frame = CGRectMake(280, 0, 25, 25);
    [rButton addTarget:self action:@selector(goToTheAboutView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (void)viewDidUnload
{
    
    [self setTfCardNumber:nil];
    [self setTfTeleCode:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{

    tfCardNumber.text = nil;
    tfTeleCode.text = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - event handlers
- (IBAction)balanceInquiry:(id)sender {
    
    
    /*
    NSString *workflowInput = [Input_BANKKARTYASZAMLAEGYENLEGLEKERDEZES createInput:tfCardNumber.text teleCode:tfTeleCode.text];
    
    NSArray *soapParams = [NSArray arrayWithObjects:@"BANKKARTYASZAMLAEGYENLEGLEKERDEZES", workflowInput, nil];
    */
    
    [tfCardNumber resignFirstResponder];
    [tfTeleCode resignFirstResponder];
    
    if ([self validate]) {
        
        NSLog(@"%@ balanceInquiry: called", [self class]);
        [self addIndicator];
        
        NSString *workflowInput = [Input_BANKKARTYASZAMLAEGYENLEGLEKERDEZES createInput:tfCardNumber.text teleCode:tfTeleCode.text];
        
        NSArray *soapParams = [NSArray arrayWithObjects:@"BANKKARTYASZAMLAEGYENLEGLEKERDEZES", workflowInput, nil];
        
        
        // egy Soap message-t állít össze, aminek az 1. paraméterében a folyamat nevét adom át, ami ebben az esetben: BANKARTYASZAMLAEGYENLEGLEKEREDEZES lesz, míg a 2. paraméternek a fenti soapParam-t adom át, amibe már a SoapMessage-nek megfelelő tartalom kerül....
        NSString *soapRequest = [SoapUtil createSoapMessage:@"startWorkflow" withParams:soapParams];
        //NSLog(@"-----------------------------------------------");
        //NSLog(@"SOAP request: %@", soapRequest);
        
        // összeállítja és elküldi a http kérést, a fenti String alapján a paraméterben megadott csatornára...
        NSString *soapResponse = [SoapUtil sendSoapMessage:soapRequest toUrl:MWACCES_PUBLIC_SERVICE_URL];
        
        NSLog(@"-----------------------------------------------");
        NSLog(@"SOAP response: %@", soapResponse);
        
        // ennél a pontnál, már az első folyamatot elinditottuk, aminek a válaszában egy címet kapunk, ahová a kérésnek megfelelő választ várjuk vissza.
        NSString *pollString = [WorkflowPoller searchForPollString:soapResponse];
        
        NSLog(@"-----------------------------------------------");
        NSLog(@"pollString:  %@", pollString);
        
        // külön szálat indítunk, amiben pollozzuk a visszakapott címet, addig amíg a válaszban a complete tag között TRUE nem érkezik vissza, ekkor a return tag között a várva várt választ kapjuk meg
        if (pollString != nil){
            
            [NSThread detachNewThreadSelector:@selector(pollingBackground:) toTarget:self withObject:pollString];
        } 
  
    }
    
        
}

- (IBAction)doneEditing:(id)sender {
    [sender resignFirstResponder];
}

# pragma mark - UITextFieldDelegate 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    // változók az első feltétel kiértékeléséhez...
    NSString* regex = @"[0-9]";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    // figyelni kell, hogy ha NUMERIKUS a használandó Keypad akkor ne lehessen leütni betűt, az utolsó feltétel a backspace-re vonatkozik
    if (![regextest evaluateWithObject:string] && ![string isEqualToString:@""]){
        return NO;
    }
    
    if ([string isEqualToString:@""]){
        NSLog(@"backspace-t ütöttem");
        return YES;
    }
    
    if (textField == tfCardNumber){
    
        if (textField.text.length > 9){
            return NO;
        }
    }
    
    if (textField == tfTeleCode){
        
        if (textField.text.length > 2){
            return NO;
        }
    }

    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}


# pragma mark - WorkflowPollerDelegate

-(void)pollerDidFinishPolling:(WorkflowPoller *)poller{

    NSLog(@"soapResponse: %@", poller.soapResponse);
    NSLog(@"wfAnswer: %@", poller.workflowAnswer);
    
    // a poller.workflowanser egy NSString, de a Parser data objektumot vár paraméterként, ennek megfelelően át kell konvertálni data-ként...
    NSData *data = [poller.workflowAnswer dataUsingEncoding:NSUTF8StringEncoding];
   // NSString *str = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
   // NSLog(@"ez lesz a data-ban: %@", str);
   // [str release];
    

    // perser példányosítása, hogy meghívható legyen a parseData metódus, amiben a lényegi műveletek találhatók...
    ParserBalanceQuery *parser = [[ParserBalanceQuery alloc] init];
    
    [parser parseData:data];
    
    outputBalanceQuery_ = [parser answer];
    [outputBalanceQuery_ retain];
    
    [parser release];
    
   // outputBalanceQuery_ = [ParserBalanceQuery outputBalanceQueryBySimpleParse:poller.workflowAnswer];
   // [outputBalanceQuery_ retain];
    
    NSLog(@"resultView: hospitality: %@, leisure: %@, lodging: %@", outputBalanceQuery_.hospitality, outputBalanceQuery_.leisure, outputBalanceQuery_.lodging);
  
    
    [self performSelectorOnMainThread:@selector(transitionToResultView) withObject:nil waitUntilDone:NO]; 
    
}

- (void)dealloc {
    if(loadingIndicator_ != nil) {
        [loadingIndicator_ release];
    }
    
    [outputBalanceQuery_ release];
    [indicator release];
    [tfCardNumber release];
    [tfTeleCode release];
    [super dealloc];
}
@end
