//
//  HSVViewController.h
//  LIRCMap
//
//  Created by Matt Blackmon on 4/23/12.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HSVViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
