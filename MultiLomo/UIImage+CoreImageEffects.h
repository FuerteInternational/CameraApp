//
//  UIImage+CoreImageEffects.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 31/03/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CoreImageEffects)

- (UIImage *)effect1980Vintage;

- (UIImage *)effectLomo;

- (UIImage *)effectSepia:(CGFloat)intensity;

- (UIImage *)effectShadowHighlight;

- (UIImage *)effectPopArtGreen;

- (UIImage *)effectPopArtBlue;

- (UIImage *)effectPopArtRed;

- (UIImage *)effectPopArtPurple;

- (UIImage *)effectPopArtPink;

- (UIImage *)rotateImage:(CGFloat)degrees;


@end
