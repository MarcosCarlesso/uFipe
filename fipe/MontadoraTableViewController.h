//
//  MontadoraTableViewController.h
//  fipe
//
//  Created by Marcos on 07/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface MontadoraTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, WebServiceDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSNumber *consultaIndice;
@property (nonatomic, strong) NSString *consultaNome;
@property (nonatomic, strong) NSString *consultaIdMarca;
@property (nonatomic, strong) NSString *consultaIdModelo;
@property (nonatomic, strong) NSString *consultaIdVeiculo;

@end
