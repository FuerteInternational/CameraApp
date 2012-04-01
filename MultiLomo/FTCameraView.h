//
//  FTCameraView.h
//  PhotoStrip
//
//  Created by Ondrej Rafaj on 30/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>


@class FTCameraView;

@protocol FTCameraViewDelegate <NSObject>

- (void)cameraView:(FTCameraView *)view didCaptureImage:(UIImage *)image;

@end

@protocol FTCameraViewOrientationDelegate <NSObject>

- (void)cameraView:(FTCameraView *)view didChangeOrientation:(UIDeviceOrientation)orientation;

@end


@interface FTCameraView : FTView <AVCaptureVideoDataOutputSampleBufferDelegate, UIAccelerometerDelegate> {
	
	BOOL capturingImage;
	
	UIDeviceOrientation deviceOrientation;
	
	//CIImage *ciimg;
	
}


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) CALayer *customLayer;
@property (nonatomic, assign) id <FTCameraViewDelegate> delegate;
@property (nonatomic, assign) id <FTCameraViewOrientationDelegate> orientationDelegate;


- (void)captureImageAsynchronously;

- (void)initCapture;


@end
