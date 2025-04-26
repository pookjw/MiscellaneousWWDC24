//
//  ViewController.mm
//  DeviceActivityReportExtensionObjC
//
//  Created by Jinwoo Kim on 4/26/25.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

/*
 _DeviceActivity_SwiftUI.DeviceActivityReportServiceXPC
 
 <_DeviceActivity_SwiftUI.DeviceActivityReportServiceXPC: 0x1efddd1a0> :
 in _DeviceActivity_SwiftUI.DeviceActivityReportServiceXPC:
     Instance Methods:
         - (void) discoverClientExtensionWithConfiguration:(id)arg1;
         - (void) fetchActivitySegmentWithUserAltDSID:(id)arg1 deviceIdentifier:(id)arg2 segmentInterval:(long)arg3 recordName:(id)arg4;
         - (void) updateClientConfiguration:(id)arg1;
 
 fetchActivitySegmentWithUserAltDSID:deviceIdentifier:segmentInterval:recordName::
 - 001938-05-39d4c048-f19d-47bf-8f3b-c4069d68450e (String)
 - FD96DC8B-28AE-4F29-8B52-BCC030C3F450 (String)
 - 2
 - ???
 
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    UILabel *label = [UILabel new];
    label.backgroundColor = UIColor.systemBackgroundColor;
    label.textColor = UIColor.labelColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    self.view = label;
    [label release];
}

- (void)dealloc{
    [_connection release];
    [super dealloc];
}

- (void)setConnection:(NSXPCConnection *)connection {
    [_connection release];
    _connection = [connection retain];
    
    static_cast<UILabel *>(self.view).text = self.connection.description;
}

@end
