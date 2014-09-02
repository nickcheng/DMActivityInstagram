//
//  DMActivityInstagram.h
//  DMActivityInstagram
//
//  Created by Cory Alder on 2012-09-21.
//  Copyright (c) 2012 Cory Alder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMActivityInstagram : UIActivity <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
@property (readwrite) BOOL includeURL;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, strong) UIActivityViewController *avc;
@property (nonatomic, strong) UIView *view;

@end
