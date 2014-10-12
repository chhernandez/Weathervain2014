//
//  PictureDetailViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 4/14/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "PictureDetailViewController.h"

@interface PictureDetailViewController ()

@end

@implementation PictureDetailViewController
@synthesize photo, picture, pictureTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFFile *file = photo[@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error)
        {
            UIImage *imageFromData = [UIImage imageWithData:data];
            [picture setImage:imageFromData];
        }
    }];
    
    [pictureTag setText:photo[@"weatherTag"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
