//
//  main.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/31/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

UIKIT_EXTERN int UIApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);
UIKIT_EXTERN NSURL *_restorationPath(NSString *);

int main(int argc, char * argv[]) {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    @autoreleasepool {
        // PUICListCollectionViewLayoutDelegate PUICListCollectionViewDelegate
        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"NACVolumeControllerDelegate")]);
//        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"PUICDictationViewControllerDelegate")]);
    }
    
    int result = UIApplicationMain(argc, argv, @"SPApplication", NSStringFromClass(AppDelegate.class));
    [pool release];
    return result;
}
