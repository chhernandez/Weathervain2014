//
//  cdkDetailViewController.h
//  FashionExample
//
//  Created by Carlos Hernandez on 2/16/14.
//  Copyright (c) 2014 Carlos Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "cdkRateView.h"

@interface cdkDetailViewController : UIViewController

@property (strong, nonatomic) PFObject *detailItem;

@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet cdkRateView *rateView;
//@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxLabel;



@property (weak, nonatomic) IBOutlet UISwitch *switchSizzling;
@property (weak, nonatomic) IBOutlet UISwitch *switchWarm;
@property (weak, nonatomic) IBOutlet UISwitch *switchFrigid;
@property (weak, nonatomic) IBOutlet UISwitch *switchBrisk;

@property (weak, nonatomic) IBOutlet UISwitch *switchHot;
@property (weak, nonatomic) IBOutlet UISwitch *switchMild;
@property (weak, nonatomic) IBOutlet UISwitch *switchCold;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//- (IBAction)mySaveItemButton:(id)sender;


//- (IBAction)actionSave:(id)sender;


- (IBAction)mySaveButton:(id)sender;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end
