//
//  ViewController.m
//  MapScenariosObjC
//
//  Created by Patrick Dunshee on 3/5/18.
//  Copyright © 2018 Patrick Dunshee. All rights reserved.
//

#import "ScenarioSelectViewController.h"

@interface ScenarioSelectViewController ()

@end

@implementation ScenarioSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end
