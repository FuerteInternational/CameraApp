//
//  FTCameraView.m
//  PhotoStrip
//
//  Created by Ondrej Rafaj on 30/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import "FTCameraView.h"
#import "UIImage+CoreImageEffects.h"


@implementation FTCameraView

@synthesize captureSession = _captureSession;
@synthesize customLayer = _customLayer;
@synthesize delegate = _delegate;
@synthesize orientationDelegate = _orientationDelegate;

#pragma mark Initialization

- (void)initializeView {
	self.customLayer = nil;
	
	[self setBackgroundColor:[UIColor blackColor]];
	
	[[UIAccelerometer sharedAccelerometer] setDelegate:self]; 
}

#pragma mark Accelerometer delegate method

- (void)orientationChanged {
	if ([_orientationDelegate respondsToSelector:@selector(cameraView:didChangeOrientation:)]) {
		[_orientationDelegate cameraView:self didChangeOrientation:deviceOrientation];
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration { 
	float xx = -[acceleration x]; 
	float yy = [acceleration y]; 
	float angle = atan2(yy, xx); 
	
	if(angle >= -2.25 && angle <= -0.25) {
		if(deviceOrientation != UIDeviceOrientationPortrait) {
			deviceOrientation = UIDeviceOrientationPortrait;
			[self orientationChanged];
		}
	}
	else if(angle >= -1.75 && angle <= 0.75) {
		if(deviceOrientation != UIDeviceOrientationLandscapeRight) {
			deviceOrientation = UIDeviceOrientationLandscapeRight;
			[self orientationChanged];
		}
	}
	else if(angle >= 0.75 && angle <= 2.25) {
		if(deviceOrientation != UIDeviceOrientationPortraitUpsideDown) {
			deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
			[self orientationChanged];
		}
	}
	else if(angle <= -2.25 || angle >= 2.25) {
		if(deviceOrientation != UIDeviceOrientationLandscapeLeft) {
			deviceOrientation = UIDeviceOrientationLandscapeLeft;
			[self orientationChanged];
		}
	}
} 

#pragma mark Image capture

- (void)initCapture {
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 
	
	//captureOutput.minFrameDuration = CMTimeMake(1, 10);
	
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[captureOutput setVideoSettings:videoSettings]; 
	
	self.captureSession = [[AVCaptureSession alloc] init];
	[_captureSession addInput:captureInput];
	[_captureSession addOutput:captureOutput];
    /*We use medium quality, ont the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    [_captureSession setSessionPreset:AVCaptureSessionPresetMedium];
	
	self.customLayer = [CALayer layer];
	self.customLayer.frame = self.bounds;
	self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, (M_PI / 2.0f), 0, 0, 1);
	self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
	[self.layer addSublayer:self.customLayer];

	[_captureSession startRunning];
	
}

#pragma mRequesting image

- (void)captureImageAsynchronously {
	capturingImage = YES;
	if (!_delegate) NSLog(@"No delegate is assined, capture image will not work!");
}

#pragma mark AVCaptureSession delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connetion { 
	@autoreleasepool {
		
		CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
		
		CIImage *image = [CIImage imageWithCVPixelBuffer:imageBuffer];
		CIContext *context = [CIContext contextWithOptions:nil];
		
//		CIFilter *filter;
//		filter = [CIFilter filterWithName:@"CIExposureAdjust"];  
//		[filter setDefaults];  
//		[filter setValue:image forKey:kCIInputImageKey];  
//		[filter setValue:[NSNumber numberWithFloat: -0.2f] forKey:@"inputEV"]; 
//		image = [filter outputImage];
		
		CGImageRef newImage = [context createCGImage:image fromRect:[image extent]];
		[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (__bridge id)newImage waitUntilDone:YES];
		
		@synchronized(self) {
			if (capturingImage) {
				capturingImage = NO;
				if ([_delegate respondsToSelector:@selector(cameraView:didCaptureImage:)]) {
					CGAffineTransform t;
					if (deviceOrientation == UIDeviceOrientationPortrait) {
						t = CGAffineTransformMakeRotation(-M_PI / 2);
					} 
					else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
						t = CGAffineTransformMakeRotation(M_PI / 2);
					} 
					else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
						t = CGAffineTransformMakeRotation(M_PI);
					} 
					else {
						t = CGAffineTransformMakeRotation(0);
					} 
					
					image = [image imageByApplyingTransform:t];
					CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
					UIImage *ni = [UIImage imageWithCGImage:cgimg];
					[_delegate cameraView:self didCaptureImage:ni];
					CGImageRelease(cgimg);
				}
			}
		}
		CGImageRelease(newImage);
		CVPixelBufferUnlockBaseAddress(imageBuffer,0);		
	} 
}
	

@end
