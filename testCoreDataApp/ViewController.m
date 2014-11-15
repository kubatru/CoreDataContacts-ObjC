//
//  ViewController.m
//  testCoreDataApp
//
//  Created by Jakub Truhlar on 15.11.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.name = [[NSMutableArray alloc] init];
    self.phone = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    // Only for entities named Jakub (ergo Cells only with text Jakub)
    // NSPredicate *pred =[NSPredicate predicateWithFormat:@"(name = %@)", @"Jakub"];
    // [request setPredicate:pred];
    
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [self.name addObject:[matches valueForKey:@"name"]];
            [self.phone addObject:[matches valueForKey:@"phone"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtn:(id)sender {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Add a contact"
                                message:@"Enter the data"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    // Přidat textFields
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"name"];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"phone number"];
    }];
    
    // Akce
    UIAlertAction *add = [UIAlertAction
                         actionWithTitle:@"Add"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             // Do some thing here
                             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                             NSManagedObjectContext *context = [appDelegate managedObjectContext];
                             
                             NSManagedObject *newContact;
                             newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
                             
                             UITextField *nameField = alert.textFields[0];
                             UITextField *phoneField = alert.textFields[1];
                             
                             [newContact setValue: nameField.text forKey:@"name"];
                             [self.name addObject:[newContact valueForKey:@"name"]];
                             [newContact setValue: phoneField.text forKey:@"phone"];
                             [self.phone addObject:[newContact valueForKey:@"phone"]];
                             
                             NSError *error;
                             [context save:&error];
                             [self.tableView reloadData];
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 // Do some thing here
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:add]; // Přidat akci pod uialertcontroller
    [alert addAction:cancel]; // Přidat akci pod uialertcontroller
}

#pragma Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.name.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.name objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.phone objectAtIndex:indexPath.row];
    return cell;
}

@end
