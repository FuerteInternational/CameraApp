//
//  MLHomeViewController.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 26/03/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "MLViewController.h"
#import "FTCameraView.h"
#import "MLButtonsView.h"
#import "MLGalleryButtonView.h"


@interface MLHomeViewController : MLViewController <FTCameraViewDelegate, MLGalleryButtonViewDelegate> {
	
	UIView *mainView;
	UIView *cameraSideView;
	UIView *gallerySideView;
	
	FTCameraView *cameraView;
	
	UIView *whiteView;
	UIImageView *imageView;
	UIView *blockerView;
	
	UIToolbar *toolbar;
	MLGalleryButtonView *toolbarGalleryButton;
	
	MLButtonsView *buttonsView;
	
}


@end
