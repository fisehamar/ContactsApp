//
//  ContactDetailViewController.m
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "AppDelegate.h"

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self displayValues];
    self.navigationItem.title = _contact.firstName;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    _managedObjectContext = delegate.managedObjectContext;
    _contactImgView.layer.cornerRadius = _contactImgView.frame.size.width/2;
    _contactImgView.clipsToBounds = YES;
}

-(void)displayValues
{
    _firstNameLabel.text = [NSString stringWithFormat:@"First Name   %@", _contact.firstName];
    _lastNameLabel.text = [NSString stringWithFormat:@"Last Name   %@", _contact.lastName];
    _emailLabel.text = [NSString stringWithFormat:@"E-mail   %@", _contact.email];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    _dobLabel.text = [NSString stringWithFormat:@"Date   %@", [formatter stringFromDate:_contact.dob]];
    _phoneLabel.text = [NSString stringWithFormat:@"Phone   %@", _contact.phone];
    _contactImgView.image = _contact.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editContact:(Contact *)contact
{
    [self displayValues];
    [self.delegate save];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditContactViewController *eController = segue.destinationViewController;
    eController.delegate = self;
    eController.contact = _contact;
}

@end
