//
//  cdkMasterViewController.h
//  FashionExample
//
//  Created by Carlos Hernandez on 2/16/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//


#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface cdkMasterViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *myItemsTitle;
@property (strong, nonatomic) NSString *TypeList;

@property (strong, nonatomic) NSString *Frigid;
@property (strong, nonatomic) NSString *Cold;
@property (strong, nonatomic) NSString *Mild;
@property (strong, nonatomic) NSString *Brisk;
@property (strong, nonatomic) NSString *Sizzling;
@property (strong, nonatomic) NSString *Hot;
@property (strong, nonatomic) NSString *Warm;



@end
