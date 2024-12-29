//
//  IntentHandler.mm
//  MiscellaneousWWDC24_IntentsExtension
//
//  Created by Jinwoo Kim on 12/29/24.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <INPlayMediaIntentHandling, INSearchForMessagesIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    return self;
}

- (void)handlePlayMedia:(INPlayMediaIntent *)intent completion:(void (^)(INPlayMediaIntentResponse * _Nonnull))completion {
    INPlayMediaIntentResponse *response = [[INPlayMediaIntentResponse alloc] initWithCode:INPlayMediaIntentResponseCodeReady userActivity:nil];
    completion(response);
    [response release];
}

- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse * _Nonnull))completion {
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"Hello!"];
    
    INSearchForMessagesIntentResponse *response = [[INSearchForMessagesIntentResponse alloc] initWithCode:INSearchForMessagesIntentResponseCodeSuccess userActivity:userActivity];
    [userActivity release];
    
    completion(response);
    [response release];
}

@end
