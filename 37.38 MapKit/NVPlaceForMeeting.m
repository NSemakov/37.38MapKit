//
//  NVPlaceForMeeting.m
//  37.38 MapKit
//
//  Created by Admin on 21.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVPlaceForMeeting.h"

@implementation NVPlaceForMeeting
+(NVPlaceForMeeting*) currentPlaceForMeeting {
    static NVPlaceForMeeting* place=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        place=[[NVPlaceForMeeting alloc] init];
    });
    return place;
}
@end
