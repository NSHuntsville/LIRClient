//
//  HSVViewController.m
//  LIRCMap
//
//  Created by Matt Blackmon on 4/23/12.
//

#import <MapKit/MapKit.h>
#import "HSVViewController.h"
#import "HSVCustomMapOverlayView.h"
#import "AFNetworking.h"

@interface HSVViewController ()
@property(nonatomic, strong) CLLocationManager *coreLocationManager;
@property(nonatomic, strong) CLLocation *lastLocation;
@property(nonatomic, assign) double lastLocationTolerance;

- (BOOL)isOutsideLastLocation:(CLLocation *)location;

@property(nonatomic, strong) MKCircle *overlay;


@end

@implementation HSVViewController
@synthesize mapView;
@synthesize coreLocationManager = _coreLocationManager;
@synthesize lastLocation = _lastLocation;
@synthesize lastLocationTolerance = _lastLocationTolerance;
@synthesize overlay = _overlay;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.coreLocationManager = [[CLLocationManager alloc] init];
        [self.coreLocationManager setDelegate:self];
        [self.coreLocationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.coreLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.coreLocationManager startUpdatingLocation];
        self.lastLocation = nil;
        self.lastLocationTolerance = 0.001;  //in degrees this about 300 feet, depending on distance from equator (thanks wolfram alpha)
    }

    return self;
//To change the template use AppCode | Preferences | File Templates.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapView setShowsUserLocation:YES];
    //JSON initialization
    NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url ] ;
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json" ];
    [httpClient setDefaultHeader:@"Accept" value:@"*/*"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"rmillerx", @"twitter_username",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/users" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"username: %@, access_token: %@", [JSON objectForKey:@"twitter_username"], [JSON objectForKey:@"access_token"]);

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    

}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Map View Delegates

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    HSVCustomMapOverlayView * overlayView = [[HSVCustomMapOverlayView alloc] initWithOverlay:overlay];
    return overlayView;
}


#pragma mark Core Location Delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //check to make sure the location is not stale
    double stale = -180; //3 minutes
    NSTimeInterval freshness = [[newLocation timestamp] timeIntervalSinceNow];
    if (freshness < stale){
        //we don't do stale
        return;
    }
    if ([self isOutsideLastLocation:newLocation]){
        self.lastLocation = newLocation;
        MKCoordinateSpan span;
        span.latitudeDelta = .01;  //this is in degrees
        span.longitudeDelta = .01;

        MKCoordinateRegion region;
        region.center = newLocation.coordinate;
        region.span = span;

        [self.mapView setRegion:region animated:YES];
        [self.mapView regionThatFits:region];

        MKCircle *circle = [MKCircle circleWithCenterCoordinate:newLocation.coordinate radius:300]; //radius is in meters
        [mapView removeOverlay:self.overlay];
        self.overlay = circle;
        [mapView addOverlay:self.overlay];
    }
}

#pragma mark Utility methods
- (BOOL)isOutsideLastLocation:(CLLocation *)location {
    if (nil == self.lastLocation){
        return YES;
    }
    if (self.lastLocationTolerance < fabs(self.lastLocation.coordinate.latitude - location.coordinate.latitude)){
        return YES;
    }
    if (self.lastLocationTolerance < fabs(self.lastLocation.coordinate.longitude - location.coordinate.longitude)){
        return YES;
    }
    return NO;
}


@end
