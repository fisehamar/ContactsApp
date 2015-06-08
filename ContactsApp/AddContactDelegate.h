//
//  AddContactDelegate.h
//  ContactsApp
//
//  Created by Joffrey Mann on 4/28/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol AddContactDelegate <NSObject>

-(void)addContact:(Contact *)contact;

@end
