//
//  EditContactViewController.m
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "EditContactViewController.h"
#import "AppDelegate.h"
#import "ContactDetailViewController.h"

@interface EditContactViewController ()

@property (strong, nonatomic) UIImage *contactImage;

@end

@implementation EditContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _emailField.delegate = self;
    _phoneField.delegate = self;
    
    _firstNameField.text = _contact.firstName;
    _lastNameField.text = _contact.lastName;
    _emailField.text = _contact.email;
    _phoneField.text = _contact.phone;
    _datePicker.date = _contact.dob;
    
    self.title = @"Add Contact";
    
    ContactDetailViewController *cdvc = [[ContactDetailViewController alloc]init];
    cdvc.delegate = self;
    
    _doneButton.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_contactImage != nil)
    {
        _doneButton.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editContactInList:(id)sender
{
    _contact.firstName = _firstNameField.text;
    _contact.lastName = _lastNameField.text;
    _contact.email = _emailField.text;
    _contact.dob = _datePicker.date;
    _contact.phone = _phoneField.text;
    _contact.image = _contactImage;
    
    if(_delegate != nil)
    {
        [_delegate editContact:_contact];
        [self save];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (IBAction)savePhoto:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if(!image) image = info[UIImagePickerControllerOriginalImage];
    
    _contactImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
