//
//  AKPlace.h
//  TestProject
//
//  Created by Appstudioz on 12/29/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AKPlace : NSObject


/*
 *  initWithLatitude:longitude:
 *
 *  Discussion:
 *    Initialize with the specified latitude and longitude.
 */

- (nonnull instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)requestForUpdateWithCompletion:(void (^ __nullable)(void))completion;


/*
 *  location
 *
 *  Discussion:
 *    Returns the geographic location associated with the placemark.
 */
@property (nonatomic, copy, nullable) CLLocation *location;

@property (nonatomic, readonly, copy, nullable) NSDictionary *addressDictionary;

@end
