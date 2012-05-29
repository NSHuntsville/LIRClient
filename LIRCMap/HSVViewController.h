//
//  HSVViewController.h
//  LIRCMap
//
//  Created by Matt Blackmon on 4/23/12.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HSVJSONHelper.h"

@interface HSVViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, JSONHelper>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString * loginName;
@property (strong, nonatomic) NSString * accessToken;
@end
