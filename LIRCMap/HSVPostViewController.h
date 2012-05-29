//
//  HSVPostViewController.h
//  LIRCMap
//
//  Created by Robert Miller on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSVJSONHelper.h"

@interface HSVPostViewController : UIViewController <UITextViewDelegate, JSONHelper>
@property (strong, nonatomic) NSString * accessToken;
@property (strong, nonatomic) NSString * loginName;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;
//
- (IBAction)postItBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@end
