//
//  ViewController.m
//  37.38 MapKit
//
//  Created by Admin on 20.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "NVStudent.h"
#import "NVDetailInfoViewController.h"
#import "NVPlaceForMeeting.h"
//#import <MapKit/MapKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation=YES;
    //----
    
    //initializing
    self.isButtonForAddRoutesPushed=NO;
    self.arrayOfRoutesOverlays=[NSMutableArray new];
    self.arrayOfStudentsAlreadyOnMap=[NSMutableArray new];
    self.radiusOfSmallArea=5000;
    self.radiusOfMiddleArea=10000;
    self.radiusOfBigArea=15000;
    //----
    CLLocationCoordinate2D spbCoordinate=CLLocationCoordinate2DMake(60, 30.2);
    MKCoordinateRegion initialRegion=MKCoordinateRegionMakeWithDistance(spbCoordinate, 100000, 100000);
    self.mapView.region=initialRegion;
    //[self.mapView setRegion:initialRegion animated:YES];
    
    
    
    self.arrayOfStudents=[NSMutableArray new];
    for (NSInteger i=0; i<50; i++) {
        NVStudent* student=[[NVStudent alloc]initWithProperties];
        student.title=[NSString stringWithFormat:@"%@ %@",student.firstname, student.lastname];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        student.subtitle=[formatter stringFromDate:student.dateOfBirth];
        [self.arrayOfStudents addObject:student];
    }
    UIBarButtonItem* buttonAddRoutes=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay                                                                                    target:self                                                                                    action:@selector(actionAddRoutes:)];
    
    UIBarButtonItem* buttonAddStudents=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                                                                                    target:self                                                                                    action:@selector(actionAddStudents:)];
    
    UIBarButtonItem* buttonShowAllStudents=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(actionShowAllStudents:)];
    self.navigationItem.rightBarButtonItems=@[buttonAddStudents,buttonShowAllStudents,buttonAddRoutes ];
    
    //double tap gesture recognizer
    UILongPressGestureRecognizer* longTapGestureRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(actionlongTapGestureRecognizer:)];
    //doubleTapGestureRecognizer.numberOfTapsRequired=0;
    longTapGestureRecognizer.numberOfTouchesRequired=1;
    [self.mapView addGestureRecognizer:longTapGestureRecognizer];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}
