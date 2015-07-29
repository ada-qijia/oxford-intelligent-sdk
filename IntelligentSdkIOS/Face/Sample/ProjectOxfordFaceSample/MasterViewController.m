//
//  MasterViewController.m
//  ProjectOxfordFaceSample
//
//  Copyright (c) 2015 microsoft. All rights reserved.
//

#import "MasterViewController.h"
#import "DetectionViewController.h"
#import "VerificationViewController.h"
#import "GroupingViewController.h"
#import "FindSimilarViewController.h"
#import "OthersViewController.h"

@interface MasterViewController ()

@property NSMutableArray *scenarios;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeObjects];
    self.title = @"Microsoft.ProjectOxford.Face Sample";
    
    //start from DetectionDetailViewController for pad
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        DetectionViewController *controller = [[DetectionViewController alloc] init];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        UINavigationController *nav = [self.splitViewController.viewControllers lastObject];
        [nav setViewControllers:@[controller]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initializeObjects{
    self.scenarios = [NSMutableArray arrayWithObjects:@"Detection", @"Verification", @"Grouping", @"Find Similar", @"All", nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIViewController *controller;
        if(indexPath.row == 0)
        {
            controller= [[DetectionViewController alloc] init];
            [[segue destinationViewController] setViewControllers:@[controller] animated:NO];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
        else if (indexPath.row == 1)
        {
            controller= [[VerificationViewController alloc] init];
            [[segue destinationViewController] setViewControllers:@[controller] animated:NO];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
        else if (indexPath.row == 2)
        {
            controller= [[GroupingViewController alloc] init];
            [[segue destinationViewController] setViewControllers:@[controller] animated:NO];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
        else if (indexPath.row == 3)
        {
            controller= [[FindSimilarViewController alloc] init];
            [[segue destinationViewController] setViewControllers:@[controller] animated:NO];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
        else
        {
            controller = [[OthersViewController alloc] init];
            [[segue destinationViewController] setViewControllers:@[controller] animated:NO];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scenarios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.scenarios[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
