//
//  UIImage+CoreImageEffects.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 31/03/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "UIImage+CoreImageEffects.h"


@implementation UIImage (CoreImageEffects)

- (UIImage *)radialGradientMaskForVintageEffect:(CGSize)size withColor:(UIColor *)color inverted:(BOOL)inverted {
	UIGraphicsBeginImageContextWithOptions(size, NO, 1);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGFloat BGLocations[3] = { 0.0, 1.0 };
	
	CGColorSpaceRef BgRGBColorspace = CGColorSpaceCreateDeviceRGB();
	
	const CGFloat *c = CGColorGetComponents(color.CGColor);
    
	CGGradientRef bgRadialGradient;
	
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
		CGFloat BgComponents[8] = { 0, 0, 0 , (inverted ? 1 : 0), c[0], c[0], c[0], (inverted ? 0 : c[3]) };
		bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
	}
	else {
		CGFloat BgComponents[8] = { 0, 0, 0 , (inverted ? 1 : 0), c[0], c[1], c[2], (inverted ? 0 : c[3]) };
		bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
	}
	
    CGPoint startBg = CGPointMake((size.width / 2), (size.height / 2)); 
    CGFloat endRadius= (size.width > size.height) ? size.width : size.height;
	CGFloat randMax = ((endRadius * 20) / 100);
	NSInteger rand = (((arc4random() % (int)randMax) + ((endRadius * 10) / 100)) - ((randMax + ((endRadius * 20) / 100)) / 2));
	endRadius -= randMax;
	startBg.x += rand;
	startBg.y += rand;
	
	CGContextDrawRadialGradient(context, bgRadialGradient, startBg, 0, startBg, endRadius, kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(BgRGBColorspace);
    CGGradientRelease(bgRadialGradient);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)rotateImage:(CGFloat)degrees {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CIStraightenFilter"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat:(M_PI * (degrees) / 180.0)] forKey:@"inputAngle"]; 
	image = [filter outputImage];
	
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}

- (UIImage *)effect1980Vintage {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CIExposureAdjust"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: -0.2f] forKey:@"inputEV"]; 
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CIColorControls"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: 1.1f] forKey:@"inputSaturation"]; // Max: 2
	[filter setValue:[NSNumber numberWithFloat: 0.0f] forKey:@"inputBrightness"]; // Max: 1
	[filter setValue:[NSNumber numberWithFloat: 1.1f] forKey:@"inputContrast"];   // Max: 4
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CISepiaTone"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat:0.4f] forKey:@"inputIntensity"]; 
	image = [filter outputImage];
	
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}

- (UIImage *)effectLomo {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CIExposureAdjust"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: -0.2f] forKey:@"inputEV"]; 
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CIColorControls"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: 1.1f] forKey:@"inputSaturation"]; // Max: 2
	[filter setValue:[NSNumber numberWithFloat: 0.0f] forKey:@"inputBrightness"]; // Max: 1
	[filter setValue:[NSNumber numberWithFloat: 1.2f] forKey:@"inputContrast"];   // Max: 4
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CISepiaTone"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat:0.1f] forKey:@"inputIntensity"]; 
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CITemperatureAndTint"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey]; 
    [filter setValue:[CIVector vectorWithX:600 Y:3000] forKey:@"inputNeutral"]; 
	[filter setValue:[CIVector vectorWithX:600 Y:3000] forKey:@"inputTargetNeutral"]; 
	image = [filter outputImage];
	
	
	image = [CIFilter filterWithName:@"CIToneCurve" keysAndValues:@"inputImage", image, @"inputPoint0", [CIVector vectorWithX:0 Y:0], @"inputPoint1", [CIVector vectorWithX:0.25 Y:0.25], @"inputPoint2", [CIVector vectorWithX:0.5 Y:0.5], @"inputPoint3", [CIVector vectorWithX:0.75 Y:0.75], @"inputPoint4", [CIVector vectorWithX:1 Y:1], nil].outputImage;
	
	
	UIImage *gradient = [self radialGradientMaskForVintageEffect:self.size withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] inverted:YES];
	
	filter = [CIFilter filterWithName:@"CISoftLightBlendMode"];  
    [filter setDefaults];  
    [filter setValue:[CIImage imageWithCGImage:gradient.CGImage] forKey:kCIInputImageKey];  
    [filter setValue:image forKey:@"inputBackgroundImage"];
	image = [filter outputImage];
	
//	filter = [CIFilter filterWithName:@"CISharpenLuminance"];  
//    [filter setDefaults];  
//    [filter setValue:image forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputSharpness"]; 
//	image = [filter outputImage];
	
	gradient = [self radialGradientMaskForVintageEffect:self.size withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.90] inverted:NO];
	
	filter = [CIFilter filterWithName:@"CISourceAtopCompositing"];  
    [filter setDefaults];  
    [filter setValue:[CIImage imageWithCGImage:gradient.CGImage] forKey:kCIInputImageKey];  
    [filter setValue:image forKey:@"inputBackgroundImage"]; 
	image = [filter outputImage];
	
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}



- (UIImage *)effectSepia:(CGFloat)intensity {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CISepiaTone"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"]; 
	image = [filter outputImage];
	
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}

- (UIImage *)effectShadowHighlight {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: 0.8f] forKey:@"inputHighlightAmount"]; 
	[filter setValue:[NSNumber numberWithFloat: 0.4f] forKey:@"inputShadowAmount"]; 
	image = [filter outputImage];
	
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}

- (UIImage *)effectPopArtWithValue:(CGFloat)value {
	CIImage *image = [CIImage imageWithCGImage:self.CGImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	
	CIFilter *filter;
	
	filter = [CIFilter filterWithName:@"CIExposureAdjust"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: -0.2f] forKey:@"inputEV"]; 
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CIColorControls"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat: 1.1f] forKey:@"inputSaturation"]; // Max: 2
	[filter setValue:[NSNumber numberWithFloat: 0.0f] forKey:@"inputBrightness"]; // Max: 1
	[filter setValue:[NSNumber numberWithFloat: 1.2f] forKey:@"inputContrast"];   // Max: 4
	image = [filter outputImage];
	
	filter = [CIFilter filterWithName:@"CISepiaTone"];  
    [filter setDefaults];  
    [filter setValue:image forKey:kCIInputImageKey];  
    [filter setValue:[NSNumber numberWithFloat:0.1f] forKey:@"inputIntensity"]; 
	image = [filter outputImage];
		
	filter = [CIFilter filterWithName:@"CIHueAdjust"];  
    [filter setDefaults];
	[filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputAngle"]; 
	image = [filter outputImage];
		
	CGImageRef cgimg = [context createCGImage:image fromRect:[image extent]];
	UIImage *newImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	
	return newImage;
}

- (UIImage *)effectPopArtRed {
	return [self effectPopArtWithValue:6.2f];
}

- (UIImage *)effectPopArtGreen {
	return [self effectPopArtWithValue:1.5f];
}

- (UIImage *)effectPopArtBlue {
	return [self effectPopArtWithValue:3.8f];
}

- (UIImage *)effectPopArtPurple {
	return [self effectPopArtWithValue:4.8f];
}

- (UIImage *)effectPopArtPink {
	return [self effectPopArtWithValue:5.5f];
}


@end
