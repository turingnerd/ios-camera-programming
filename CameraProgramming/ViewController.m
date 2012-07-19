//
//  ViewController.m
//  CameraProgramming
//
//  Created by trevisan on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;
@synthesize btnTakePic;

- (IBAction)takePicPressed:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self startCameraControllerFromViewController:self usingDelegate:self];
	}
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
								   usingDelegate: (id <UIImagePickerControllerDelegate,
												   UINavigationControllerDelegate>) delegate {
	
    if (([UIImagePickerController isSourceTypeAvailable:
		  UIImagePickerControllerSourceTypeCamera] == NO)
		|| (delegate == nil)
		|| (controller == nil))
        return NO;
	
	
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
	
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
	[UIImagePickerController availableMediaTypesForSourceType:
	 UIImagePickerControllerSourceTypeCamera];
	
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
	
    cameraUI.delegate = delegate;
	
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

#pragma mark - camera delegate

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
	
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
	
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
	
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
		== kCFCompareEqualTo) {
		
        editedImage = (UIImage *) [info objectForKey:
								   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
									 UIImagePickerControllerOriginalImage];
		
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
		
		[imageView setImage:imageToSave];
		
		// Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
	
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
		== kCFCompareEqualTo) {
		
        NSString *moviePath = [[info objectForKey:
								UIImagePickerControllerMediaURL] path];
		
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
												 moviePath, nil, nil, nil);
        }
    }
	
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
}

#pragma mark - view lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[btnTakePic setHidden:YES];
	}
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setBtnTakePic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (void)dealloc {
    [imageView release];
    [btnTakePic release];
    [super dealloc];
}
@end
