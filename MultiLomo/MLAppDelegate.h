//
//  MLAppDelegate.h
//  MultiLomo
//
//  Created by Ondrej Rafaj on 26/03/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLHomeViewController;

@interface MLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MLHomeViewController *viewController;

@end
