//
//  Student.h
//  8. NSDictionary
//
//  Created by Admin on 15.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface NVStudent : NSObject <MKAnnotation>
@property (strong,nonatomic) NSString* firstname;
@property (strong,nonatomic) NSString* lastname;
@property (strong,nonatomic) NSDate * dateOfBirth;
@property (assign,nonatomic) NSInteger monthOfBirth;
@property (assign,nonatomic) BOOL isMan;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithProperties;
@end
