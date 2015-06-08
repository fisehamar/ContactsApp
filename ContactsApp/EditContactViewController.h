//
//  EditContactViewController.h
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditContactDelegate.h"
#import "ContactDetailDelegate.h"
#import "Contact.h"

@interface EditContactViewController : UIViewController<UITextFieldDelegate, ContactDetailDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id <EditContactDelegate> delegate;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) Contact *contact;

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)addContactToList:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)savePhoto:(id)sender;

@end
