//
// Created by rmiller on 5/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HSVJSONHelper.h"
#import "AFNetworking.h"

#define kSERVICE_URL  @"http://localhost:3000"

@implementation HSVJSONHelper 
-(void)getAuthorizationCredentialsForName:(NSString *)userName 
                          callingFunction:(id<JSONHelper>)caller {
    //JSON initialization    
    NSURL *url = [[NSURL alloc] initWithString:kSERVICE_URL ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url ] ;
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json" ];
    [httpClient setDefaultHeader:@"Accept" value:@"*/*"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
            userName, @"twitter_username",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/users/auth" parameters:params];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"HSVJSONHelper Username: %@, access_token: %@", [JSON objectForKey:@"twitter_username"], [JSON objectForKey:@"access_token"]);
        [caller indicateSuccessfulAuthorizationForName:userName withToken:[JSON objectForKey:@"access_token"]];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    [operation start];
}
/*
 *Post comments for a given lat/long 
 */
-(void)sendCommentForLat:(float)userLat 
               longitude:(float)userLong  
                 comment:(NSString *)text
                 forUser:(NSString *)userName 
                 tokenID:(NSString *) tokenID 
         callingFunction:(id<JSONHelper>)caller {
    
    NSURL *url = [[NSURL alloc] initWithString:kSERVICE_URL ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url ] ;
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json" ];
    [httpClient setDefaultHeader:@"Accept" value:@"*/*"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userName, @"twitter_username",
                            tokenID, @"access_token",
                            [NSNumber numberWithFloat:userLat ], @"lat",
                            [NSNumber numberWithFloat:userLong], @"lng",
                            text,@"text",                            
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/messages" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"HSVJSONHelper Message created: %@", [JSON objectForKey:@"text"]);
        [caller messagePosted:[JSON objectForKey:@"text"]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    [operation start];
    
    
}
/*
 * This method pulls messages for a given location within a given radius
 #
 */
-(void)getMessagesForLat:(float)userLat longitude:(float)userLong  radius:(float)radius  
                                 callingFunction:(id<JSONHelper>)caller {
    //
    NSURL *url = [[NSURL alloc] initWithString:kSERVICE_URL ];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url ] ;
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json" ];
    [httpClient setDefaultHeader:@"Accept" value:@"*/*"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:userLat ], @"lat",
                            [NSNumber numberWithFloat:userLong], @"lng",
                            [NSNumber numberWithFloat:radius],   @"rad",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/messages" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([JSON containsValueForKey:@"text"]) {
            NSLog(@"HSVJSONHelper Latitude: %f, longitude: %f  messages %@", userLat, userLong, [JSON containsValueForKey:@"text"] );
        //callback to our caller    
            [caller messagePosted:[JSON objectForKey:@"text"]];  
        } else {
            NSLog(@"Getting messages for this location did not return any messages");
        }
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    [operation start];
    
}
@end