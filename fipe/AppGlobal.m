//
//  AppGlobal.m
//  fipe
//
//  Created by Marcos on 09/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "AppGlobal.h"
#import "SBJsonParser.h"
#import <math.h>

static AppGlobal *sharedGlobal = nil;
@implementation AppGlobal

+(id)sharedGlobal {
    
    @synchronized(self) {
        if (sharedGlobal == nil)
            sharedGlobal = [[self alloc] init];
    }
    
    return sharedGlobal;
}

-(id)init {
    
    if (self = [super init]) {
    }
    return self;
}

-(UIView*)addLoadingViewIn:(UIView*)addview{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIView *loadingView = [[sb instantiateViewControllerWithIdentifier:@"LoadingViewController"] view];
    [loadingView setFrame:[addview frame]];
    [addview addSubview:loadingView];
    [addview bringSubviewToFront:loadingView];
    return loadingView;
}

-(NSArray *)consultaWebServiceIndice:(NSNumber*)consultaIndice nome:(NSString*)consultaNome marca:(NSString*)consultaIdMarca modelo:(NSString*)consultaIdModelo veiculo:(NSString*)consultaIdVeiculo{
    
    NSArray *retornoArray;
    @autoreleasepool {
        NSString *msgRetorno;
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSString *currentURL;
        switch ([consultaIndice integerValue]) {
            case 1:
                currentURL = [NSString stringWithFormat:@"http://fipeapi.appspot.com/api/1/%@/marcas.json",consultaNome];
                break;
            case 2:
                currentURL = [NSString stringWithFormat:@"http://fipeapi.appspot.com/api/1/%@/veiculos/%@.json", consultaNome, consultaIdMarca];
                break;
            case 3:
                currentURL = [NSString stringWithFormat:@"http://fipeapi.appspot.com/api/1/%@/veiculo/%@/%@.json", consultaNome, consultaIdMarca, consultaIdModelo];
                break;
            case 4:
                currentURL = [NSString stringWithFormat:@"http://fipeapi.appspot.com/api/1/%@/veiculo/%@/%@/%@.json", consultaNome, consultaIdMarca, consultaIdModelo, consultaIdVeiculo];
                break;
            default:
                break;
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        currentURL = [currentURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [request setURL:[NSURL URLWithString:currentURL]];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:20];
        
        NSMutableData *returnedData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (!error) {
            
            NSMutableString *JsonStringRetorno = [[NSMutableString alloc] initWithBytes:[returnedData mutableBytes] length:[returnedData length] encoding:NSUTF8StringEncoding];
            
            SBJsonParser *JsonParser = [[SBJsonParser alloc] init];
            
            if (![consultaIndice isEqualToNumber:@4])
                retornoArray = [JsonParser objectWithString:JsonStringRetorno];
            else
                retornoArray = @[[JsonParser objectWithString:JsonStringRetorno]];
            
            if (retornoArray == nil) {
                msgRetorno = @"Não foi possível acessar o servidor. Verifique se existe conexão com a internet.";
                return nil;
                
            }
        }
        else
        {
            msgRetorno = [NSString stringWithFormat:@"Falha de conexão!\n\n%@",[error localizedDescription]];
            return nil;
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Falha de conexão...! Erro - %@\n\n %@",[error localizedDescription], [error userInfo][NSURLErrorFailingURLStringErrorKey]] message:@"" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil, nil];
            //[alert show];
        }
        
    }
    return retornoArray;
    
}


@end
