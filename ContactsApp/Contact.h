//
//  Contact.h
//  ContactsApp
//
//  Created by Joffrey Mann on 5/7/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) id image;

@end
