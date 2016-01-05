//
//  AKMapAnnotation.h
//  TestProject
//
//  Created by Appstudioz on 12/28/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AKMapAnnotation: NSObject <MKAnnotation> {
//    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic,  copy, nullable) NSString *subtitle;

- (nonnull instancetype)initWithLocation:(CLLocationCoordinate2D)coord title:(nonnull NSString *)newTitle;
@end
