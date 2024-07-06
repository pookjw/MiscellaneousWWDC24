//
//  main.m
//  VoluemKeyPad
//
//  Created by Jinwoo Kim on 7/6/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSObject+Foundation_IvarDescription.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"_UIPhysicalButtonInteractionDelegate")]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
