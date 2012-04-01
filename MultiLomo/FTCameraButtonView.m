//
//  FTCameraButtonView.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTCameraButtonView.h"
#import <QuartzCore/QuartzCore.h>


@implementation FTCameraButtonView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]];
		[self.layer setCornerRadius:15];
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	}
	return self;
}


@end
