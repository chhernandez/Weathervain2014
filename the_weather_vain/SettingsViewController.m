//
//  SettingsViewController.m
//  WeatherVain
//
//  Created by Jung Yoon on 4/26/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // background image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blurredbg.png"]];
    [self.tableView setBackgroundView:imageView];
    
    self.navigationItem.hidesBackButton = YES;
    
    // navigation bar
    UINavigationBar *home_NavBar = [self.navigationController navigationBar];
    UIImage *img = [UIImage imageNamed:@"navBGblue.png"];
    [home_NavBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    // no extra lines below tavle view
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //UIEdgeInsets inset = UIEdgeInsetsMake(50, 0, 0, 0);
    //self.tableView.contentInset = inset;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(70,0,0,0)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mySignOut:(id)sender {
    
    NSLog(@"In the logout function...");
    /*
     [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     
     NSLog(@"The user is no longer associated with their Facebook account.");
     
     [PFUser logOut];
     [self.navigationController popViewControllerAnimated:YES];
     }
     }];
     */
    
    //   [self.parentViewController.tabBarController setSelectedIndex:1];
    [PFUser logOut];
    
    //   [self.parentViewController.tabBarController setSelectedIndex:3];
    [self.parentViewController.tabBarController setSelectedIndex:0];
    //  [self.navigationController popViewControllerAnimated:YES];
    
}
@end
