//
//  AddContactViewController.h
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactDelegate.h"
#import <AddressBook/AddressBook.h>

@interface AddContactViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) id <AddContactDelegate> delegate;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)saveContactToList:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addPhoto:(UIBarButtonItem *)sender;

@end
