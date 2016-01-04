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
        NSLog(@"Address = %@",place.addressDictionary);
        AKMapAnnotation *ann = (AKMapAnnotation *)self.annotation;
        ann.title = place.addressDictionary[@"SubLocality"];
        ann.subtitle = place.addressDictionary[@"City"];
    }];
    
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
}

- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated {
    [super setDragState:newDragState animated:animated];
    switch (newDragState) {
        case MKAnnotationViewDragStateStarting:
            self.dragState = MKAnnotationViewDragStateDragging;
            break;
        case MKAnnotationViewDragStateEnding: {
            self.dragState = MKAnnotationViewDragStateNone;
            NSLog(@"content : %@",self.superview);
            AKMapAnnotation *an = (AKMapAnnotation *)self.annotation;
            self.place.location = [[CLLocation alloc] initWithLatitude:an.coordinate.latitude longitude:an.coordinate.longitude];

            [self.place requestForUpdateWithCompletion:^{
                NSLog(@"Address = %@",self.place.addressDictionary);
                AKMapAnnotation *ann = (AKMapAnnotation *)self.annotation;
                ann.title = self.place.addressDictionary[@"SubLocality"];
                ann.subtitle = self.place.addressDictionary[@"City"];
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
