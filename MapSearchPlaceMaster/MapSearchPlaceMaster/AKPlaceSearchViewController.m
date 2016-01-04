//
//  AKPlaceSearchViewController.m
//  TestProject
//
//  Created by Appstudioz on 1/4/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//

#import "AKPlaceSearchViewController.h"
#import "AKPlaceSearchView.h"


@interface AKPlaceSearchViewController ()<AKMapAnnotationViewDataSource, AKMapAnnotationViewDelegate>

@end

@implementation AKPlaceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AKPlaceSearchView *placeSearchView = [AKPlaceSearchView placeSearchView];
    placeSearchView.mapView.showsUserLocation = YES;
    placeSearchView.mapAnnotationDataSource = self;
    placeSearchView.mapAnnotationDelegate = self;
    CGRect frame = self.view.bounds;
    placeSearchView.frame = frame;
    [self.view addSubview:placeSearchView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)annotationView:(AKMapAnnotationView *)annotationView didChangeState:(MKAnnotationViewDragState)dragState {
    AKMapAnnotation *ann = annotationView.annotation;
    NSLog(@"cord : %f, %f", ann.coordinate.latitude, ann.coordinate.longitude);
}

- (void)annotationView:(AKMapAnnotationView *)annotationView didPressedRightAccessary:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}

- (UIImage *)annotationView:(AKMapAnnotationView *)annotationView imageForAnnotation:(id<MKAnnotation>)annotation {
    return [UIImage imageNamed:@"place"];
}
- (UIImage *)annotationView:(AKMapAnnotationView *)annotationView imageForRightAccessary:(id<MKAnnotation>)annotation {
    return [UIImage imageNamed:@"right_detail_button"];
}


@end
