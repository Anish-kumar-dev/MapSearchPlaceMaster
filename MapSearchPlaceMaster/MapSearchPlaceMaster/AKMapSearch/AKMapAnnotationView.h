//
//  AKMapAnnotationView.h
//  TestProject
//
//  Created by Appstudioz on 12/28/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AKPlace.h"

@class AKMapAnnotationView;
@protocol AKMapAnnotationViewDataSource <NSObject>
@optional
- (UIView *)annotationView:(AKMapAnnotationView *)annotationView CalloutViewForAnnotation:(id<MKAnnotation>)annotation;

- (UIView *)annotationView:(AKMapAnnotationView *)annotationView ViewForAnnotation:(id<MKAnnotation>)annotation;
- (UIImage *)annotationView:(AKMapAnnotationView *)annotationView imageForAnnotation:(id<MKAnnotation>)annotation;
- (UIImage *)annotationView:(AKMapAnnotationView *)annotationView imageForRightAccessary:(id<MKAnnotation>)annotation;
@end
@protocol AKMapAnnotationViewDelegate <NSObject>
@optional
- (void)annotationView:(AKMapAnnotationView *)annotationView didChangeState:(MKAnnotationViewDragState)dragState;
- (void)annotationView:(AKMapAnnotationView *)annotationView didPressedRightAccessary:(id)sender;
@end


@interface AKMapAnnotationView : MKAnnotationView
@property (nonatomic, strong) id<AKMapAnnotationViewDataSource> dataSource;
@property (nonatomic, strong) id<AKMapAnnotationViewDelegate> delegate;
@property (nonatomic, weak) UIView *callOutView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) AKPlace *place;
@end
