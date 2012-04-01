//
//  MLHomeViewController.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 26/03/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "MLHomeViewController.h"
#import "UIImage+CoreImageEffects.h"
#import "UIToolbar+EEToolbarCenterButton.h"



@interface MLHomeViewController ()

@end


@implementation MLHomeViewController


#pragma mark Creating elements

- (void)createToolbar {
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (460 - 44), 320, 44)];
	[toolbar setTintColor:[UIColor grayColor]];
	[toolbar setCenterButtonFeatureEnabled:YES];
	[self.view addSubview:toolbar];
	[toolbar.layer setZPosition:100];
	
	UIImage *centerButtonImage = [UIImage imageNamed:@"CenterButtonIcon.png"];
    UIImage *centerButtonImageHighlighted = [UIImage imageNamed:@""];
    UIImage *centerButtonImageDisabled = [UIImage imageNamed:@"CenterButtonIconDesabled.png"];
    EEToolbarCenterButtonItem *cbi = [[EEToolbarCenterButtonItem alloc] initWithImage:centerButtonImage highlightedImage:centerButtonImageHighlighted disabledImage:centerButtonImageDisabled target:self action:@selector(didTapPhotoButton:)];
	[toolbar.centerButtonOverlay setButtonItem:cbi];
	
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixedSpace setWidth:4];
	
	toolbarGalleryButton = [[MLGalleryButtonView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
	[toolbarGalleryButton setDelegate:self];
	UIBarButtonItem *gb = [[UIBarButtonItem alloc] initWithCustomView:toolbarGalleryButton];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[toolbar setItems:[NSArray arrayWithObjects:fixedSpace, gb, flexibleSpace, nil] animated:YES];
}

- (void)createMainView {
	mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (460 - 44))];
	[mainView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:mainView];
}

- (void)createCameraSideView {
	cameraSideView = [[UIView alloc] initWithFrame:mainView.bounds];
	[mainView addSubview:cameraSideView];
}

- (void)createGallerySideView {
	gallerySideView = [[UIView alloc] initWithFrame:mainView.bounds];
	[gallerySideView setBackgroundColor:[UIColor redColor]];
}

- (void)createPhotoView {
	cameraView = [[FTCameraView alloc] initWithFrame:cameraSideView.bounds];
	[cameraView setClipsToBounds:YES];
	[cameraView setContentMode:UIViewContentModeScaleAspectFit];
	[cameraView setDelegate:self];
	[cameraSideView addSubview:cameraView];
	[cameraView initCapture];
}

- (void)createImageBlockerView {
	blockerView = [[UIView alloc] initWithFrame:cameraSideView.bounds];
	[blockerView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
	[blockerView setAlpha:0];
	[blockerView.layer setZPosition:50];
	[cameraSideView addSubview:blockerView];
	
	imageView = [[UIImageView alloc] initWithFrame:blockerView.bounds];
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	[blockerView addSubview:imageView];
	[imageView makeMarginInSuperView:14];
	
	whiteView = [[UIView alloc] initWithFrame:blockerView.bounds];
	[whiteView setBackgroundColor:[UIColor whiteColor]];
	[whiteView setAlpha:0];
	[blockerView addSubview:whiteView];
}

- (void)createTopButtons {
	buttonsView = [[MLButtonsView alloc] initWithFrame:CGRectMake(0, 12, 320, 30)];
	[cameraSideView addSubview:buttonsView];
	[buttonsView.layer setZPosition:200];
}

- (void)createAllElements {
	[self createMainView];
	[self createCameraSideView];
	[self createGallerySideView];
	[self createPhotoView];
	[self createImageBlockerView];
	[self createToolbar];
	[self createTopButtons];
}

#pragma mark Gallery view button delegate method

- (void)galleryButtonView:(MLGalleryButtonView *)view didSelectScreen:(MLGalleryButtonViewScreen)screen {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	if (screen == MLGalleryButtonViewScreenGallery) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mainView cache:YES];
		[cameraSideView removeFromSuperview];
		[mainView addSubview:gallerySideView];
		[toolbar.centerButtonOverlay.buttonItem setEnabled:NO];
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainView cache:YES];
		[gallerySideView removeFromSuperview];
		[mainView addSubview:cameraSideView];
		[toolbar.centerButtonOverlay.buttonItem setEnabled:YES];
	}
	[UIView commitAnimations];
}

#pragma mark Button actions

- (void)didTapPhotoButton:(UIButton *)sender {
	[toolbar.centerButtonOverlay.buttonItem setEnabled:NO];
	[super enableLoadingProgressViewWithTitle:@"Saving ..." andAnimationStyle:FTProgressViewAnimationFade];
	[super.loadingProgressView.layer setZPosition:150];
	[cameraView captureImageAsynchronously];
}

#pragma mark UI stuff

- (void)cleanBlocker {
	[imageView setImage:nil];
}

- (void)hideBlocker {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(cleanBlocker)];
	[blockerView setAlpha:0];
	[UIView commitAnimations];
}

- (void)showWhiteViewAnimation {
	[UIView animateWithDuration:0.2 animations:^(void) {
		[whiteView setAlpha:0.8];
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.1 animations:^(void) {
			[whiteView setAlpha:0.2];
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.2 animations:^(void) {
				[whiteView setAlpha:0.8];
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.1 animations:^(void) {
					[whiteView setAlpha:0];
				} completion:^(BOOL finished) {
					
				}];
			}];
		}];
	}];
}

- (void)enableUI {
	[super.loadingProgressView hide:YES];
	[toolbar.centerButtonOverlay.buttonItem setEnabled:YES];
	
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showWhiteViewAnimation) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hideBlocker) userInfo:nil repeats:NO];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	[self performSelectorOnMainThread:@selector(enableUI) withObject:nil waitUntilDone:NO];
}

- (void)showTakenImage:(UIImage *)image {
	[imageView setImage:image];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[blockerView setAlpha:1];
	[UIView commitAnimations];
}

- (void)generateImageWithEffect:(UIImage *)image {
	image = [image effectLomo];
	[self performSelectorOnMainThread:@selector(showTakenImage:) withObject:image waitUntilDone:NO];
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)startGeneratingImageWithEffect:(UIImage *)image {
	@autoreleasepool {
		[self performSelectorInBackground:@selector(generateImageWithEffect:) withObject:image];
	}
}

#pragma mark Camera delegate methods

- (void)cameraView:(FTCameraView *)view didCaptureImage:(UIImage *)image {
	[self performSelectorOnMainThread:@selector(showTakenImage:) withObject:image waitUntilDone:NO];
	@autoreleasepool {
		[NSThread detachNewThreadSelector:@selector(startGeneratingImageWithEffect:) toTarget:self withObject:image];
	}
}

#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
	
	[self createAllElements];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
