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
@property(nonatomic, strong) HSVJSONHelper *jsonHelper;
- (BOOL)isOutsideLastLocation:(CLLocation *)location;

@property(nonatomic, strong) MKCircle *overlay;


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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
//To change the template use AppCode | Preferences | File Templates.
}


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
        //post a sample message in lieu of a real Message dialog
        // UNCOMMENT FOR EXAMPLE POSTING
        //[[self jsonHelper] sendCommentForLat:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude comment:@"First Post- Woot" forUser:[self loginName] tokenID:[self accessToken] callingFunction:self];
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
/*
 * 
 */
-(void)messagePosted:(NSString *)message {
    if(message) {
        NSLog(@"The message %@ was posted" , message);
    } else {
        NSLog(@"An Error occurred while posting the message");
    }
}
-(void)messagesReceived:(NSArray *)messagesArray {
    if(messagesArray) {
        NSLog(@"Received messages for this location");
        NSLog(@"%@", messagesArray);
    }
}

@end
