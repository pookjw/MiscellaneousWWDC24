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
 - 766767600.0 (String)
 - "v24@?0@"NSData"8@"NSError"16"
 
 (lldb) po [NSJSONSerialization JSONObjectWithData:(id)$x1 options:0 error:0x0]
 {
     categoryActivities =     (
                 {
             applicationActivities =             (
                                 {
                     bundleIdentifier = "ph.telegra.Telegraph";
                     isTrusted = 1;
                     localizedDisplayName = Telegram;
                     numberOfNotifications = 0;
                     numberOfPickups = 0;
                     token =                     {
                         data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxFou9Nv9oTdFRp7JYplSVsh0T2ObvUrJgwlVYPlD6oMVU/Y/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwP3l8j/f9ptGtvs4JTohk7A=";
                     };
                     totalActivityDuration = "233.386332988739";
                 }
             );
             identifier = DH1002;
             token =             {
                 data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73lCSzVuUEbut8cBIVWzyDpTBEi8blTotiIQEpnJ/xwRFoiyjKZJO10R2MYearMK4kmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwJPq7trNSB3CY1HOU/hvXYQ=";
             };
             totalActivityDuration = "233.386332988739";
             webDomainActivities =             (
             );
         }
     );
     dateInterval =     {
         duration = 604800;
         start = 766767600;
     };
     firstPickup = "767277679.6740021";
     longestActivity =     {
         duration = "225.5522739887238";
         start = "767325236.899824";
     };
     recordSystemFields = "YnBsaXN0MDDUAQIDBAUGB2JYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlct8QLQgJCgsMDQ4PEBESExQVFhcYGRobHB0eHyAhIiMkJSYnKCkqKywtLi8wMTIzNDU2NTg1NTY8NTU1NjY1NTU2Rkc1NTVLNU01TzU2NTU1NTZXWDY1NjVdXjU2NV8QFlRvbWJzdG9uZWRQdWJsaWNLZXlJRHNfEBlIYXNVcGRhdGVkUGFyZW50UmVmZXJlbmNlXxATQ2hhaW5Qcm90ZWN0aW9uRGF0YV1Lbm93blRvU2VydmVyXxARRGlzcGxheWVkSG9zdG5hbWVZQmFzZVRva2VuXxAQV2FudHNDaGFpblBDU0tleVtSZWNvcmRDdGltZVpSb3V0aW5nS2V5XxASUHJvdGVjdGlvbkRhdGFFdGFnXkV4cGlyYXRpb25EYXRlXxAZTWVyZ2VhYmxlVmFsdWVEZWx0YVJlY29yZF8QGk5lZWRzUm9sbEFuZENvdW50ZXJTaWduS2V5XxAmUHJldmlvdXNQcm90ZWN0aW9uRGF0YUV0YWdGcm9tVW5pdFRlc3RfEBJDb25mbGljdExvc2VyRXRhZ3NfEBpQcmV2aW91c1Byb3RlY3Rpb25EYXRhRXRhZ18QFEhhc1VwZGF0ZWRFeHBpcmF0aW9uWlJlY29yZFR5cGVfEBNDcmVhdG9yVXNlclJlY29yZElEXxAPUGFyZW50UmVmZXJlbmNlWVNoYXJlRXRhZ1hQQ1NLZXlJRFxab25laXNoS2V5SURfECBNdXRhYmxlRW5jcnlwdGVkUHVibGljU2hhcmluZ0tleVRFVGFnXxAWUHJldmlvdXNTaGFyZVJlZmVyZW5jZV8QEE1vZGlmaWVkQnlEZXZpY2VeUHJvdGVjdGlvbkRhdGFfEBFVc2VMaWdodHdlaWdodFBDU15TaGFyZVJlZmVyZW5jZV8QEVVwZGF0ZWRFeHBpcmF0aW9uU1VSTF8QFkNoYWluUGFyZW50UHVibGljS2V5SURXRXhwaXJlZF8QGExhc3RNb2RpZmllZFVzZXJSZWNvcmRJRFtSZWNvcmRNdGltZV8QFVdhbnRzUHVibGljU2hhcmluZ0tleV8QFlpvbmVQcm90ZWN0aW9uRGF0YUV0YWdZV2FzQ2FjaGVkXxAPQ2hhaW5Qcml2YXRlS2V5WlBlcm1pc3Npb25YUmVjb3JkSURcQWxsUENTS2V5SURzXxAYSGFzVXBkYXRlZFNoYXJlUmVmZXJlbmNlXxAXUHJldmlvdXNQYXJlbnRSZWZlcmVuY2WAAAiAAAmAAIAACIAJgACAAIAACAiAAIAAgAAIgAGADIAAgACAAIASgACAEYAAgBCAAAiAAIAAgACAAAiAD4ALCIAACIAAEAGAAoAACIAArxATY2RlbG13eHmAhIiLjpKXmJydnlUkbnVsbF8QD0FjdGl2aXR5U2VnbWVudNNmZ2hpamtWJGNsYXNzWlJlY29yZE5hbWVWWm9uZUlEgAiAA4AEWzc2Njc2NzYwMC4w1W5vcHFmcjV0dXZfEBBkYXRhYmFzZVNjb3BlS2V5XxARYW5vbnltb3VzQ0tVc2VySURZb3duZXJOYW1lWFpvbmVOYW1lEACAAIAGgAWAB18QKzlDMUJDRjAyLThDNjUtNEIwNS1CNjEzLURCMjg4MTU5MkFBRV9XZWVrbHlfEBBfX2RlZmF1bHRPd25lcl9f0np7fH1aJGNsYXNzbmFtZVgkY2xhc3Nlc15DS1JlY29yZFpvbmVJRKJ+f15DS1JlY29yZFpvbmVJRFhOU09iamVjdNJ6e4GCWkNLUmVjb3JkSUSig39aQ0tSZWNvcmRJRNKFZoaHV05TLnRpbWUjQcbd3TpcKPaACtJ6e4mKVk5TRGF0ZaKJf9KFZoyHI0HG3miV7jU/gArTZmdoaXSRgAiABoAN1W5vcHFmcjV0lXaAAIAGgA6AB1xfZGVmYXVsdFpvbmXTZmdoaXSRgAiABoANXxAPUG90YXRvLWlQYWQgUHJvWG05d3M2NTZwRBmHlJEACAARABoAJAApADIANwBJAKYAvwDbAPEA/wETAR0BMAE8AUcBXAFrAYcBpAHNAeIB/wIWAiECNwJJAlMCXAJpAowCkQKqAr0CzALgAu8DAwMHAyADKANDA08DZwOAA4oDnAOnA7ADvQPYA/ID9AP1A/cD+AP6A/wD/QP/BAEEAwQFBAYEBwQJBAsEDQQOBBAEEgQUBBYEGAQaBBwEHgQgBCIEJAQlBCcEKQQrBC0ELgQwBDIEMwQ1BDYEOAQ6BDwEPgQ/BEEEVwRdBG8EdgR9BIgEjwSRBJMElQShBKwEvwTTBN0E5gToBOoE7ATuBPAFHgUxBTYFQQVKBVkFXAVrBXQFeQWEBYcFkgWXBZ8FqAWqBa8FtgW5Bb4FxwXJBdAF0gXUBdYF4QXjBeUF5wXpBfYF/QX/BgEGAwYVBh4AAAAAAAACAQAAAAAAAACfAAAAAAAAAAAAAAAAAAAGIw==";
     recordZoneName = "9C1BCF02-8C65-4B05-B613-DB2881592AAE_Weekly";
     totalActivityDuration = "659.4420080184937";
     totalPickupsWithoutApplicationActivity = 0;
 }
 
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
