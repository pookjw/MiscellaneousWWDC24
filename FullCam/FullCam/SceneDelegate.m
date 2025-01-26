//
//  SceneDelegate.m
//  FullCam
//
//  Created by Jinwoo Kim on 1/26/25.
//

#import "SceneDelegate.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#import <Photos/Photos.h>

id (*CAMCaptureCapabilities_original_initWithHostProcess)(id self, SEL _cmd, NSInteger hostProcess);
id CAMCaptureCapabilities_custom_initWithHostProcess(id self, SEL _cmd, NSInteger hostProcess) {
    return CAMCaptureCapabilities_original_initWithHostProcess(self, _cmd, 0);
}

@implementation SceneDelegate

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/CameraUI.framework/CameraUI", RTLD_NOW) != NULL);
    
    {
        Method method = class_getInstanceMethod(objc_lookUpClass("CAMCaptureCapabilities"), sel_registerName("initWithHostProcess:"));
        CAMCaptureCapabilities_original_initWithHostProcess = (typeof(CAMCaptureCapabilities_original_initWithHostProcess))method_getImplementation(method);
        method_setImplementation(method, (IMP)CAMCaptureCapabilities_custom_initWithHostProcess);
    }
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    
    if (status != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            assert(status == PHAuthorizationStatusAuthorized);
            abort(); // Please restart the app
        }];
        return;
    }
    
    UIImagePickerController *imagePickerViewController = [UIImagePickerController new];
    imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerViewController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    window.rootViewController = imagePickerViewController;
    [imagePickerViewController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
