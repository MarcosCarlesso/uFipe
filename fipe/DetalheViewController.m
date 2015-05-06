//
//  DetalheViewController.m
//  fipe
//
//  Created by Marcos on 08/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "DetalheViewController.h"
#import "AppGlobal.h"

@interface DetalheViewController ()

@end

@implementation DetalheViewController {
    UIView *loadingView;
    WebService *ws;
}

@synthesize consultaIndice;
@synthesize consultaNome;
@synthesize consultaIdMarca;
@synthesize consultaIdModelo;
@synthesize consultaIdVeiculo;

@synthesize retornoUrl;


- (void)viewDidLoad {
    [super viewDidLoad];

    loadingView = [[AppGlobal sharedGlobal] addLoadingViewIn:[self view]];
    [loadingView setFrame:CGRectMake(loadingView.frame.origin.x, loadingView.frame.origin.y+35, loadingView.frame.size.width, loadingView.frame.size.height-35)];
    
    ws = [[WebService alloc] init];
    [ws setDelegate:self];
    if (retornoUrl)
        [ws consultaWebSerice:retornoUrl];
    else {
        [ws consultaWebServiceIndice:consultaIndice nome:consultaNome marca:consultaIdMarca modelo:consultaIdModelo veiculo:consultaIdVeiculo];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Nova Busca" style:UIBarButtonItemStyleBordered target:self action:@selector(novaBusca)];
        [[self navigationItem] setRightBarButtonItem:button];
    }
    
    //[[self adBanner] setAlpha:0.0];
}
-(void)novaBusca{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
-(void)retornoWebService:(NSDictionary *)dic{
    if ([dic[@"msg"] isEqualToString:@"OK"]) {
        if ([dic[@"array"] count] > 0) {
        
            retornoUrl = dic[@"url"];
            [[self lbMarca] setText:dic[@"array"][0][@"marca"]];
            [[self lbModelo] setText:dic[@"array"][0][@"name"]];
            if ([dic[@"array"][0][@"id"] isEqualToString:@"32000"])
                [[self lbAno] setText:@"Zero KM"];
            else
                [[self lbAno] setText:dic[@"array"][0][@"id"]];
            [[self lbPreco] setText:dic[@"array"][0][@"preco"]];
            [[self lbReferencia] setText:dic[@"array"][0][@"referencia"]];
            
            NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/favoritos.plist"];
            NSArray *fav = [[NSMutableArray alloc] initWithContentsOfFile:path];
            for (NSDictionary *dic in fav)
                if ([dic[@"url"] isEqualToString:retornoUrl])
                    [[self btFavorito] setAlpha:0];
            
            BOOL addHis = YES;
            path = [NSHomeDirectory() stringByAppendingString:@"/Documents/historico.plist"];
            NSMutableArray *his = [[NSMutableArray alloc] initWithContentsOfFile:path];
            for (NSDictionary *dic in his)
                if ([dic[@"url"] isEqualToString:retornoUrl])
                    addHis = NO;
            
            if (addHis) {
                if (!his)
                    his = [[NSMutableArray alloc] init];
                [his addObject:@{@"ano":[[self lbAno] text],@"name":[NSString stringWithFormat:@"%@ - %@",[[self lbMarca] text],[[self lbModelo] text]], @"url":retornoUrl}];
                if ([his count] > 20)
                    [his removeObjectAtIndex:0];
                [his writeToFile:path atomically:NO];
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                [loadingView setAlpha:0];
            } completion:^(BOOL finished) {
                [loadingView removeFromSuperview];
            }];
        }

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!" message:dic[@"msg"] delegate:self cancelButtonTitle:@"Esta bom =/" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)touchFavorito:(id)sender {
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/favoritos.plist"];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (!tmp)
        tmp = [[NSMutableArray alloc] init];
    [tmp addObject:@{@"ano":[[self lbAno] text],@"name":[NSString stringWithFormat:@"%@ - %@",[[self lbMarca] text],[[self lbModelo] text]], @"url":retornoUrl}];
    [tmp writeToFile:path atomically:NO];
    
    [UIView animateWithDuration:0.2 animations:^{
        [sender setAlpha:0];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [ws setDelegate:nil];
}

@end
