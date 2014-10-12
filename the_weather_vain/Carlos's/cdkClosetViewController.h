//
//  cdkClosetViewController.h
//  FashionExample
//
//  Created by Carlos Hernandez on 3/2/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cdkClosetViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSArray *typeImages;
//- (IBAction)myResetClosetButton:(id)sender;

//+ (void) createCarName;

- (bool) checkIfEmptyCloset:(PFUser*) currUser;
- (void) createCustomCloset:(PFUser*) currUser;

@end
