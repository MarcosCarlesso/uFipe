//
//  MontadoraTableViewController.m
//  fipe
//
//  Created by Marcos on 07/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "MontadoraTableViewController.h"
#import "DetalheViewController.h"
#import "CustomSegue.h"
#import "SBJsonParser.h"
#import "AppGlobal.h"

@interface MontadoraTableViewController ()

@end

@implementation MontadoraTableViewController {
    UIView *loadingView;
    NSArray *retornoArray;
    NSMutableArray *pesquisaArray;
    WebService *ws;
    BOOL inicio;
}

@synthesize consultaIndice;
@synthesize consultaNome;
@synthesize consultaIdMarca;
@synthesize consultaIdModelo;
@synthesize consultaIdVeiculo;

- (void)viewDidLoad {
    [super viewDidLoad];
    inicio = YES;
    switch ([consultaIndice integerValue]) {
        case 1:
            [self setTitle:@"Marca"];
            break;
        case 2:
            [self setTitle:@"Modelo"];
            break;
        case 3:
            [self setTitle:@"Ano"];
            break;
        default:
            break;
    }
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    loadingView = [[AppGlobal sharedGlobal] addLoadingViewIn:[self view]];
    
    ws = [[WebService alloc] init];
    [ws setDelegate:self];
    [ws consultaWebServiceIndice:consultaIndice nome:consultaNome marca:consultaIdMarca modelo:consultaIdModelo veiculo:consultaIdVeiculo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    if (indexPath)
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)retornoWebService:(NSDictionary *)dic{

    if ([dic[@"msg"] isEqualToString:@"OK"]) {
        retornoArray = dic[@"array"];
        [[self tableView] reloadData];
        
        [UIView animateWithDuration:0.2 animations:^{
            [loadingView setAlpha:0];
            [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        } completion:^(BOOL finished) {
            [loadingView removeFromSuperview];
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops!" message:dic[@"msg"] delegate:self cancelButtonTitle:@"Esta bom =/" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [ws setDelegate:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:[self tableView]])
        return [retornoArray count];
    else
        return [pesquisaArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if ([tableView isEqual:[self tableView]])
        [[cell textLabel] setText:retornoArray[indexPath.row][@"name"]];
    else
        [[cell textLabel] setText:pesquisaArray[indexPath.row][@"name"]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
    [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEqual:[self tableView]])
        [self performSegueWithIdentifier:@"CustonSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark Content Filtering
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [pesquisaArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchString];
    pesquisaArray = [NSMutableArray arrayWithArray:[retornoArray filteredArrayUsingPredicate:predicate]];
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableView *tv = (UITableView*)[[sender superview] superview];
    NSArray *arrayTmp;
    if ([tv isEqual:[self tableView]])
        arrayTmp = retornoArray;
    else
        arrayTmp = pesquisaArray;
    
    NSIndexPath *indexPath = [tv indexPathForSelectedRow];
    
    //[(MontadoraTableViewController*)[(CustomSegue*)segue destinationCustonViewController] setConsultaIdMarca:consultaIdMarca];
    [(CustomSegue*)segue setConsultaNome:consultaNome];
    switch ([consultaIndice integerValue]) {
        case 1:
            [(CustomSegue*)segue setConsultaIdMarca:arrayTmp[indexPath.row][@"id"]];
            break;
        case 2:
            [(CustomSegue*)segue setConsultaIdMarca:consultaIdMarca];
            [(CustomSegue*)segue setConsultaIdModelo:arrayTmp[indexPath.row][@"id"]];
            break;
        case 3:
            [(CustomSegue*)segue setConsultaIdMarca:consultaIdMarca];
            [(CustomSegue*)segue setConsultaIdModelo:consultaIdModelo];
            [(CustomSegue*)segue setConsultaIdVeiculo:arrayTmp[indexPath.row][@"id"]];
            break;
        default:
            break;
    }
    [(CustomSegue*)segue setConsultaIndice:@([consultaIndice integerValue] + 1)];
    
}

@end
