//
//  CustomDocument.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "CustomDocument.h"
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// +[UIDocument(UIDocumentInternal) _documentWithContentsOfFileURL:error:]
namespace _UIDocument {
    namespace _documentWithContentsOfFileURL_error {
        UIDocument * (*original)(Class, SEL, id, id *);
        UIDocument *custom(Class self, SEL _cmd, NSURL *fileURL, NSError **error) {
            if ([fileURL.pathExtension isEqualToString:UTTypePNG.preferredFilenameExtension] || [fileURL.pathExtension isEqualToString:UTTypeJPEG.preferredFilenameExtension]) {
                return [[[CustomDocument alloc] initWithFileURL:fileURL] autorelease];
            } else {
                return original(self, _cmd, fileURL, error);
            }
        };
    }
}

@interface UIDocument (Swizzle)
@end
@implementation UIDocument (Swizzle)
+ (void)load {
//    Method method = class_getClassMethod(self, sel_registerName("_documentWithContentsOfFileURL:error:"));
//    using namespace _UIDocument::_documentWithContentsOfFileURL_error;
//    
//    original = (decltype(original))method_getImplementation(method);
//    method_setImplementation(method, (IMP)custom);
}
@end

@interface CustomDocument () {
    UIDocumentState _documentState;
    NSProgress *_progress;
}
@end

@implementation CustomDocument

- (instancetype)initWithFileURL:(NSURL *)url {
    if (self = [super initWithFileURL:url]) {
        _documentState = UIDocumentStateClosed;
    }
    
    return self;
}

- (void)dealloc {
    [_progress release];
    [_data release];
    [super dealloc];
}

- (NSProgress *)progress {
    return _progress;
}

- (UIDocumentState)documentState {
    return _documentState;
}

- (void)openWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [self.fileURL startAccessingSecurityScopedResource];
    
    _progress = [[NSProgress progressWithTotalUnitCount:10] retain];
    _documentState = UIDocumentStateProgressAvailable;
    [NSNotificationCenter.defaultCenter postNotificationName:UIDocumentStateChangedNotification object:self userInfo:nil];
    
    while (_progress.isFinished) {
        [NSThread sleepForTimeInterval:0.1];
        _progress.totalUnitCount += 1;
    }
    
    _data = [[NSData alloc] initWithContentsOfURL:self.fileURL];
    
    _documentState = UIDocumentStateNormal;
    [NSNotificationCenter.defaultCenter postNotificationName:UIDocumentStateChangedNotification object:self userInfo:nil];
    
    completionHandler(YES);
}

@end
