//
//  AKPlaceSearchView.h
//  TestProject
//
//  Created by Appstudioz on 1/4/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AKMapAnnotation.h"
#import "AKMapAnnotationView.h"

@interface AKPlaceSearchView : UIView

+ (AKPlaceSearchView *)placeSearchView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) id<AKMapAnnotationViewDataSource> mapAnnotationDataSource;
@property (nonatomic, strong) id<AKMapAnnotationViewDelegate> mapAnnotationDelegate;

@end
