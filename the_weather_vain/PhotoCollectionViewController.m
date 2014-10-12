//
//  PhotoCollectionViewController.m
//  WeatherVain
//
//  Created by Tehreem Syed on 4/14/14.
//  Copyright (c) 2014 CodeKite. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "Collagecell.h"
#import "PictureDetailViewController.h"

@interface PhotoCollectionViewController ()
@property (nonatomic, strong) NSArray *data;

@end

@implementation PhotoCollectionViewController

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
    //TODO :Arrange photos based on that days weather.
    //[query whereKey:@"weatherTag" equalTo:@"mild"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.data = objects;
            [self.collectionView reloadData];
        }
        
    }];
    UIImage * pic = [UIImage imageNamed: @"profile_BottomBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:pic];
    

    [self.collectionView setBackgroundView:(imageView)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Collagecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    PFObject *photo = [self.data objectAtIndex:indexPath.row];
    PFFile *file = photo[@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            [cell.photos setImage:image];
        }
    }];
    
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"pictureDetail" sender:indexPath];
}

#pragma mark - performSegue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pictureDetail"]) {
        PictureDetailViewController *pictureViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *) sender;
        PFObject *photo = [self.data objectAtIndex:indexPath.row];
        
        
        pictureViewController.photo = photo;
        

        
    }
}

@end
