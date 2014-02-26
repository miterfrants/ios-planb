//
//  VCTest.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UIViewController+JASidePanel.h"
#import "VariableStore.h"
#import "GAITrackedViewController.h"

@interface VCMap : GAITrackedViewController<GMSMapViewDelegate>
@property (nonatomic,strong) GMSMapView *mapview;
@property int mapStatus;
@property UIButton *btnTakeMeThere;
@property UIButton *btnNext;
@property UIButton *btnPrevious;
@property (nonatomic,retain) NSMutableArray *arrMarker;
@property VariableStore *vs;
-(void) pinMarker:(float) lat lng:(float) lng name:(NSString*) name snippet:(NSString *) snippet;
-(void) clearMarker;
@property (nonatomic,assign) NSInteger *currIndex;
@end
