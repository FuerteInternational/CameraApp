//
//  MLButtonsView.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "MLButtonsView.h"

@implementation MLButtonsView

@synthesize buttonFlash = _buttonFlash;
@synthesize buttonOptions = _buttonOptions;
@synthesize buttonCamera = _buttonCamera;


#pragma mark Layout

- (void)layoutForLandscape:(BOOL)landscape {
	isLandscape = landscape;
}

#pragma mark Creating elements

- (void)createAllButtons {
	autoLineView = [[FTAutoLineView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	//[autoLineView setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.2]];
	[self addSubview:autoLineView];
	
	self.buttonFlash = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
	[_buttonFlash setTitle:@"Flash" forState:UIControlStateNormal];
	[autoLineView addSubview:_buttonFlash];
	
	self.buttonOptions = [[FTCameraButtonView alloc] initWithFrame:CGRectMake(0, 0, 74, 30)];
	[_buttonOptions setTitle:@"Options" forState:UIControlStateNormal];
	[autoLineView addSubview:_buttonOptions];
	
	[autoLineView layoutElements];
}

#pragma mark Initialize view

- (void)initializeView {
	[self createAllButtons];
	[super initializeView];
}


@end
