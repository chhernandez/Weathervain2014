//
//  WVCameraViewController.h
//  WeatherVain
//
//  Created by Tehreem Syed on 4/8/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface myViewController : UIViewController <UIAlertViewDelegate> {
}
@end

@interface WVCameraViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UILabel *currentTag;
@property (weak, nonatomic) IBOutlet UISwitch *switch_private;
@property (weak, nonatomic) IBOutlet UIView *pictureDetailView;
@property BOOL showedLoginError;

-(void) setImageForPreview:(UIImage *) image;

@end
