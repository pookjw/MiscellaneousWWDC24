//
//  Helper.h
//  MiscellaneousAppKitHelper
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

NS_ASSUME_NONNULL_BEGIN

class Helper {
public:
    Helper();
    ~Helper();
    void run(void) DISPATCH_NORETURN;
    
    Helper(const Helper&) = delete;
    Helper& operator=(const Helper&) = delete;
private:
    xpc_listener_t _listener;
    
    void handleIncomingMessage(xpc_session_t peer, xpc_object_t message);
    void pong(xpc_session_t peer, xpc_object_t message);
    void registerLoginAgent(xpc_session_t peer, xpc_object_t message);
    
    void copyFile(NSURL *sourceURL, NSURL *destinationURL);
};

NS_ASSUME_NONNULL_END
