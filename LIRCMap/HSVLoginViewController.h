//
//  HSVLoginViewController.h
//  LIRCMap
//
//  Created by Robert Miller on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSVJSONHelper.h"

@interface HSVLoginViewController : UIViewController <UITextFieldDelegate, JSONHelper>

@property (weak, nonatomic) IBOutlet UITextField *loginField;
- (IBAction)loginBtn:(id)sender;

@end
