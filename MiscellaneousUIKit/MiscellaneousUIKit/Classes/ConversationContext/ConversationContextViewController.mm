//
//  ConversationContextViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/22/25.
//

#import "ConversationContextViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ConversationContextViewController ()
@end

@implementation ConversationContextViewController

- (void)loadView {
    UITextField *textField = [UITextField new];
    
    //    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    //    assert(articleURL != nil);
    //    NSError * _Nullable error = nil;
    //    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    //    assert(error == nil);
    //    textView.text = text;
    //    [text release];
    
//    UIMessageConversationContext *conversationContext = [UIMessageConversationContext new];
//    UIMailConversationContext *foo = [UIMailConversationContext new];
    
    __kindof UIConversationContext *conversationContext = [self _makeMailConversationContext];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textField.conversationContext = conversationContext;
        [textField.inputDelegate conversationContext:conversationContext didChange:textField];
    });
    
    self.view = textField;
    [textField release];
}

- (UIMessageConversationContext *)_makeMessageConversationContext {
    NSArray<NSString *> *names = @[
        @"John Smith",
        @"Mary Johnson",
        @"Robert Williams",
        @"Patricia Brown",
        @"Michael Jones"
    ];
    
    NSArray<NSString *> *messages = @[
        @"Hi everyone, how are you doing?",
        @"I'm doing well, thanks for asking.",
        @"What are your plans for today?",
        @"I plan to visit the museum.",
        @"That sounds interesting, I'm in!",
        
        @"Should we grab coffee before heading out?",
        @"Yes, that would be great.",
        @"Let's meet at the cafe on 5th street.",
        @"I'll bring my camera.",
        @"See you all there.",
        
        @"The weather is really nice today.",
        @"Indeed, it's perfect for a stroll.",
        @"I love sunny days.",
        @"It makes everything brighter.",
        @"Let's enjoy the outdoors.",
        
        @"Who's up for a movie night later?",
        @"Count me in, I haven't seen a good film in ages.",
        @"I prefer action movies.",
        @"How about a comedy?",
        @"I'm flexible, any suggestions?",
        
        @"How did everyone's day go?",
        @"It was productive and fulfilling.",
        @"I managed to finish my project.",
        @"I enjoyed a quiet afternoon reading.",
        @"Mine was full of surprises.",
        
        @"Has anyone tried that new restaurant downtown?",
        @"Not yet, but it's on my list.",
        @"I went last week; the food was great.",
        @"I'll plan a visit soon.",
        @"Sounds delicious, count me in.",
        
        @"I'm thinking of starting a new hobby.",
        @"That sounds exciting, what hobby?",
        @"Maybe painting or cycling?",
        @"I prefer photography.",
        @"I might try something new too.",
        
        @"Who wants to join me for a run tomorrow?",
        @"I'm in for the run.",
        @"Running is a good idea.",
        @"I'll stretch first, then join.",
        @"Count me in as well.",
        
        @"I'm planning a weekend trip soon.",
        @"That sounds like fun, where to?",
        @"Maybe to the mountains?",
        @"I love mountain scenery.",
        @"I'll bring my hiking gear.",
        
        @"It's been great chatting with you all today.",
        @"Absolutely, it's always refreshing.",
        @"Let's keep in touch.",
        @"Looking forward to our next meetup.",
        @"Have a wonderful evening, everyone!"
    ];
    
    NSMutableArray<UIMessageConversationEntry *> *entries = [[NSMutableArray alloc] initWithCapacity:messages.count];
    [messages enumerateObjectsUsingBlock:^(NSString * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sender = names[idx % names.count];
        
        UIMessageConversationEntry *entry = [UIMessageConversationEntry new];
        entry.text = message;
        entry.senderIdentifier = sender;
        entry.sentDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond
                                                                value:-(messages.count - idx) * 10
                                                               toDate:[NSDate now]
                                                              options:NSCalendarMatchNextTime];
        
        entry.entryIdentifier = [NSUUID UUID].UUIDString;
        entry.dataKind = UIMessageConversationEntryDataKindText;
        entry.wasSentBySelf = [names[0] isEqualToString:sender];
        
        NSMutableArray<NSString *> *primaryRecipientIdentifiers = [names mutableCopy];
        [primaryRecipientIdentifiers removeObject:sender];
        entry.primaryRecipientIdentifiers = [NSSet setWithArray:primaryRecipientIdentifiers];
        [primaryRecipientIdentifiers release];
        
        [entries addObject:entry];
        [entry release];
    }];
    
    UIMessageConversationContext *context = [UIMessageConversationContext new];
    context.threadIdentifier = [NSUUID UUID].UUIDString;
    context.entries = entries;
    [entries release];
    context.selfIdentifiers = [NSSet setWithObject:names[0]];
    context.responsePrimaryRecipientIdentifiers = [NSSet setWithArray:[names subarrayWithRange:NSMakeRange(1, names.count - 1)]];
    
    NSMutableDictionary<NSString *, NSPersonNameComponents *> *participantNameByIdentifier = [NSMutableDictionary new];
    for (NSString *name in names) {
        NSPersonNameComponents *components = [NSPersonNameComponents new];
        components.familyName = [name componentsSeparatedByString:@" "][0];
        components.givenName = [name componentsSeparatedByString:@" "][1];
        participantNameByIdentifier[name] = components;
        [components release];
    }
    context.participantNameByIdentifier = participantNameByIdentifier;
    [participantNameByIdentifier release];
    
    return [context autorelease];
}

