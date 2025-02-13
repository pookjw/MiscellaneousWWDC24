//
//  Helper.mm
//  MiscellaneousAppKitHelper
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import "Helper.h"
#include <sys/clonefile.h>

Helper::Helper() {
    xpc_rich_error_t error = NULL;
    _listener = xpc_listener_create("com.pookjw.MiscellaneousAppKit.Helper",
                                    NULL,
                                    XPC_LISTENER_CREATE_INACTIVE,
                                    ^(xpc_session_t  _Nonnull peer) {
        xpc_session_set_incoming_message_handler(peer, ^(xpc_object_t  _Nonnull message) {
            handleIncomingMessage(peer, message);
        });
    },
                                    &error);
    
    if (error != NULL) {
        char *description = xpc_rich_error_copy_description(error);
        NSLog(@"%s", description);
        free(description);
        abort();
    }
}

Helper::~Helper() {
    xpc_listener_cancel(_listener);
    [_listener release];
}

void Helper::run() {
    xpc_rich_error_t error = NULL;
    xpc_listener_activate(_listener, &error);
    
    if (error != NULL) {
        char *description = xpc_rich_error_copy_description(error);
        NSLog(@"%s", description);
        free(description);
        abort();
    }
    
    dispatch_main();
}


void Helper::handleIncomingMessage(xpc_session_t peer, xpc_object_t message) {
    const char *action = xpc_dictionary_get_string(message, "action");
    
    if (strcmp(action, "ping") == 0) {
        pong(peer, message);
    } else if (strcmp(action, "registerLoginAgent") == 0) {
        registerLoginAgent(peer, message);
    } else {
        abort();
    }
}

void Helper::pong(xpc_session_t peer, xpc_object_t message) {
    xpc_object_t reply = xpc_dictionary_create_reply(message);
    xpc_dictionary_set_string(reply, "result", "pong");
    
    xpc_rich_error_t _Nullable error = xpc_session_send_message(peer, reply);
    xpc_release(reply);
    
    if (error != NULL) {
        char *description = xpc_rich_error_copy_description(error);
        NSLog(@"%s", description);
        free(description);
        abort();
    }
}

void Helper::registerLoginAgent(xpc_session_t peer, xpc_object_t message) {
    NSString *plistPath = [[NSString alloc] initWithCString:xpc_dictionary_get_string(message, "plistPath") encoding:NSUTF8StringEncoding];
    NSString *privilegedHelperToolsPath = [[NSString alloc] initWithCString:xpc_dictionary_get_string(message, "privilegedHelperToolsPath") encoding:NSUTF8StringEncoding];
    
    NSURL *plistURL = [NSURL fileURLWithPath:plistPath];
    [plistPath release];
    
    NSURL *privilegedHelperToolsURL = [NSURL fileURLWithPath:privilegedHelperToolsPath];
    [privilegedHelperToolsPath release];
    
    assert(plistURL.lastPathComponent.length > 0);
    assert(privilegedHelperToolsURL.lastPathComponent.length > 0);
    
    copyFile(privilegedHelperToolsURL, [[NSURL fileURLWithPath:@"/Library/PrivilegedHelperTools"] URLByAppendingPathComponent:privilegedHelperToolsURL.lastPathComponent]);
    copyFile(plistURL, [[NSURL fileURLWithPath:@"/Library/LaunchAgents"] URLByAppendingPathComponent:plistURL.lastPathComponent]);
    
    xpc_object_t reply = xpc_dictionary_create_reply(message);
    xpc_dictionary_set_string(reply, "result", "OK");
    
    xpc_rich_error_t _Nullable error = xpc_session_send_message(peer, reply);
    xpc_release(reply);
    
    if (error != NULL) {
        char *description = xpc_rich_error_copy_description(error);
        NSLog(@"%s", description);
        free(description);
        abort();
    }
}

void Helper::copyFile(NSURL *sourceURL, NSURL *destinationURL) {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    if ([fileManager fileExistsAtPath:destinationURL.path]) {
        NSError * _Nullable error = nil;
        [fileManager removeItemAtURL:destinationURL error:&error];
        assert(error == nil);
    }
    
    int result = clonefile([sourceURL.path cStringUsingEncoding:NSUTF8StringEncoding], [destinationURL.path cStringUsingEncoding:NSUTF8StringEncoding], 0);
    if (result == 0) return;
    
    NSError * _Nullable error = nil;
    [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
    assert(error == nil);
}
