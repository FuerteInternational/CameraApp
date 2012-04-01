//
//  MLButtonsView.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import "FTAutoLineView.h"
#import "FTCameraButtonView.h"


@interface MLButtonsView : FTView {
	
	BOOL isLandscape;
	
	FTAutoLineView *autoLineView;
	
}

@property (nonatomic, strong) FTCameraButtonView *buttonFlash;
@property (nonatomic, strong) FTCameraButtonView *buttonOptions;
@property (nonatomic, strong) FTCameraButtonView *buttonCamera;

- (void)layoutForLandscape:(BOOL)landscape;


@end
