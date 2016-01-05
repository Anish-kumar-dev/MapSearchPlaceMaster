//
//  AKMapAnnotationView.m
//  TestProject
//
//  Created by Appstudioz on 12/28/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import "AKMapAnnotationView.h"
#import "AKMapAnnotation.h"

@interface AKMapAnnotationView ()
@property (nonatomic, weak) UIImageView *leftAccessaryImageView;
@property (nonatomic, weak) UIButton *rightAccessaryButton;

@end
@implementation AKMapAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    // Add Detail Button
    UIButton *rightAccessaryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightAccessaryButton addTarget:self action:@selector(rightAccessaryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightAccessaryButton setImage:[UIImage imageNamed:@"right_detail_button"] forState:UIControlStateNormal];
    //Add Image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [UIImage imageNamed:@"place"];
    self.leftAccessaryImageView = imageView;
    self.rightAccessaryButton = rightAccessaryButton;
    self.leftCalloutAccessoryView = imageView;
    self.rightCalloutAccessoryView = rightAccessaryButton;
    self.layer.borderWidth = 1.0;
    
#pragma mark - 
    if ([self.dataSource respondsToSelector:@selector(annotationView:ViewForAnnotation:)]) {
        UIView *contentView = [self.dataSource annotationView:self ViewForAnnotation:self.annotation];
        [self addSubview:contentView];
        self.contentView = contentView;
        self.frame = contentView.bounds;
    }
    else {
        if (self.contentView == nil) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinImage"]];
            [self addSubview:imgView];
            self.contentView = imgView;
            self.frame = imgView.bounds;
        }
        
    }
    if ([self.dataSource respondsToSelector:@selector(annotationView:imageForAnnotation:)]) {
        self.leftAccessaryImageView.image = [self.dataSource annotationView:self imageForAnnotation:self.annotation];
    }
    if ([self.dataSource respondsToSelector:@selector(annotationView:imageForRightAccessary:)]) {
        [self.rightAccessaryButton setImage:[self.dataSource annotationView:self imageForAnnotation:self.annotation] forState:UIControlStateNormal];
    }
    
    
    
    
    return self;
}
- (void)rightAccessaryButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(annotationView:didPressedRightAccessary:)]) {
        [self.delegate annotationView:self didPressedRightAccessary:sender];
    }
}
- (void)setPlace:(AKPlace *)place {
    _place = place;
    [place requestForUpdateWithCompletion:^{
        AKMapAnnotation *ann = (AKMapAnnotation *)self.annotation;
        ann.title = place.addressDictionary[@"SubLocality"];
        ann.subtitle = place.addressDictionary[@"City"];
    }];
    
}
- (void)annotationViewDidSelect:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}
- (void)setDataSource:(id<AKMapAnnotationViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    if ([self.dataSource respondsToSelector:@selector(annotationView:ViewForAnnotation:)]) {
        UIView *contentView = [self.dataSource annotationView:self ViewForAnnotation:self.annotation];
        [self addSubview:contentView];
        self.contentView = contentView;
        self.frame = contentView.bounds;
    }
    else {
        if (self.contentView == nil) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinImage"]];
            [self addSubview:imgView];
            self.contentView = imgView;
            self.frame = imgView.bounds;
        }
        
    }
    if ([self.dataSource respondsToSelector:@selector(annotationView:imageForAnnotation:)]) {
        self.leftAccessaryImageView.image = [self.dataSource annotationView:self imageForAnnotation:self.annotation];
    }
    if ([self.dataSource respondsToSelector:@selector(annotationView:imageForRightAccessary:)]) {
        [self.rightAccessaryButton setImage:[self.dataSource annotationView:self imageForRightAccessary:self.annotation] forState:UIControlStateNormal];
    }
//    if ([self.dataSource respondsToSelector:@selector(annotationView:CalloutViewForAnnotation:)]) {
//        self.canShowCallout = NO;
//        UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annotationViewDidSelect:)];
//        [self.contentView setUserInteractionEnabled:YES];
//        [self.contentView addGestureRecognizer:tapGuester];
//        self.callOutView = [self.dataSource annotationView:self CalloutViewForAnnotation:self.annotation];
//        
//        CGRect frame = self.frame;
//        frame.size.height += self.callOutView.bounds.size.height;
//        frame.size.width = self.callOutView.bounds.size.width;
//        frame.origin.x = self.callOutView.center.x;
//        self.frame = frame;
//        
//        CGRect calloutViewframe = self.bounds;
//        calloutViewframe.origin.y = - calloutViewframe.origin.y - 50;
////        self.callOutView.frame = calloutViewframe;
//        self.callOutView.alpha = 0.5;
//        [self addSubview:self.callOutView];
//    }
//    else {
//        self.canShowCallout = YES;
//    }
}

- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated {
    [super setDragState:newDragState animated:animated];
    switch (newDragState) {
        case MKAnnotationViewDragStateStarting:
            self.dragState = MKAnnotationViewDragStateDragging;
            break;
        case MKAnnotationViewDragStateEnding: {
            self.dragState = MKAnnotationViewDragStateNone;
            
            AKMapAnnotation *an = (AKMapAnnotation *)self.annotation;
            self.place.location = [[CLLocation alloc] initWithLatitude:an.coordinate.latitude longitude:an.coordinate.longitude];
            __weak AKMapAnnotationView *weakSelf = self;
            [self.place requestForUpdateWithCompletion:^{
                if (![self.dataSource respondsToSelector:@selector(annotationView:ViewForAnnotation:)]) {
                    AKMapAnnotation *ann = (AKMapAnnotation *)weakSelf.annotation;
                    ann.title = self.place.addressDictionary[@"SubLocality"];
                    ann.subtitle = self.place.addressDictionary[@"City"];
                }
                
            }];
        }
            
            break;
        case MKAnnotationViewDragStateCanceling:
            self.dragState = MKAnnotationViewDragStateNone;
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(annotationView:didChangeState:)]) {
        [self.delegate annotationView:self didChangeState:newDragState];
    }
}

@end
