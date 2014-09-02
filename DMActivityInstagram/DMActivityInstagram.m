//
//  DMActivityInstagram.m
//  DMActivityInstagram
//
//  Created by Cory Alder on 2012-09-21.
//  Copyright (c) 2012 Cory Alder. All rights reserved.
//

#import "DMActivityInstagram.h"

@implementation DMActivityInstagram

- (NSString *)activityType {
  return @"UIActivityTypePostToInstagram";
}

- (NSString *)activityTitle {
  return @"Instagram";
}

- (UIImage *)activityImage {
  return [UIImage imageNamed:@"instagram.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
  NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
  if (![[UIApplication sharedApplication] canOpenURL:instagramURL])
    return NO;   // no instagram.

  for (UIActivityItemProvider *item in activityItems) {
    if ([item isKindOfClass:[UIImage class]]) {
      if ([self imageIsLargeEnough:(UIImage *)item])
        return YES;       // has image, of sufficient size.
      else
        NSLog(@"DMActivityInstagam: image too small %@", item);
    }
  }
  return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
  for (id item in activityItems) {
    if ([item isKindOfClass:[UIImage class]])
      self.shareImage = item;
    else if ([item isKindOfClass:[NSString class]]) {
      self.shareString = [(self.shareString ? : @"") // concat, with space if already exists.
                          stringByAppendingFormat : @"%@%@", (self.shareString ? @" " : @""), item];
    } else NSLog(@"Unknown item type %@", item);
  }
}

- (void)performActivity {
  NSData   *imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
  NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
  if (![imageData writeToFile:writePath atomically:YES]) {
    // failure
    NSLog(@"image save failed to path %@", writePath);
    [self activityDidFinish:NO];
    return;
  }

  // send it to instagram.
  NSURL *fileURL = [NSURL fileURLWithPath:writePath];
  self.documentController          = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
  self.documentController.delegate = self;
  [self.documentController setUTI:@"com.instagram.exclusivegram"];
  if (self.shareString)
    [self.documentController setAnnotation:@{@"InstagramCaption" : self.shareString}];

  if (self.avc) {
    [self.avc dismissViewControllerAnimated:YES completion:^ {
      if (![self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES])
        NSLog(@"couldn't present document interaction controller");

    }];
  }
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
  [self activityDidFinish:YES];
}

- (BOOL)imageIsLargeEnough:(UIImage *)image {
  CGSize imageSize = [image size];
  return ((imageSize.height * image.scale) >= 612 && (imageSize.width * image.scale) >= 612);
}

@end
