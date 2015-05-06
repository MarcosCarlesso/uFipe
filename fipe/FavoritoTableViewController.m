//
//  FavoritoTableViewController.m
//  fipe
//
//  Created by Marcos on 11/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "FavoritoTableViewController.h"
#import "DetalheViewController.h"

@interface FavoritoTableViewController ()


@end

@implementation FavoritoTableViewController {
    NSMutableArray *dadosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.plist", [self nomePlist]]];
    dadosArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    dadosArray= [[NSMutableArray alloc] initWithArray:[dadosArray sortedArrayUsingDescriptors:@[sort]]];

    if ([[self nomePlist] isEqualToString:@"historico"])
        [self setTitle:@"Histórico"];
    else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self setTitle:@"Favoritos"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    if (indexPath)
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dadosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [[cell textLabel] setText:dadosArray[indexPath.row][@"name"]];
    
    if ([dadosArray[indexPath.row][@"ano"] isEqualToString:@"32000"])
        [[cell detailTextLabel] setText:@"Zero KM"];
    else
        [[cell detailTextLabel] setText:dadosArray[indexPath.row][@"ano"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    [(DetalheViewController*)segue.destinationViewController setRetornoUrl:dadosArray[indexPath.row][@"url"]];
}

 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [dadosArray removeObjectAtIndex:indexPath.row];
        NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%2.plist", [self nomePlist]]];
        [dadosArray writeToFile:path atomically:NO];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
