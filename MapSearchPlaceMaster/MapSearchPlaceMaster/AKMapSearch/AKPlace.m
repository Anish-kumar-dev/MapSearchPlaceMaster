//
//  AKPlace.m
//  TestProject
//
//  Created by Appstudioz on 12/29/15.
//  Copyright © 2015 Appstudioz. All rights reserved.
//

#import "AKPlace.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AKPlace ()

@property (nonatomic, readwrite, copy, nullable) NSDictionary *addressDictionary;
@end
@implementation AKPlace

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    self.location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    return self;
}

- (void)requestForUpdateWithCompletion:(void (^ __nullable)(void))completion {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        
        //NSLog(@"Received placemarks: %@", placemarks);
        CLPlacemark *placeMark = placemarks.firstObject;
        if (placeMark) {
            self.addressDictionary = placeMark.addressDictionary;
            completion();
        }
        
    }];
}
// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {

        
        NSString *message;
        switch (error.code)
        {
            case kCLErrorGeocodeFoundNoResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled:
                message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = error.description;
                break;
        }
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"An error occurred."
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =
        [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // do some thing here
                               }];
        [alertController addAction:ok];
        [delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

@end
