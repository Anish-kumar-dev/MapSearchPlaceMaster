//
//  AKMapAnnotation.m
//  TestProject
//
//  Created by Appstudioz on 12/28/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import "AKMapAnnotation.h"


@implementation AKMapAnnotation
@synthesize coordinate;
@synthesize title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)newTitle {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = newTitle;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}



@end
