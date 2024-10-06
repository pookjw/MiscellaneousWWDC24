//
//  main.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/31/24.
//

#import <UIKit/UIKit.h>
#import <WatchKit/WatchKit.h>
#import "AppDelegate.h"

WKI_EXTERN void spUtils_setRunningExtensionlessWKApp(BOOL);
UIKIT_EXTERN int UIApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);

int main(int argc, char * argv[]) {
    spUtils_setRunningExtensionlessWKApp(YES);
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    @autoreleasepool {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"UIStateRestorationDebugLogging"];
        
        // PUICListCollectionViewLayoutDelegate PUICListCollectionViewDelegate
        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"SPExtensionConnectionDelegate")]);
//        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"PUICDictationViewControllerDelegate")]);
    }
    
    int result = UIApplicationMain(argc, argv, @"SPApplication", NSStringFromClass(AppDelegate.class));
    [pool release];
    return result;
}
