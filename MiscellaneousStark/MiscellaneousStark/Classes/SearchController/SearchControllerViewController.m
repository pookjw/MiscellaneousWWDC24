//
//  SearchControllerViewController.m
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "SearchControllerViewController.h"

@interface SearchControllerViewController ()

@end

@implementation SearchControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    [searchController release];
}

@end
