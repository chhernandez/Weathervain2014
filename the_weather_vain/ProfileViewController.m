//
//  ProfileViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 4/14/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "ProfileViewController.h"
#import "TimelineTableViewCell.h"
#import "WXManager.h"
#import "PhotoCollectionViewController.h"
#import "cdkMainViewController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface ProfileViewController ()
@property (nonatomic,strong) NSArray *data;
@property (nonatomic, strong) PFUser *currentUser;
@end

@implementation ProfileViewController

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
    
    FAKFontAwesome *othersIcon = [FAKFontAwesome usersIconWithSize:15];
    FAKFontAwesome *myIcon = [FAKFontAwesome thLargeIconWithSize:15];
    
    

    
    
    
    
    
    [self.top_profile_view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_TopBG"]]];
    
    
    //change fonts
 //   [[UILabel appearance] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular.ttf" size:12.0]];

    // background image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tallBG_smaller.png"]];
    [self.tableView setBackgroundView:imageView];
    
    // navigation bar
    UINavigationBar *home_NavBar = [self.navigationController navigationBar];
    UIImage *img = [UIImage imageNamed:@"navBGblue.png"];
    [home_NavBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
    
    //who is the user
    self.currentUser = [PFUser currentUser];
    
   
    /*display profile pic*/
    
        //A.Fetch the image data from facebook url
    
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.currentUser objectForKey:@"facebookID"]];
    
        //B. Assign the image data we fetched to the UIImageView
    [self.profilePic setImageWithURL:[NSURL URLWithString:userImageURL]];

    
    /*display user name*/
    self.userName.text = self.currentUser[@"username"];
        

    
    
    if (self.currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query whereKey:@"user"  equalTo:self.currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.data = objects;
                [self.tableView reloadData];
            }
            
        }];
    } 
    
    
}
-(void) viewDidAppear:(BOOL)animated
{
    if(![PFUser currentUser] && !self.showedLoginError)
    {
        self.showedLoginError = true;
    }
    if (self.currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query whereKey:@"user"  equalTo:self.currentUser];
        [query addDescendingOrder:@"updatedAt"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.data = objects;
                [self.tableView reloadData];
            }
            
        }];
    }
 

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    BOOL result = YES;
    
    if ([identifier isEqualToString:@"yours"]) {
        if (!self.currentUser) {
            result = NO;
            
        }
    }
    
    return result;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Edit Profile"]) {
        return;
    }
    
     PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    if ([segue.identifier isEqualToString:@"others"]) {
        [query whereKey:@"private" equalTo:[NSNumber numberWithBool:NO]];

    } else if([segue.identifier isEqualToString:@"yours"]){
        [query whereKey:@"user" equalTo:self.currentUser];
        
    }
    WXManager *manager = [WXManager sharedManager];
    [query whereKey:@"weatherTag" containsString:manager.getCurrentWeatherTag];
    //[query addAscendingOrder:@"updatedAt"];
    
    PhotoCollectionViewController *photoCollectionViewController = segue.destinationViewController;
    photoCollectionViewController.query = query;
   
        
}

#pragma mark - UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.data count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFObject *photo = [self.data objectAtIndex:indexPath.row];
    PFFile *file = photo[@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
       if(!error)
       {
           UIImage *image = [UIImage imageWithData:data];
           [cell.timelinePhoto setImage:image];
       }
    }];
    [cell.UserNTag setText:photo[@"weatherTag"]];
    
    UIImage * pic = [UIImage imageNamed: @"profile_BottomBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:pic];
    
    cell.backgroundView = imageView;

    return cell;
}

@end
