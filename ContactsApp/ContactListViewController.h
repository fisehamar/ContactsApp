//
//  ViewController.h
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddContactDelegate.h"
#import "ContactDetailDelegate.h"
#import "ContactDetailViewController.h"

@interface ContactListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, AddContactDelegate, ContactDetailDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSArray *contacts;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(NSArray *)getAllContacts;

- (IBAction)addContactToList:(id)sender;

@end

