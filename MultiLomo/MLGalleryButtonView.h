//
//  MLGalleryButtonView.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTView.h"


typedef enum {
	MLGalleryButtonViewScreenCamera,
	MLGalleryButtonViewScreenGallery
} MLGalleryButtonViewScreen;

@class MLGalleryButtonView;

@protocol MLGalleryButtonViewDelegate <NSObject>

- (void)galleryButtonView:(MLGalleryButtonView *)view didSelectScreen:(MLGalleryButtonViewScreen)screen;

@end

@interface MLGalleryButtonView : FTView {
	
	UIView *mainView;
	UIView *cameraView;
	UIView *galleryView;
	
}

@property (nonatomic, assign) id <MLGalleryButtonViewDelegate> delegate;


@end
