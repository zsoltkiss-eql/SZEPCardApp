//
//  Base64Impl.m
//  SZEPCardApp
//
//  Created by Karesz on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Base64Impl.h"

@implementation Base64Impl

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";  


+(NSString *)encode:(NSData *)plainText {  
    int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;  
    unsigned char *outputBuffer = malloc(encodedLength);  
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];  
    
    NSInteger i;  
    NSInteger j = 0;  
    int remain;  
    
    for(i = 0; i < [plainText length]; i += 3) {  
        remain = [plainText length] - i;  
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];  
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |   
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];  
        
        if(remain > 1)  
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)  
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];  
        else   
            outputBuffer[j++] = '=';  
        
        if(remain > 2)  
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];  
        else  
            outputBuffer[j++] = '=';              
    }  
    
    outputBuffer[j] = 0;  
    
    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];  
    free(outputBuffer);  
    
    return result;  
}  
@end  