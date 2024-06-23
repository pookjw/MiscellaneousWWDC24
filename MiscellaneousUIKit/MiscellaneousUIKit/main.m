//
//  main.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import <UIKit/UIKit.h>
#import "NSObject+Foundation_IvarDescription.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:@protocol(UIInteraction)]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
