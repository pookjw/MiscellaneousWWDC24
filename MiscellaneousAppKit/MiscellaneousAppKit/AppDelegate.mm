//
//  AppDelegate.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "AppDelegate.h"
#import "RootWindowController.h"

@interface AppDelegate ()
@property (retain, readonly, nonatomic) RootWindowController *rootWindowController;
@end

@implementation AppDelegate
@synthesize rootWindowController = _rootWindowController;

- (void)dealloc {
    [_rootWindowController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.rootWindowController showWindow:self];
}

- (RootWindowController *)rootWindowController {
    if (auto rootWindowController = _rootWindowController) return rootWindowController;
    
    RootWindowController *rootWindowController = [RootWindowController new];
    
    _rootWindowController = [rootWindowController retain];
    return [rootWindowController autorelease];
}

@end
