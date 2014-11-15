//
//  ViewController.h
//  testCoreDataApp
//
//  Created by Jakub Truhlar on 15.11.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *name;
@property (nonatomic, strong) NSMutableArray *phone;

@end

