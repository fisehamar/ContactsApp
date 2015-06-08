//
//  ViewController.m
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "ContactListViewController.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "AddContactViewController.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    _managedObjectContext = delegate.managedObjectContext;
    
    _contacts = [self getAllContacts];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Contact *contact = _contacts[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", contact.lastName, contact.firstName];
    cell.detailTextLabel.text = contact.phone;
    cell.imageView.image = [self resizeImage:contact.image];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *deletedContact = _contacts[indexPath.row];
    
    [self.managedObjectContext deleteObject:deletedContact];
    
    _contacts = [self getAllContacts];
    
    //remove the row from table view
    NSArray *rows = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    
    BOOL success = [self.managedObjectContext save:nil];
    
    if(success)
    {
        NSLog(@"Contact deleted successfully");
    }
}

-(NSArray *)getAllContacts
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //execute fetch request
    NSArray *contacts = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return contacts;
}

- (IBAction)addContactToList:(id)sender
{
    [self performSegueWithIdentifier:@"toAddContact" sender:self];
}

-(void)addContact:(Contact *)contact
{
    NSMutableArray *mutableContacts = [_contacts mutableCopy];
    
    [mutableContacts addObject:contact];
    
    _contacts = [self getAllContacts];
    
    [self.tableView reloadData];
    
    [self save];
}

-(void)updateContacts
{
    [self.tableView reloadData];
}

-(void)save
{
    NSError *error;
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"Saved");
    }
    else {
        NSLog(@"Error: %@", error);
    }
    [self updateContacts];
}

-(UIImage *)resizeImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, 75, 75);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(transformedImage);
    UIImage *finalImage = [UIImage imageWithData:imgData];
    
    return finalImage;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    
    if([segue.identifier isEqualToString:@"toAddContact"])
    {
        AddContactViewController *aController = segue.destinationViewController;
        aController.managedObjectContext = _managedObjectContext;
        aController.delegate = self;
    }
    
    else if([segue.identifier isEqualToString:@"toContactDetail"] && _contacts != nil)
    {
        Contact *myContact = _contacts[indexPath.row];
        ContactDetailViewController *cdvc = segue.destinationViewController;
        cdvc.delegate = self;
        cdvc.contact = myContact;
    }
}
@end
