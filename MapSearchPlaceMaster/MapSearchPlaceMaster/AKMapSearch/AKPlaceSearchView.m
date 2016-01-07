//
//  AKPlaceSearchView.m
//  TestProject
//
//  Created by Appstudioz on 1/4/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//

#import "AKPlaceSearchView.h"
#import "AKCalloutMapAnnotationView.h"


@interface AKPlaceSearchView (SearchView)<UISearchBarDelegate>
@end
@interface AKPlaceSearchView (SearchTable)<UITableViewDataSource, UITableViewDelegate>
@end
@interface AKPlaceSearchView (MapDelegate)<MKMapViewDelegate>

@end

@interface AKPlaceSearchView ()
{
    NSArray *searchAddresses;
    
}
@property (nonatomic, strong) AKMapAnnotation *calloutAnnotation;
@property (nonatomic, weak) MKAnnotationView *selectedAnnotationView;

@property (weak, nonatomic) IBOutlet UITableView *searchAddressTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
@implementation AKPlaceSearchView


+ (AKPlaceSearchView *)placeSearchView {
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"AKPlaceSearchView" owner:nil options:nil];
    return nibsArray.firstObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSException* myException = [NSException exceptionWithName:@"Non Usable Method" reason:@"You should not use this method, Please use [AKPlaceSearchView placeSearchView]" userInfo:nil];
    @throw myException;
    return self;
}
- (instancetype)init {
    self = [super init];
    NSException* myException = [NSException exceptionWithName:@"Non Usable Method" reason:@"You should not use this method, Please use [AKPlaceSearchView placeSearchView]" userInfo:nil];
    @throw myException;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end

@implementation AKPlaceSearchView (MapDelegate)

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s",__FUNCTION__);
    if ([view isKindOfClass:[AKMapAnnotationView class]]) {
        AKMapAnnotation *ann = view.annotation;
        AKMapAnnotationView *annView = (AKMapAnnotationView *)view;
        if ([annView.dataSource respondsToSelector:@selector(annotationView:CalloutViewForAnnotation:)]) {
            if (self.calloutAnnotation == nil) {
                
                self.calloutAnnotation = [[AKMapAnnotation alloc] initWithLocation:ann.coordinate title:@""];
                
            }else {
                self.calloutAnnotation.coordinate = ann.coordinate;
            }
            [self.mapView addAnnotation:self.calloutAnnotation];
            self.selectedAnnotationView = view;
        }
        
    }

    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if (self.calloutAnnotation) {
        [self.mapView removeAnnotation: self.calloutAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    AKMapAnnotationView *annView = (AKMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AKAnnotation"];
    if (annotation == self.calloutAnnotation) {
        AKCalloutMapAnnotationView *calloutMapAnnotationView = (AKCalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        if (!calloutMapAnnotationView) {
            calloutMapAnnotationView = [[AKCalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"];
            
            UIView *callOutView = [((AKMapAnnotationView *)self.selectedAnnotationView).dataSource annotationView:annView CalloutViewForAnnotation:annView.annotation];
            CGRect frame = callOutView.frame;
            if (frame.size.width > self.window.bounds.size.width) {
                frame.size.width = self.window.bounds.size.width;
            }
            if (frame.size.height > self.window.bounds.size.height / 2) {
                frame.size.height = self.window.bounds.size.height / 2;
            }
            callOutView.frame = frame;
            CGPoint center = callOutView.center;
            center.x = mapView.bounds.size.width / 2;
            callOutView.center = center;
            
            
            calloutMapAnnotationView.contentHeight = callOutView.bounds.size.height;
            [calloutMapAnnotationView.contentView addSubview:callOutView];
            calloutMapAnnotationView.isClearColor = YES;
        }
        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
        calloutMapAnnotationView.mapView = self.mapView;
        return calloutMapAnnotationView;
        
    }
    if (annView == nil) {
        annView = [[AKMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AKAnnotation"];
        annView.dataSource = self.mapAnnotationDataSource;
        annView.delegate = self.mapAnnotationDelegate;
        annView.draggable = YES;
        
        annView.canShowCallout = ![annView.dataSource respondsToSelector:@selector(annotationView:CalloutViewForAnnotation:)];
    }
    AKMapAnnotation *an = (AKMapAnnotation *)annotation;
    annView.place = [[AKPlace alloc] initWithCoordinate:an.coordinate];
    return annView;
}

@end

@implementation AKPlaceSearchView (SearchView)

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self endEditing:YES];
    self.searchAddressTableView.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        self.searchAddressTableView.hidden = NO;
        [self searchAddress:searchText];
    }
    else {
        self.searchAddressTableView.hidden = YES;
    }
    
}
- (void)searchAddress:(NSString *)searchText {
    NSURL *url =[[NSURL alloc ]initWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=false&key=%@",searchText,@"AIzaSyDeTt4nrLTQAfNtq7o_kMFzanMIEONZpuw"]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (json) {
                
                searchAddresses = json[@"predictions"];
                [self.searchAddressTableView reloadData];
            }
            else {
                
            }
        }
    }];
}

@end
@implementation AKPlaceSearchView (SearchTable)



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self endEditing:YES];
    NSDictionary *dict = searchAddresses[indexPath.row];
    self.searchBar.text = dict[@"description"];
    tableView.hidden = YES;
    
    
    NSURL *url =[[NSURL alloc ]initWithString:[[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false&key=AIzaSyCmrDdNwGRUBalIePLaCP-bf9rm5_VMgdk",self.searchBar.text] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (json) {
            
            searchAddresses = json[@"predictions"];
            [self.searchAddressTableView reloadData];
            
            id addressComps = [(json[@"results"]) firstObject];
            addressComps = [addressComps valueForKeyPath:@"geometry.location"];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([addressComps[@"lat"] floatValue], [addressComps[@"lng"] floatValue]);
            AKMapAnnotation *pointAnn = [[AKMapAnnotation alloc] initWithLocation:coord title:@"Hey! Anish."];
            [self.mapView addAnnotation:pointAnn];
            
            MKCoordinateRegion currentRegion = self.mapView.region;
            if (currentRegion.span.latitudeDelta > 0.15) {
                currentRegion.span = MKCoordinateSpanMake(0.15, 0.15);
            }
            MKCoordinateRegion region = MKCoordinateRegionMake(coord, currentRegion.span);
            [self.mapView setRegion:region animated:YES];
        }
        else {
            
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchAddresses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSDictionary *dict = searchAddresses[indexPath.row];
    cell.textLabel.text = dict[@"description"];
    return cell;
}

@end