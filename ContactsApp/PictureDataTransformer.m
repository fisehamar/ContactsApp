//
//  PictureDataTransformer.m
//  TeamData
//
//  Created by Joffrey Mann on 5/4/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "PictureDataTransformer.h"

@implementation PictureDataTransformer

/* Class method that returns the class of the tranformed value */
+(Class)transformedValueClass
{
    return [NSData class];
}

/* Set the return to YES to allow us to convert the NSData back into a UIImage object */
+(BOOL)allowsReverseTransformation
{
    return YES;
}

/* Converts the UIImage into an NSData object that can be stored in Core Data */
-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

/* Converts the NSData accessed from Core Data into a UIImage object */
-(id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}

@end
