//
//  PictureDetailViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 4/14/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pictureTag;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) PFObject *photo;
@end