- (UIMailConversationContext *)_makeMailConversationContext {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"mail_conversatoins" withExtension:UTTypeJSON.preferredFilenameExtension];
    assert(url != nil);
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    assert(data != nil);
    NSError * error = nil;
    NSArray<NSDictionary<NSString *, NSString *> *> *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingJSON5Allowed error:&error];
    [data release];
    assert(error == nil);
    
    NSMutableSet<NSString *> *addresses = [NSMutableSet new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        [addresses addObject:content[@"address"]];
    }
    NSString *selfAddress = addresses.allObjects.firstObject;
    
    NSMutableSet<NSString *> *addressesWithoutSelfAddress = [addresses mutableCopy];
    [addressesWithoutSelfAddress removeObject:selfAddress];
    
    NSMutableArray<UIMailConversationEntry *> *entries = [NSMutableArray new];
    [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"address"] isEqualToString:selfAddress]) return;
        
        UIMailConversationEntry *entry = [UIMailConversationEntry new];
        entry.kind = UIMailConversationEntryKindPersonal;
        entry.text = obj[@"body"];
        entry.senderIdentifier = obj[@"address"];
        entry.sentDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond
                                                                value:-(json.count - idx) * 10
                                                               toDate:[NSDate now]
                                                              options:NSCalendarMatchNextTime];
        entry.entryIdentifier = [NSUUID UUID].UUIDString;
        
        entry.primaryRecipientIdentifiers = [NSSet setWithObject:selfAddress];
        
        NSMutableSet<NSString *> *responseSecondaryRecipientIdentifiers = [addresses mutableCopy];
        [responseSecondaryRecipientIdentifiers removeObject:obj[@"address"]];
        [responseSecondaryRecipientIdentifiers removeObject:selfAddress];
        entry.responseSecondaryRecipientIdentifiers = responseSecondaryRecipientIdentifiers;
        [responseSecondaryRecipientIdentifiers release];
        
        [entries addObject:entry];
        [entry release];
    }];
    [addresses release];
    
    UIMailConversationContext *context = [UIMailConversationContext new];
    context.entries = entries;
    [entries release];
    context.responseSubject = @"Replying to you";
    context.threadIdentifier = [NSUUID UUID].UUIDString;
    context.selfIdentifiers = [NSSet setWithObject:selfAddress];
    context.responsePrimaryRecipientIdentifiers = addressesWithoutSelfAddress;
    [addressesWithoutSelfAddress release];
    
    NSMutableDictionary<NSString *, NSPersonNameComponents *> *participantNameByIdentifier = [NSMutableDictionary new];
    for (NSDictionary<NSString *, NSString *> *content in json) {
        NSString *name = content[@"name"];
        NSString *address = content[@"address"];
        
        NSPersonNameComponents *components = [NSPersonNameComponents new];
        NSString *familyName = [name componentsSeparatedByString:@" "][0];
        components.familyName = familyName;
        NSString *givenName = [name componentsSeparatedByString:@" "][1];
        components.givenName = givenName;
        participantNameByIdentifier[address] = components;
        [components release];
    }
    context.participantNameByIdentifier = participantNameByIdentifier;
    [participantNameByIdentifier release];
    
    return [context autorelease];
}

@end
