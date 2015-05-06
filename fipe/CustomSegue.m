//
//  CustomSegue.m
//  fipe
//
//  Created by Marcos on 09/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "CustomSegue.h"
#import "MontadoraTableViewController.h"
#import "DetalheViewController.h"

@implementation CustomSegue

-(void)perform{
    
    if ([[(MontadoraTableViewController*)[self sourceViewController] consultaIndice] isEqualToNumber:@3]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self setDestinationCustonViewController:[sb instantiateViewControllerWithIdentifier:@"DetalheViewController"]];
    } else {
        [self setDestinationCustonViewController:[self destinationViewController]];
    }
    
    [(MontadoraTableViewController*)[self destinationCustonViewController] setConsultaIndice:[self consultaIndice]];
    [(MontadoraTableViewController*)[self destinationCustonViewController] setConsultaNome:[self consultaNome]];
    [(MontadoraTableViewController*)[self destinationCustonViewController] setConsultaIdMarca:[self consultaIdMarca]];
    [(MontadoraTableViewController*)[self destinationCustonViewController] setConsultaIdModelo:[self consultaIdModelo]];
    [(MontadoraTableViewController*)[self destinationCustonViewController] setConsultaIdVeiculo:[self consultaIdVeiculo]];
    
    [[[self sourceViewController] navigationController] pushViewController:[self destinationCustonViewController] animated:YES];
}

@end
