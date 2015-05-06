//
//  CustomSegue.h
//  fipe
//
//  Created by Marcos on 09/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegue : UIStoryboardSegue

@property (nonatomic, strong) UIViewController *destinationCustonViewController;
@property (nonatomic, strong) NSNumber *consultaIndice;
@property (nonatomic, strong) NSString *consultaNome;
@property (nonatomic, strong) NSString *consultaIdMarca;
@property (nonatomic, strong) NSString *consultaIdModelo;
@property (nonatomic, strong) NSString *consultaIdVeiculo;

@end
