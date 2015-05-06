//
//  AppGlobal.h
//  fipe
//
//  Created by Marcos on 09/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface AppGlobal : NSObject

+(id)sharedGlobal;
-(NSArray *)consultaWebServiceIndice:(NSNumber*)consultaIndice nome:(NSString*)consultaNome marca:(NSString*)consultaIdMarca modelo:(NSString*)consultaIdModelo veiculo:(NSString*)consultaIdVeiculo;
-(UIView*)addLoadingViewIn:(UIView*)view;

@end
