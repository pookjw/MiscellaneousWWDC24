//
//  IntelligenceSystemNoiseViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

#import "IntelligenceSystemNoiseViewController.h"
#import <UIKitPrivate/UIKitPrivate.h>

@implementation IntelligenceSystemNoiseViewController

- (void)loadView {
    _UIIntelligenceSystemNoiseView *sourceView = [[_UIIntelligenceSystemNoiseView alloc] initWithFrame:CGRectNull preferringAudioReactivity:YES];
    self.view = sourceView;
    [sourceView release];
}

@end
