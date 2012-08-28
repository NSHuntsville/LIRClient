//
//  HSVJSONRequestOperation.m
//  LIRCMap
//
//  Created by Robert Miller on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSVJSONRequestOperation.h"

@implementation HSVJSONRequestOperation
/*
 * We need to do this if the server does not return the expected header content-type
 */
+ (NSSet *)acceptableContentTypes;
{
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
}
@end
