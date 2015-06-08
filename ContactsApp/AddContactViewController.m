//
//  AddContactViewController.m
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()

@property (strong, nonatomic) UIImage *contactImage;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _emailField.delegate = self;
    _phoneField.delegate = self;
    
    self.title = @"Add Contact";
    _doneButton.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_contactImage != nil)
    {
        _doneButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if(!image) image = info[UIImagePickerControllerOriginalImage];
    
    _contactImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPersonToContactsWithSender:(UIBarButtonItem *)sender
{
    Contact *contact = [self createContactWithValues];
    
    NSData *localData = [self dataFromImage];
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)contact.firstName, nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)contact.lastName, nil);
    
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)contact.phone, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumbers, nil);
    
    ABPersonSetImageData(person, (__bridge CFDataRef)localData, nil);
    ABAddressBookAddRecord(addressBookRef, person, nil);
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        if (CFStringCompare(ABRecordCopyCompositeName(thisContact),
                            ABRecordCopyCompositeName(person), 0) == kCFCompareEqualTo){
            //The contact already exists!
            UIAlertView *contactExistsAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"There can only be one %@", contact.firstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [contactExistsAlert show];
            return;
        }
    }
    ABAddressBookSave(addressBookRef, nil);
    UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [contactAddedAlert show];
}

- (IBAction)saveContactToList:(id)sender
{
    Contact *contact = [self createContactWithValues];
    
    if(_delegate != nil)
    {
        [_delegate addContact:contact];
    }
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        NSLog(@"Authorized");
        [self addPersonToContactsWithSender:sender];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    //4
                    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantAddContactAlert show];
                    return;
                }
                //5
                //[self addPersonToContactsWithSender:sender];
            });
        });
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addPhoto:(UIBarButtonItem *)sender
{
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    
    /* If the Camera is avaliable use it to choose the image if not then use the album */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Camera available" message:@"Would you like to use the camera" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    
    else {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    else
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(NSData *)dataFromImage
{
    NSData *data = UIImageJPEGRepresentation(_contactImage, 1.0);
    
    return data;
}

-(Contact *)createContactWithValues
{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:_managedObjectContext];
    Contact *contact = [[Contact alloc]initWithEntity:description insertIntoManagedObjectContext:_managedObjectContext];
    contact.firstName = _firstNameField.text;
    contact.lastName = _lastNameField.text;
    contact.email = _emailField.text;
    contact.dob = _datePicker.date;
    contact.phone = _phoneField.text;
    contact.image = _contactImage;
    
    return contact;
}

@end
