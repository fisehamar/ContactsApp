//
//  ContactDetailViewController.h
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditContactViewController.h"
#import "EditContactDelegate.h"
#import "ContactDetailDelegate.h"
#import "Contact.h"

@interface ContactDetailViewController : UIViewController<EditContactDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) Contact *contact;
@property (weak, nonatomic) id <ContactDetailDelegate> delegate;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contactImgView;

@end
