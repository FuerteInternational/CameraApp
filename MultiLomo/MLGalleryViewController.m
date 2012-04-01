//
//  MLGalleryViewController.m
//  MultiLomo
//
//  Created by Ondrej Rafaj on 01/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "MLGalleryViewController.h"

@interface MLGalleryViewController ()

@end

@implementation MLGalleryViewController

- (void)createToolbar {
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (460 - 44), 320, 44)];
	[toolbar setTintColor:[UIColor grayColor]];
	[self.view addSubview:toolbar];
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixedSpace setWidth:4];
	
	toolbarGalleryButton = [[MLGalleryButtonView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
	UIBarButtonItem *gb = [[UIBarButtonItem alloc] initWithCustomView:toolbarGalleryButton];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[toolbar setItems:[NSArray arrayWithObjects:fixedSpace, gb, flexibleSpace, nil] animated:YES];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
