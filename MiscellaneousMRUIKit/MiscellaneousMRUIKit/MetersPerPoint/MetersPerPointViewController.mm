//
//  MetersPerPointViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

// https://x.com/_silgen_name/status/1888511510324113831

#import "MetersPerPointViewController.h"
#import "RulerView.h"

@implementation MetersPerPointViewController

- (void)loadView {
    RulerView *view = [RulerView new];
    self.view = view;
    [view release];
}

@end
