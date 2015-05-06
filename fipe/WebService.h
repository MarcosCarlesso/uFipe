//
//  WebService.m
//  fipe
//
//  Created by Marcos on 11/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate;

@interface WebService : NSObject <NSURLConnectionDelegate> {
    
    id <WebServiceDelegate> __unsafe_unretained delegate;
    
    NSMutableData *receivedData;
    
}

@property(nonatomic, unsafe_unretained) id <WebServiceDelegate> delegate;

-(void)consultaWebServiceIndice:(NSNumber*)consultaIndice nome:(NSString*)consultaNome marca:(NSString*)consultaIdMarca modelo:(NSString*)consultaIdModelo veiculo:(NSString*)consultaIdVeiculo;
-(void)consultaWebSerice:(NSString*)url;

@end

@protocol WebServiceDelegate <NSObject>

@optional

-(void)retornoWebService:(NSDictionary *)dic;

@end
