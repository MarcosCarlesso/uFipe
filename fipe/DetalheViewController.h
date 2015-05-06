//
//  DetalheViewController.h
//  fipe
//
//  Created by Marcos on 08/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "WebService.h"

@interface DetalheViewController : UIViewController <WebServiceDelegate, UIAlertViewDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) NSNumber *consultaIndice;
@property (nonatomic, strong) NSString *consultaNome;
@property (nonatomic, strong) NSString *consultaIdMarca;
@property (nonatomic, strong) NSString *consultaIdModelo;
@property (nonatomic, strong) NSString *consultaIdVeiculo;

@property (nonatomic, strong) NSString *retornoUrl;

@property (weak, nonatomic) IBOutlet UILabel *lbMarca;
@property (weak, nonatomic) IBOutlet UILabel *lbModelo;
@property (weak, nonatomic) IBOutlet UILabel *lbAno;
@property (weak, nonatomic) IBOutlet UILabel *lbPreco;
@property (weak, nonatomic) IBOutlet UILabel *lbReferencia;
@property (weak, nonatomic) IBOutlet UIButton *btFavorito;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

@end
