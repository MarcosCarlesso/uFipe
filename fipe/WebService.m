//
//  WebService.m
//  fipe
//
//  Created by Marcos on 11/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"
#import "SBJsonParser.h"

@implementation WebService {
    NSArray *retornoArray;
    NSString *retornoUrl;
}

@synthesize delegate;

-(id)init{
    self = [super init];
    
    if (self) {
        receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}

-(void)retornoWebService:(NSString*)msg{
    if (![self delegate])
        return;
    
    if ([[self delegate] respondsToSelector:@selector(retornoWebService:)]) {
        if (!retornoArray)
            retornoArray = [[NSArray alloc] init];
        else {
            if ([retornoArray count] > 0) {
                if (retornoArray[0][@"error"])
                    [[self delegate] retornoWebService:@{@"array":retornoArray, @"msg":@"Não foi possivel obter os dados da consulta.", @"url":retornoUrl}];
                else
                    [[self delegate] retornoWebService:@{@"array":retornoArray, @"msg":msg, @"url":retornoUrl}];
            } else {
                [[self delegate] retornoWebService:@{@"array":retornoArray, @"msg":@"Fala ao conectar ao servidor.", @"url":retornoUrl}];
            }
        }
    }
}

-(void)consultaWebSerice:(NSString*)url{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    retornoUrl = url;
    if (!theConnection) {
        [self retornoWebService:@"Não foi possivel iniciar a conexão com o servidor."];
    }
}

-(void)consultaWebServiceIndice:(NSNumber*)consultaIndice nome:(NSString*)consultaNome marca:(NSString*)consultaIdMarca modelo:(NSString*)consultaIdModelo veiculo:(NSString*)consultaIdVeiculo{
    
        @autoreleasepool {
            
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
            [self consultaWebSerice:currentURL];
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [receivedData setLength:0];
    retornoArray = nil;
    NSString *msg = [NSString stringWithFormat:@"Falha na conexão - %@",[error localizedDescription]];
    [self retornoWebService:msg];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSMutableString *JsonString = [[NSMutableString alloc] initWithBytes:[receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *JsonParser = [[SBJsonParser alloc] init];
    
    id retornoId = [JsonParser objectWithString:JsonString];
    
    if ([retornoId isKindOfClass:[NSArray class]])
        retornoArray = [JsonParser objectWithString:JsonString];
    else
        retornoArray = @[[JsonParser objectWithString:JsonString]];
    
    if ([retornoArray count] > 0)
        [self retornoWebService:@"OK"];
    else
        [self retornoWebService:@"Não foi possível acessar o servidor."];
}



@end
