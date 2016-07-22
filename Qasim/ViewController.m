//
//  ViewController.m
//  Qasim
//
//  Created by Lion0324 on 11/19/15.
//  Copyright © 2015 Lion0324. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+OrientationFix.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"


@import GoogleMobileAds;


@interface ViewController () <UIImagePickerControllerDelegate, GADInterstitialDelegate>
{
    MBProgressHUD           *mProgress;

}
/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (strong, nonatomic) UIImagePickerController * imagePickerController;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Show Some Love";
    
    mProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mProgress.mode = MBProgressHUDModeIndeterminate;
    mProgress.labelText = @"Please Wait...";
    [mProgress show: YES];

    
    [self createAndLoadInterstitial];
    
    
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID = @"ca-app-pub-7254342912474713/2576678184";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(appearAD) userInfo:nil repeats:YES];

}

- (void)appearAD {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
        [self.timer invalidate];
        [mProgress hide:YES];
        
    } else {
//        [[[UIAlertView alloc] initWithTitle:@"Interstitial not ready"
//                                    message:@"The interstitial didn't finish loading or failed to load"
//                                   delegate:self
//                          cancelButtonTitle:@"Drat"
//                          otherButtonTitles:nil] show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) { /* Lazy Loading */
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - IBActions

- (IBAction)takePhotoBtn:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)chooseFromGalleryBtn:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Private

- (void)setupWithImage:(UIImage*)image {
    UIImage * fixedImage = [image imageWithFixedOrientation];
    [AppDelegate sharedInstance].g_photoImage = fixedImage;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(goEditingView) userInfo:nil repeats:NO];
}

-(void) goEditingView
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectFlagViewController"];
    [self.navigationController pushViewController:vc animated:NO];

}

#pragma mark - Protocol Conformance


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Dismiss the imagepicker
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self setupWithImage:info[UIImagePickerControllerOriginalImage]];
}

- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7254342912474713/4053411380"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];

}


#pragma mark GADInterstitialDelegate implementation

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    
}


@end
