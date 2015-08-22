//
//  ViewController.h
//  37.38 MapKit
//
//  Created by Admin on 20.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class NVDetailInfoViewController;
@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelStudentsIn5km;
@property (weak, nonatomic) IBOutlet UILabel *labelStudentsIn10km;
@property (weak, nonatomic) IBOutlet UILabel *labelStudentsIn15km;
@property (assign,nonatomic) BOOL isButtonForAddRoutesPushed;
@property (assign,nonatomic) NSInteger radiusOfSmallArea;
@property (assign,nonatomic) NSInteger radiusOfMiddleArea;
@property (assign,nonatomic) NSInteger radiusOfBigArea;
@property (strong,nonatomic) NSMutableArray *arrayOfStudents;
@property (strong,nonatomic) UIPopoverController* popover;
@property (strong,nonatomic) NSDictionary *dictionaryWithAddress;
@property (strong,nonatomic) MKCircle* currentCircle;
@property (strong,nonatomic) NSMutableArray* arrayOfRoutesOverlays;
//for autoupdate geo
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;


@end

