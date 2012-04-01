//
//  MLGalleryButtonView.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "MLGalleryButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MLGalleryButtonView

@synthesize delegate = _delegate;


#pragma mark Configure side view

- (void)configureSideView:(UIView *)view {
	[view.layer setCornerRadius:5];
	[view setClipsToBounds:YES];
}

#pragma mark Button actions

- (void)didTapButton:(UIButton *)sender {
	UIView *senderView = sender.superview;
	MLGalleryButtonViewScreen s;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	if (senderView == cameraView) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:senderView.superview cache:YES];
		[cameraView removeFromSuperview];
		[mainView addSubview:galleryView];
		s = MLGalleryButtonViewScreenGallery;
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:senderView.superview cache:YES];
		[galleryView removeFromSuperview];
		[mainView addSubview:cameraView];
		s = MLGalleryButtonViewScreenCamera;
	}
	[UIView commitAnimations];
	
	if ([_delegate respondsToSelector:@selector(galleryButtonView:didSelectScreen:)]) {
		[_delegate galleryButtonView:self didSelectScreen:s];
	}
}

#pragma Creating elements

- (void)createAllElements {
	mainView = [[UIView alloc] initWithFrame:self.bounds];
	[mainView setBackgroundColor:[UIColor clearColor]];
	[self addSubview:mainView];
	
	cameraView = [[UIView alloc] initWithFrame:self.bounds];
	[cameraView setBackgroundColor:[UIColor orangeColor]];
	[self configureSideView:cameraView];
	[mainView addSubview:cameraView];
	
	UIButton *b = [[UIButton alloc] initWithFrame:self.bounds];
	[b addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[cameraView addSubview:b];
	
	galleryView = [[UIView alloc] initWithFrame:self.bounds];
	[galleryView setBackgroundColor:[UIColor blackColor]];
	[self configureSideView:galleryView];
	
	b = [[UIButton alloc] initWithFrame:self.bounds];
	[b addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
	[b setImage:[UIImage imageNamed:@"camera-ico.png"] forState:UIControlStateNormal];
	[galleryView addSubview:b];
}

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self createAllElements];
	}
	return self;
}

@end
