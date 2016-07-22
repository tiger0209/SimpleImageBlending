//
//  ViewController.m
//  Qasim
//
//  Created by Lion0324 on 11/19/15.
//  Copyright © 2015 Lion0324. All rights reserved.
//

#import "SelectFlagViewController.h"
#import "UIImage+OrientationFix.h"
#import "ImageProcessor.h"
#import "AppDelegate.h"

#import "EMCCountryPickerController.h"

@import Social;


@import GoogleMobileAds;

@interface SelectFlagViewController () <ImageProcessorDelegate, UIActionSheetDelegate, EMCCountryPickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;

@property (retain, nonatomic) UIImageView *m_imageView;


@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


@property (strong, nonatomic) UIImage * origImage;
@property (strong, nonatomic) UIImage * workingImage;

@end

@implementation SelectFlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UIButton *unlockProBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [unlockProBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unlockProBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [unlockProBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [unlockProBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-Bold" size:12.0f]];
    
    [unlockProBtn setBackgroundColor:[UIColor clearColor]];
    [unlockProBtn addTarget:self action:@selector(leftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    unlockProBtn.frame = CGRectMake(0, 0, 60, 30);
    unlockProBtn.layer.cornerRadius = 0.0f;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:unlockProBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    // Add right bar button item, to open in instagram app
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Export"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(rightBarButtonItemTapped:)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];

    
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    float width = self.view.bounds.size.width;
    self.m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, width, width*0.8f)];
    [self.view addSubview:self.m_imageView];
    
    
    UIImage *v_img = [AppDelegate sharedInstance].g_photoImage;

    float v_ratio = v_img.size.width / v_img.size.height;
    float v_imagView_width = self.m_imageView.frame.size.height * v_ratio;
    float v_origin_x = (self.m_imageView.frame.size.width - v_imagView_width) / 2.0f;
    float v_origin_y = self.m_imageView.frame.origin.y;
    float v_imagView_height = self.m_imageView.frame.size.height;
    
    NSLog(@"%f %f %f %f", v_origin_x, v_origin_y, v_imagView_width, v_imagView_height);
    
    v_img = [self scaleImageToSize:v_img newSize:CGSizeMake(v_imagView_width, v_imagView_height)];
    
    self.m_imageView.image = v_img;
    self.origImage = v_img;
    self.workingImage = v_img;
    
    self.m_imageView.frame = CGRectMake(v_origin_x, v_origin_y, v_imagView_width, v_imagView_height);

    
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"ca-app-pub-7254342912474713/2576678184";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];

    
}


- (UIImage *)scaleImageToSize:(UIImage*)image newSize:(CGSize)newSize
{
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / image.size.width;
    CGFloat aspectHeight = newSize.height / image.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = image.size.width * aspectRatio;
    scaledImageRect.size.height = image.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)leftBarButtonItemTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)rightBarButtonItemTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Sharing Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Save to Library", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %ld clicked\nIts title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    UIImage *v_img = self.workingImage;
    
    if (buttonIndex == 0) {
        //////Share on Facebook
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebook setInitialText:@"Uploading Image from Qasim App"];
            [facebook addImage:v_img];
            [facebook setCompletionHandler:^
             (SLComposeViewControllerResult result){
                 switch (result) {
                     case SLComposeViewControllerResultCancelled:
                         break;
                     case SLComposeViewControllerResultDone:
                         break;
                     default:
                         break;
                 }
             }];
            [self presentViewController:facebook animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FaceBook"
                                                            message:@"FaceBook integration is not available.  A FaceBook account must be set up on your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        ////////

    } else if (buttonIndex == 1){
        //////Twitter
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweet setInitialText:@"Uploading Image from Qasim App"];
            [tweet addImage:v_img];
            [tweet setCompletionHandler:^
             (SLComposeViewControllerResult result){
                 switch (result) {
                     case SLComposeViewControllerResultCancelled:
                         break;
                     case SLComposeViewControllerResultDone:
                         break;
                     default:
                         break;
                 }
             }];
            [self presentViewController:tweet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                            message:@"Twitter integration is not available.  A Twitter account must be set up on your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

        
    } else {
        /////Save
        if (!v_img) {
            return;
        }
        UIImageWriteToSavedPhotosAlbum(v_img, nil, nil, nil);
    }
}

// optional delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Will dismiss with button index %ld", (long)buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Dismissed with button index %ld", (long)buttonIndex);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)selectFlagBtn:(id)sender {
    
    
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FlagTableViewController"];
//    [self.navigationController pushViewController:vc animated:NO];
    
    self.m_imageView.image = self.origImage;
    
    EMCCountryPickerController *countryController = [[EMCCountryPickerController alloc] initWithNibName:@"EMCCountryPicker" bundle:nil];
    countryController.delegate = self;
    [self.navigationController pushViewController:countryController animated:NO];
    
}


#pragma mark - Private

- (void)setupWithImage:(UIImage*)image {
    UIImage * fixedImage = [image imageWithFixedOrientation];
    self.workingImage = fixedImage;
    
    UIImage * ghostImage = [UIImage imageNamed:@"Algeria.png"];
    
    // Commence with processing!
    [ImageProcessor sharedProcessor].delegate = self;
    [[ImageProcessor sharedProcessor] processImage:fixedImage other:ghostImage];
}

#pragma mark - ImageProcessorDelegate

- (void)imageProcessorFinishedProcessingWithImage:(UIImage *)outputImage {
    self.workingImage = outputImage;
    self.m_imageView.image = outputImage;
}


#pragma mark EMCCountryPickerControllerDelegate
//- (void)appearSelectionActionDialog:(EMCCountryPickerController *)countryController
//{
//    [countryController dismissViewControllerAnimated:YES completion:nil];
//}
- (void)disappearSelectionActionDialog:(EMCCountryPickerController *)countryController
{
//    [countryController dismissViewControllerAnimated:YES completion:nil];
}
- (void)countryController:(id)sender didSelectCountry:(UIImage*) image
{
    if (image == nil) {
        return;
    }
    
    UIImage * fixedImage = [self.m_imageView.image imageWithFixedOrientation];
    self.workingImage = fixedImage;
    
    UIImage * ghostImage = image;
    
    // Commence with processing!
    [ImageProcessor sharedProcessor].delegate = self;
    [[ImageProcessor sharedProcessor] processImage:fixedImage other:ghostImage];
    
}

@end
