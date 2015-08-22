//
//  NVPlaceForMeeting.h
//  37.38 MapKit
//
//  Created by Admin on 21.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface NVPlaceForMeeting : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
+(NVPlaceForMeeting*) currentPlaceForMeeting;
@end