#pragma mark - actions
- (void) actionlongTapGestureRecognizer:(UILongPressGestureRecognizer*) sender{
    if (self.currentCircle) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
       //NSLog(@"%@",NSStringFromCGPoint( [sender locationInView:self.mapView]) );
        NVPlaceForMeeting* place=[NVPlaceForMeeting currentPlaceForMeeting];
        CLLocationCoordinate2D tapPoint=[self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        place.coordinate=tapPoint;
       [self.mapView addAnnotation:place];
        
        if (self.currentCircle) {
            [self.mapView removeOverlays:self.mapView.overlays];
        }
        //draw 3 circles
        [self circleOverlayForMeetingPlace:tapPoint];
        [self calculateNumberOfStudentsInArea:tapPoint];
        
    }
    
}
- (void) actionAddRoutes:(UIBarButtonItem*) sender {
    //on-off the routes on map
    self.isButtonForAddRoutesPushed=!self.isButtonForAddRoutesPushed;
    if (!self.isButtonForAddRoutesPushed) {
        for (NSMutableArray* obj in self.arrayOfRoutesOverlays){
            [self.mapView removeOverlays:obj];
        }
    } else {
        [self calculateRoutesByButton:YES];

    }
    
}
- (void) actionAddStudents:(UIBarButtonItem*) sender {
    [self.mapView addAnnotations:self.arrayOfStudents];
    //[self.mapView showAnnotations:self.arrayOfStudents animated:YES];
}
- (void) actionShowAllStudents:(UIBarButtonItem*) sender {
    
    MKMapRect zoomRect=MKMapRectNull;
    for (NVStudent* obj in self.arrayOfStudents) {
        MKMapPoint objCoordinate=MKMapPointForCoordinate(obj.coordinate);
        NSInteger widthOfView=20000;
        MKMapRect objRect=MKMapRectMake(objCoordinate.x-widthOfView/2, objCoordinate.y-widthOfView/2, 2*widthOfView, 2*widthOfView);
        zoomRect=MKMapRectUnion(zoomRect, objRect);
    }
    zoomRect=[self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    //[self.mapView addAnnotations:self.arrayOfStudents];
    //[self.mapView showAnnotations:self.arrayOfStudents animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.location=locations.lastObject;
}
#pragma mark -MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[NVStudent class]]){
        NVStudent <MKAnnotation>*student=annotation;
        
        static NSString* identifierStudent=@"identifierStudent";
        MKAnnotationView *view=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifierStudent];
        if (!view) {
            view=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifierStudent];
            view.canShowCallout=YES;
            UIButton *button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //view.draggable=YES;
            view.rightCalloutAccessoryView=button;
            //view.image=[UIImage imageNamed:@"woman.jpg"];
            if (student.isMan) {
                view.image=[UIImage imageNamed:@"man.jpg"];
            } else {
                view.image=[UIImage imageNamed:@"woman1.jpg"];
            }
        } else {
            view.annotation=annotation;
        }
        
        return view;
        
    } else if ([annotation isKindOfClass:[NVPlaceForMeeting class]]) {
        static NSString* identifierPlaceForMeeting=@"identifierPlaceForMeeting";
        MKAnnotationView *view=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifierPlaceForMeeting];
        if (!view) {
            view=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifierPlaceForMeeting];
            view.image=/*[UIImage imageNamed:@"man.jpg"];*///[UIImage imageWithContentsOfFile:@"/Users/admin/Desktop/XCodeProjects/37.38 MapKit/Rammstein.png"];
            [UIImage imageNamed:@"Rammstein.png"];
            view.draggable=YES;
        }else {
            view.annotation=annotation;
        }
        
        return view;
    } else {
        return nil;
    }
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    //MKCircle* circle=[MKCircle circleWithCenterCoordinate:[overlay coordinate] radius:5000];
    //MKCircleRenderer* renderer=[[MKCircleRenderer alloc]initWithCircle:circle];
    //MKPolylineRenderer* renderer=[[MKPolylineRenderer alloc]initWithPolyline:<#(MKPolyline *)#>];
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer* renderer=[[MKCircleRenderer alloc]initWithCircle:overlay];
        renderer.strokeColor=[UIColor redColor];
        renderer.fillColor=[[UIColor redColor] colorWithAlphaComponent:0.2];
        renderer.lineWidth=1.f;
        return renderer;
    } else if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer* polylineRenderer=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
        polylineRenderer.strokeColor=[UIColor blueColor];
        polylineRenderer.fillColor=[UIColor greenColor];
        
        return polylineRenderer;
    } else {
        return nil;
    }
    
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [view setSelected:YES];
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //find out address from coordinate and other attributes
    if ([view.annotation isKindOfClass:[NVStudent class]]) {
        NVStudent <MKAnnotation>*student=view.annotation;
        CLLocation* location=[[CLLocation alloc]initWithLatitude:student.coordinate.latitude longitude:student.coordinate.longitude];
    CLGeocoder* geocoder=[[CLGeocoder alloc]init];
        __weak ViewController* weakSelf=self;
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        weakSelf.dictionaryWithAddress=[placemarks objectAtIndex:0];
        /*
        UINavigationController *nav = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"DetailInfoNavigationController"];
        NVDetailInfoViewController *controller=(NVDetailInfoViewController*)[nav topViewController];
        NSLog(@"%@",controller.fieldFirstname.text);
        controller.dictionaryWithAddress=weakSelf.dictionaryWithAddress;
        //[controller.view setNeedsDisplay];
        */
        
       /*
        NSDictionary *dict=[placemarks objectAtIndex:0];
        NSLog(@"name: %@ \n thoroughfare: %@ \n subThoroughfare: %@ \n locality: %@ \n subLocality: %@ \n administrativeArea: %@ \n subAdministrativeArea: %@ \n postalCode: %@ \n ISOcountryCode: %@ \n country: %@ \n inlandWater: %@ \n ocean: %@ ",[dict valueForKey:@"name"],[dict valueForKey:@"thoroughfare"],[dict valueForKey:@"subThoroughfare"],[dict valueForKey:@"locality"],[dict valueForKey:@"subLocality"],[dict valueForKey:@"administrativeArea"],[dict valueForKey:@"subAdministrativeArea"],[dict valueForKey:@"postalCode"],[dict valueForKey:@"ISOcountryCode"],[dict valueForKey:@"country"],[dict valueForKey:@"inlandWater"],[dict valueForKey:@"ocean"]);
        */
        /*
         @property (nonatomic, readonly, copy) NSString *name; // eg. Apple Inc.
         @property (nonatomic, readonly, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
         @property (nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
         @property (nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
         @property (nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
         @property (nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
         @property (nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
         @property (nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
         @property (nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
         @property (nonatomic, readonly, copy) NSString *country; // eg. United States
         @property (nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
         @property (nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
         @property (nonatomic, readonly, copy) NSArray *areasOfInterest; // eg. Golden Gate Park
         @end
         */
        //-----
        //present popover
        //NVDetailInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NVDetailInfoViewController"];
        //  DetailInfoNavigationController
        
        UINavigationController *nav = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"DetailInfoNavigationController"];
        NVDetailInfoViewController *controller=(NVDetailInfoViewController*)[nav.viewControllers firstObject];
        controller.student=student;
        controller.dictionaryWithAddress=weakSelf.dictionaryWithAddress;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            //[mapView deselectAnnotation:view.annotation animated:YES];
            
            
            //controller.annotation = view.annotation;
            controller.preferredContentSize=CGSizeMake(600, 300);
            UIPopoverController* pc = [[UIPopoverController alloc] initWithContentViewController:nav/*controller*/];
            pc.delegate = weakSelf;
            weakSelf.popover=pc;
            
            [pc presentPopoverFromRect:[control convertRect:control.frame toView:view.superview] /*view.frame*/
                                inView:view.superview
              permittedArrowDirections:UIPopoverArrowDirectionAny
                              animated:YES];
        }
        else {
            //UINavigationController* nav=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailInfoNavigationController"];
            
            //[self presentViewController:nav animated:YES completion:nil];
            [self performSegueWithIdentifier:@"segueShowInfo1" sender:controller];
            
        }
        //------
    }];

    
    }
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    
    if ([view.annotation isKindOfClass:[NVPlaceForMeeting class]]) {
        
        if (newState==MKAnnotationViewDragStateStarting) {
            [self.mapView removeOverlays:self.mapView.overlays];
        }
        if (newState==MKAnnotationViewDragStateEnding) {
            view.dragState = MKAnnotationViewDragStateNone;
            [self circleOverlayForMeetingPlace:[view.annotation coordinate]];
            [self calculateNumberOfStudentsInArea:[view.annotation coordinate]];
            if (self.isButtonForAddRoutesPushed) {
                [self calculateRoutesByButton:NO];
            }
            

        }
    }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - CGRectGetHeight(self.view.frame), CGRectGetWidth(aV.frame) , CGRectGetHeight(aV.frame));
        
        // Animate drop
        
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
}
#pragma mark - help methods
- (void) calculateRoutesByButton:(BOOL) isByButton {
    //if this method called by button, then we choose new students randomly. In other way, i.e. if we just move meeting point - re-draw routes for same students
    if (self.currentCircle) {
        MKDirectionsRequest* request=[[MKDirectionsRequest alloc]init];
        request.transportType=MKDirectionsTransportTypeAny;
        //destination
        MKPlacemark* meetPlacemark=[[MKPlacemark alloc]initWithCoordinate:self.currentCircle.coordinate addressDictionary:nil];
        MKMapItem* meetItem=[[MKMapItem alloc]initWithPlacemark:meetPlacemark];
        request.destination=meetItem;
        //----end of destination
        NSArray* sourceArray=nil;
        if (isByButton) {
            sourceArray=self.arrayOfStudents;
            [self.arrayOfStudentsAlreadyOnMap removeAllObjects];
        } else {
            sourceArray=self.arrayOfStudentsAlreadyOnMap;
        }
        NSMutableArray* tempArray=[[NSMutableArray alloc]init];
        MKMapPoint meetPoint = MKMapPointForCoordinate(self.currentCircle.coordinate);
        for (NVStudent* obj in sourceArray) {
            if (isByButton) {
                //randomize probability of coming to place. If somebody is nearer to meetPoint, then he has more chances. If somebody lives far than radiusBig, he never comes.
                MKMapPoint studentPoint = MKMapPointForCoordinate(obj.coordinate);
                CLLocationDistance distance = MKMetersBetweenMapPoints(meetPoint, studentPoint);
                int randomDistance=arc4random_uniform((int)self.radiusOfBigArea);
                if (randomDistance>(self.radiusOfBigArea - distance)) {
                    continue;
                }
                //----end of randomize probability
                [self.arrayOfStudentsAlreadyOnMap addObject:obj];
            }
            
            //source (student's location)
            MKPlacemark* sourcePlacemark=[[MKPlacemark alloc]initWithCoordinate:obj.coordinate addressDictionary:nil];
            MKMapItem* sourceMeet=[[MKMapItem alloc]initWithPlacemark:sourcePlacemark];
            request.source=sourceMeet;
            
            MKDirections* direction=[[MKDirections alloc]initWithRequest:request];
            [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if ([response.routes count]==0) {
                    NSLog(@"no roads found");
                } else {
                    //NSMutableArray* tempArray=[[NSMutableArray alloc]init];
                    for (MKRoute* route in response.routes){
                        [tempArray addObject:route.polyline];
                    }
                    [self.mapView addOverlays:tempArray level:MKOverlayLevelAboveRoads];
                    [self.arrayOfRoutesOverlays addObject:tempArray];
                }
                
            }];
        }
        
        
    }
    
}
- (void) calculateNumberOfStudentsInArea:(CLLocationCoordinate2D) center {
    NSInteger numberOfStudentsInSmallArea=0;
    NSInteger numberOfStudentsInMiddleArea=0;
    NSInteger numberOfStudentsInBigArea=0;
    MKMapPoint meetPoint = MKMapPointForCoordinate(center);
    
    
    for (NVStudent* obj in self.arrayOfStudents){
        MKMapPoint studentPoint = MKMapPointForCoordinate(obj.coordinate);
        CLLocationDistance distance = MKMetersBetweenMapPoints(meetPoint, studentPoint);
        if (distance<self.radiusOfSmallArea) {
            numberOfStudentsInSmallArea++;
        } else if (distance>=self.radiusOfSmallArea && distance<self.radiusOfMiddleArea){
            numberOfStudentsInMiddleArea++;
        } else if (distance>=self.radiusOfMiddleArea && distance<self.radiusOfBigArea){
            numberOfStudentsInBigArea++;
        }
    }
    self.labelStudentsIn5km.text=[NSString stringWithFormat:@"%ld",numberOfStudentsInSmallArea];
    self.labelStudentsIn10km.text=[NSString stringWithFormat:@"%ld",numberOfStudentsInMiddleArea];
    self.labelStudentsIn15km.text=[NSString stringWithFormat:@"%ld",numberOfStudentsInBigArea];
    
}
- (void) findOutAdressFromCoordinate {
    
}
- (void) circleOverlayForMeetingPlace:(CLLocationCoordinate2D) center {
    MKCircle* circleOverlaySmall=[MKCircle circleWithCenterCoordinate:center radius:self.radiusOfSmallArea];
    MKCircle* circleOverlayMiddle=[MKCircle circleWithCenterCoordinate:center radius:self.radiusOfMiddleArea];
    MKCircle* circleOverlayBig=[MKCircle circleWithCenterCoordinate:center radius:self.radiusOfBigArea];
    self.currentCircle=circleOverlaySmall;
    [self.mapView addOverlays:@[circleOverlaySmall,circleOverlayMiddle,circleOverlayBig] level:MKOverlayLevelAboveRoads];
}
#pragma mark -segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueShowInfo1"]) {
        NVDetailInfoViewController* vc= (NVDetailInfoViewController*)[[segue.destinationViewController viewControllers] firstObject];
        
        NVDetailInfoViewController* vc1=(NVDetailInfoViewController*)sender;
        vc.student=vc1.student;
        vc.dictionaryWithAddress=self.dictionaryWithAddress;
        //NSLog(@"%@",vc.student.firstname);
    }
}
#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popover=nil;
}
@end
