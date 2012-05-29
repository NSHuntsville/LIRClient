//
// Created by rmiller on 5/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
@protocol JSONHelper
@optional
-(void)indicateSuccessfulAuthorizationForName:(NSString *)userName withToken:(NSString *)tokenID;
-(void)messagePosted:(NSString *)message;
-(void)messagesReceived:(NSArray *)messagesArray;
@end

@interface HSVJSONHelper : NSObject
-(void)getAuthorizationCredentialsForName:(NSString *)userName callingFunction:(id<JSONHelper>)caller;

-(void)sendCommentForLat:(float)userLat 
               longitude:(float)userLong  
                 comment:(NSString *)text
                 forUser:(NSString *)userName 
                 tokenID:(NSString *) tokenID 
         callingFunction:(id<JSONHelper>)caller;

-(void)getMessagesForLat:(float)userLat longitude:(float)userLong  
                  radius:(float)radius  
         callingFunction:(id<JSONHelper>)caller;

@end