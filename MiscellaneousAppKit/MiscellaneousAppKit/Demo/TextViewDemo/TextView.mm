//
//  TextView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import "TextView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation TextView

- (NSTextInputContext *)inputContext {
    NSTextInputContext *result = [super inputContext];
    
    if (self.smartReplyEnabled) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(result, sel_registerName("setInputContextHistory:"), [self _makeMailContextHistory]);
    } else {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(result, sel_registerName("setInputContextHistory:"), nil);
    }
    
    return result;
}

- (void)setSmartReplayEnabled:(BOOL)smartReplyEnabled {
    _smartReplyEnabled = smartReplyEnabled;
    [self inputContext];
}

- (id)_makeMailContextHistory {
    NSString *threadIdentifier =  @"28591";
    
    id entry = [objc_lookUpClass("TIMutableInputContextEntry") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setText:"), @"Hello Jinwoo Kim, \nI reach out to invite you to the FOSSASIA Summit 2025, happening from March 13-15 at True Digital Park, Bangkok. This year, we have an exceptional lineup of 170+ speakers, including the founders and maintainers of major open source projects such as Nextcloud, TOR, Debian, VLC, Kubernetes, Grafana, PostgreSQL, TiDB and many more.\nAs you are on our list of open source contributors from Korea, we truly appreciate your dedication to the community. To thank you for your contributions, we’re excited to offer you a complimentary ticket to the FOSSASIA Summit! Claim your ticket here.\nIf you're interested in showcasing your project or open-source contributions, you are welcome to sign-up for a Lightning Talk here https://summit.fossasia.org/lightningtalks\nI look forward to welcoming you at the FOSSASIA Summit!\nBest regards,\nHong Phuc Dang\nEvent Chair\nFOSSASIA Summit 2025\nLinkedIn | GitHub | X");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSenderIdentifier:"), @"office@fossasia.org");
    
    NSDate *timestamp = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond
                                                            value:-10000
                                                           toDate:[NSDate now]
                                                          options:NSCalendarMatchNextTime];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setTimestamp:"), timestamp);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setEntryIdentifier:"), @"45842");
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setPrimaryRecipientIdentifiers:"), [NSSet setWithObject:@"kidjinwoo@me.com"]);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setSecondaryRecipientIdentifiers:"), [NSSet set]);
    
    /*
     entryType = 0 (Mail)
     entryType = 1 (Message)
     */
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(entry, sel_registerName("setEntryType:"), 0);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(entry, sel_registerName("setThreadIdentifier:"), nil);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(entry, sel_registerName("setIsFromMe:"), NO);
    
    NSDictionary<NSString *, NSPersonNameComponents *> *participantsIDtoNamesMap = @{
        @"hp@fossasia.org": ^{
            NSPersonNameComponents *components = [NSPersonNameComponents new];
            components.givenName = @"Jinwoo";
            components.familyName = @"Kim";
            return [components autorelease];
        }(),
        @"kidjinwoo@me.com": ^{
            NSPersonNameComponents *components = [NSPersonNameComponents new];
            components.givenName = @"hp@fossasia.org";
            return [components autorelease];
        }(),
        @"office@fossasia.org": ^{
            NSPersonNameComponents *components = [NSPersonNameComponents new];
            components.givenName = @"Hong";
            components.familyName = @"Dang";
            components.middleName = @"Phuc";
            return [components autorelease];
        }()
    };
    
    id context = reinterpret_cast<id (*)(id, SEL, id, id, id, id, id, id)>(objc_msgSend)([objc_lookUpClass("NSInputContextHistory") alloc], sel_registerName("initWithThreadIdentifier:participantsIDtoNamesMap:firstPersonIDs:primaryRecipients:secondaryRecipients:infoDict:"), threadIdentifier, participantsIDtoNamesMap, [NSSet setWithObject:@"kidjinwoo@me.com"], [NSSet setWithObject:@"hp@fossasia.org"], [NSSet setWithObject:@"hp@fossasia.org"], @{
        @"hasCustomSignature": @NO,
        @"showSmartReplySuggestions": @YES,
        @"subject": @"Replying to you"
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(context, sel_registerName("addEntry:"), entry);
    [entry release];
    
    id rep = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(context, sel_registerName("tiInputContextHistory"));
    BOOL valid = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("validateForSmartReplyGeneration"));
    assert(valid);
    
    if (!valid) {
        NSString *invalidReasonsForSmartReplyGeneration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rep, sel_registerName("invalidReasonsForSmartReplyGeneration"));
        NSLog(@"%@", invalidReasonsForSmartReplyGeneration);
        abort();
    }
    
    return [context autorelease];
}

@end
