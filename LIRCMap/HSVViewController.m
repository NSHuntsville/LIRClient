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
#import "HSVPostViewController.h"

@interface HSVViewController ()
@property(nonatomic, strong) CLLocationManager *coreLocationManager;
@property(nonatomic, strong) CLLocation *lastLocation;
@property(nonatomic, strong) MKCircle *overlay;
@property(nonatomic, assign) double lastLocationTolerance;
@property(nonatomic, strong) HSVJSONHelper *jsonHelper;

- (BOOL)isOutsideLastLocation:(CLLocation *)location;

@end

@implementation HSVViewController
@synthesize mapView;
@synthesize coreLocationManager = _coreLocationManager;
@synthesize lastLocation = _lastLocation;
@synthesize lastLocationTolerance = _lastLocationTolerance;
@synthesize overlay = _overlay;
@synthesize loginName = _loginName;
@synthesize accessToken = _accessToken;
@synthesize jsonHelper = _jsonHelper;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (self) {
        self.coreLocationManager = [[CLLocationManager alloc] init];
        [self.coreLocationManager setDelegate:self];
        [self.coreLocationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.coreLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.coreLocationManager startUpdatingLocation];
        self.lastLocation = nil;
        self.lastLocationTolerance = 0.001;  //in degrees this about 300 feet, depending on distance from equator (thanks wolfram alpha)
    }
    [self.mapView setShowsUserLocation:YES];
    [self setJsonHelper:[[HSVJSONHelper alloc] init]];
    NSLog(@"HSVViewController- Username: %@  Acccess Token: %@",[self loginName], [self accessToken] );
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PostView"]) {
        HSVPostViewController *postVC = [segue destinationViewController];  
        postVC.loginName = [self loginName];
        postVC.accessToken = [self accessToken];
        postVC.latitude = self.lastLocation.coordinate.latitude;
        postVC.longitude = self.lastLocation.coordinate.longitude;        
    }
}
- (IBAction)postBtn:(id)sender {
    [self performSegueWithIdentifier:@"PostView" sender:self];
}
@end
