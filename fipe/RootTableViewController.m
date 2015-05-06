//
//  RootTableViewController.m
//  fipe
//
//  Created by Marcos on 07/04/15.
//  Copyright (c) 2015 UMobApp. All rights reserved.
//

#import "RootTableViewController.h"
#import "MontadoraTableViewController.h"
#import "FavoritoTableViewController.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"favoritos"] && ![segue.identifier isEqualToString:@"historico"]) {
        MontadoraTableViewController *destViewController = segue.destinationViewController;
        [destViewController setConsultaNome:segue.identifier];
        [destViewController setConsultaIndice:@1];
    } else {
        FavoritoTableViewController *destViewController = segue.destinationViewController;
        [destViewController setNomePlist:segue.identifier];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 && indexPath.section == 1) {
        NSString *emailTitle = @"UMobApp Fipe";
        NSString *messageBody = @"Estou usando o UMobApp Fipe";
        NSArray *toRecipents = [NSArray arrayWithObject:@"marcoscarlesso@hotmail.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
