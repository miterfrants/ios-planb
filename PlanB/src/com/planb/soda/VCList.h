//
//  VCList.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JASidePanel.h"
#import "UIScrollPlaceListView.h"
#import "VariableStore.h"
#import "GAITrackedViewController.h"
#import "CKRefreshControl.h"

@interface VCList : GAITrackedViewController<CLLocationManagerDelegate>
    @property (strong, nonatomic) IBOutlet UIScrollPlaceListView *SVListContainer;
    @property NSString *type;
    @property NSString *cateTitle;
    @property NSString *keyword;
    @property NSString *defaultBGName;
    @property (strong,nonatomic) NSMutableArray *arrButton;
    @property (strong,nonatomic) UIImageView *loadingView;
    @property (strong,nonatomic) UIView *loadingCon;
    @property (strong,nonatomic) UILabel * loadingTitle;
    @property (strong,nonatomic) CKRefreshControl *refreshControl;
    @property BOOL isGenerateList;
    @property (strong,nonatomic) NSString *nextPageToken;
    @property int currentCount;
    @property VariableStore *vs;
    @property NSTimer *requestTimoutTimer;
    @property NSTimer *nextButtonTimoutTimer;
    @property NSString *otherSource;
    @property NSMutableDictionary *dicResult;
    @property UIButton *btnNextPage;
-(void)generateList:(NSString *) isNext isReget:(BOOL) isReget;
    -(void) showBtnNextPage;
    -(void) hideBtnNextPage;
@end
