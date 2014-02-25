//
//  VCDetail.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/19.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import "VCDetail.h"
#import "VariableStore.h"
#import "Util.h"
#import "JASidePanelController.h"
#import "VCMap.h"
#import "DYRateView.h"
#import "VCRoot.h"
#import "AsyncImgView.h"
@interface VCDetail ()

@end

@implementation VCDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadSelfComment{
    VariableStore *vs =[VariableStore sharedInstance];
    int localId=vs.intLocalId;
        NSString *url= [NSString stringWithFormat:@"http://%@/controller/mobile/place.aspx?action=get&member_id=%D&google_id=%@",vs.domain, localId,_strGoogleId ];
    if(vs.intLocalId==0){
        _txtComment.hidden=YES;
        _btnSend.hidden=YES;
        _rateView.hidden=YES;
        _btnPin.hidden=YES;
        _btnLogin.hidden=NO;
    }else{
        _txtComment.hidden=NO;
        _btnSend.hidden=YES;
        _rateView.hidden=NO;
        _btnLogin.hidden=YES;
        _btnPin.hidden=NO;
        NSString *result=[NSString stringWithFormat:@"%@",[Util stringWithUrl:url] ];
        NSData * dataCommentAndVote=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonParsingError = nil;
        NSDictionary *dicCommentAndVote = [NSJSONSerialization JSONObjectWithData:dataCommentAndVote options:0 error:&jsonParsingError];
        if (jsonParsingError == nil){
            [_rateView setRate:[[dicCommentAndVote objectForKey:@"rating"] floatValue]];
            [_txtComment setText:[dicCommentAndVote objectForKey:@"comment"]];
        }else{
            NSLog(@"testError:%@",jsonParsingError);
        }
    }
}

- (void)viewDidLoad
{
    //initial
    VariableStore *vs =[VariableStore sharedInstance];
    [self.view setFrame:CGRectMake(0, 0, vs.screenW, vs.screenH)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if(!_isInitial){
        //UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0];
        _txtComment= [[UITextField alloc]init];
        [_txtComment setFrame:CGRectMake(0,64,100,30)];
        [self.view addSubview:_txtComment];
        
        _btnLogin=[[UIButton alloc]init];
        [_btnLogin setFrame:CGRectMake(0,64,100,30)];
        [_btnLogin setTitle:@"如要參與遊戲 請先登入" forState:UIControlStateNormal];
        //[_btnLogin setTitle:@"如要參與遊戲 請先登入"];
        //_btnLogin.titleLabel.text=@"如要參與遊戲 請先登入";
        //_btnLogin.titleLabel.textColor = [UIColor blackColor];
        //_btnLogin.titleLabel.font =font;
        //_btnLogin.titleLabel.numberOfLines = 1;
        //_btnLogin.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_btnLogin.titleLabel setFrame:CGRectMake(0, 0, 100, 30)];
        [self.view addSubview:_btnLogin];
        
        _btnPin=[[UIButton alloc]init];
        [_btnPin setFrame:CGRectMake(0,64,100,30)];
        [self.view addSubview:_btnPin];
        
        _btnSend=[[UIButton alloc]init];
        [_btnSend setFrame:CGRectMake(0,64,100,30)];
        [self.view addSubview:_btnSend];
        
        _isInitial=YES;
    }
    
    
    [super viewDidLoad];
    _rateView = [[DYRateView alloc] initWithFrame:CGRectMake(200,150, 100, 14)] ;
    _rateView.alignment = RateViewAlignmentLeft;
    _rateView.editable=YES;
    [self.view addSubview:_rateView];
    //NSLog(_strPlaceTitle);
    //NSLog(_strReference);
    UILabel *lblPlaceTitle=[[UILabel alloc] init];
    lblPlaceTitle.text=_strPlaceTitle;
    UILabel *lblReference=[[UILabel alloc] init];
    lblReference.text=_strReference;
    [self loadSelfComment];
    self.navigationController.topViewController.title=_strPlaceTitle;
    //get Place Detail
    NSString *url= [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", _strReference, [VariableStore sharedInstance].googleWebKey ];
    [_btnPin setBackgroundImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    NSData * dataPlaceDetail=[[Util stringWithUrl:url] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonParsingError = nil;
    NSDictionary *dicPlaceDetail = [NSJSONSerialization JSONObjectWithData:dataPlaceDetail options:0 error:&jsonParsingError];
    if(jsonParsingError == nil){
        //NSLog(@"%@",dicPlaceDetail);
        _strGooglePhone =[[dicPlaceDetail objectForKey:@"result"] valueForKey:@"formatted_phone_number"];
        //float rating=[[[dicPlaceDetail objectForKey:@"result"] valueForKey:@"rating"] floatValue];
        NSMutableArray *arrPhotos=[[dicPlaceDetail objectForKey:@"result"] objectForKey:@"photos"];

        UILabel *lblTitle = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0];
        
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font =font;
        lblTitle.numberOfLines = 50;
        //iOS 6,7
        //lblTitle.lineBreakMode = NSLineBreakByCharWrapping;
        lblTitle.lineBreakMode = UILineBreakModeWordWrap;
        [lblTitle setFrame:CGRectMake(0, 0, 100, 20)];

        if(arrPhotos !=nil){
            for(int i=0;i<arrPhotos.count;i++){
                
                //NSLog(@"%@",[[arrPhotos objectAtIndex:i] objectForKey:@"photo_reference"]);
                NSString *urlImg = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",[[arrPhotos objectAtIndex:i] objectForKey:@"photo_reference"], [VariableStore sharedInstance].googleWebKey] ;
                //  NSLog(strURL);
                NSURL * url=[[NSURL alloc] initWithString:urlImg];
                //NSURLRequest * req=[[NSURLRequest alloc] initWithURL:url];
                AsyncImgView *asyncImgView=[[AsyncImgView alloc] init];
                [asyncImgView setFrame:CGRectMake(i*80,0,80,80)];
                [_usvGallery addSubview:asyncImgView];
                [asyncImgView loadImageFromURL:url target:self completion:nil];
                /*NSOperationQueue *queue =[[NSOperationQueue alloc] init];

                [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if ([data length] > 0 && connectionError == nil){
                        UIImage *img=[[UIImage alloc]initWithData:data];
                        UIImageView * imgView=[[UIImageView alloc] initWithImage:img];
                        [imgView setFrame:CGRectMake(i*50,0,50,50)];
                        [_usvGallery addSubview:imgView];
                    }else if ([data length] == 0 && connectionError == nil){
                        //[delegate emptyReply];
                    }else if (error != nil && connectionError.code == ERROR_CODE_TIMEOUT){
                        //[delegate timedOut];
                    }else if (connectionError != nil){
                        //[delegate downloadError:error];
                    }

                }];*/
                
                
                //NSURL *imgURL=[NSURL URLWithString:strURL];
                //NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                //UIImage *img=[[UIImage alloc]initWithData:imgData];
                //UIImageView * imgView=[[UIImageView alloc] initWithImage:img];
                //[imgView setFrame:CGRectMake(i*50,0,50,50)];
                //[_usvGallery addSubview:imgView];

            }
            _usvGallery.contentSize=CGSizeMake(50*arrPhotos.count,50);
            [_usvGallery setBackgroundColor:[UIColor darkGrayColor]];
        }
       //NSLog(@"%@",dicPlaceDetail);

        [self generateCommentList:[[dicPlaceDetail objectForKey:@"result"] objectForKey:@"reviews"]];
        _strGoogleAddress=[[dicPlaceDetail objectForKey:@"result"] objectForKey:@"formatted_address"];

        _strLat=[[[[dicPlaceDetail objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        _strLng=[[[[dicPlaceDetail objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        //GMSMarker *marker = [[GMSMarker alloc] init];
       // NSLog(@"%@",lat);
        VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
        [vcMap clearMarker];
        [vcMap pinMarker:[_strLat floatValue] lng:[_strLng floatValue] name:_strPlaceTitle snippet:_strGoogleAddress
         ];
        
        //rating

        [_btnLogin addTarget:self action:@selector(showLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSend addTarget:self action:@selector(sendCommentAndVote:) forControlEvents:UIControlEventTouchUpInside];
        [_btnPin addTarget:self action:@selector(sendCommentAndVote:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        NSLog(@"%@",jsonParsingError);
    }
	// Do any additional setup after loading the view.
}
-(void) showLeftPanel:(id) sender{
    [self.sidePanelController showLeftPanelAnimated:YES];
}
-(void) generateCommentList:(NSMutableArray *) dic{
    [_usvDetail setScrollEnabled:YES];
    [_usvDetail setUserInteractionEnabled:YES];
    _usvDetail.contentSize = CGSizeMake(320, 25000);

    NSInteger currY=0;
    NSInteger padding=20;
    for(int i=0;i<dic.count;i++){
        UILabel *lblComment = [[UILabel alloc] init];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0];

        lblComment.textColor = [UIColor whiteColor];
        lblComment.font =font;
        lblComment.numberOfLines = 50;
        //iOS 6,7
        //lblComment.lineBreakMode = NSLineBreakByCharWrapping;
        lblComment.lineBreakMode =UILineBreakModeWordWrap;
        
        NSString *comment=[NSString stringWithFormat:@"%@:%@", [[dic objectAtIndex:i] valueForKey:@"author_name"], [[dic objectAtIndex:i] valueForKey:@"text"]];
        lblComment.text=comment;
        
        CGSize size = [lblComment.text sizeWithFont:lblComment.font constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:lblComment.lineBreakMode];

        [lblComment setFrame:CGRectMake(50,currY+padding, 200, size.height)];
        //[lblComment setBackgroundColor:[UIColor whiteColor]];
        [_usvDetail addSubview:lblComment];
        currY+=size.height+padding;
    }
    [_usvDetail setScrollEnabled:YES];
    [_usvDetail setBackgroundColor:[UIColor colorWithRed:0.4 green:0.5 blue:0.8 alpha:1]];
    [_usvDetail setContentSize:CGSizeMake(320, currY)];
    

}
-(void) sendCommentAndVote:(id) sender{
    _txtComment.enabled=NO;
    _btnSend.titleLabel.text=@"Sending";
    CGFloat rating=_rateView.rate;
    VariableStore *vs=[VariableStore sharedInstance];
    int localId=vs.intLocalId;
    NSString *sendVoteURL=[NSString stringWithFormat:@"http://%@/controller/mobile/place.aspx?action=vote&google_id=%@&lat=%@&lng=%@&google_address=%@&google_phone=%@&member_id=%d&rating=%f&google_name=%@&comment=%@",vs.domain,_strGoogleId,_strLat,_strLng,_strGoogleAddress,_strGooglePhone,localId,rating,_strPlaceTitle,_txtComment.text];
    //NSLog(@"%@",sendVoteURL);
    NSString *encodedString = [sendVoteURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    NSString *result=[Util stringWithUrl:encodedString];
    NSData *dataResult=[result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError= nil;
    NSDictionary * dicResult=[NSJSONSerialization JSONObjectWithData:dataResult options:0 error:&jsonParsingError];
    //NSLog(@"%@",[dicResult objectForKey:@"goods_name"]);
    _txtComment.enabled=YES;
    NSString *goodsName=[dicResult valueForKey:@"goods_name"];
    NSString *goodsDesc=[dicResult valueForKey:@"goods_desc"];
    //NSString *goodsAppearRate = [[dicResult objectForKey:@"goods"] valueForKey:@"rate"];
    //NSString *goodsPic = (NSString *)[[dicResult objectForKey:@"goods"] valueForKey:@"goods_pic"];
    if (goodsName!=nil){
        VCRoot *root = (VCRoot *) self.sidePanelController;
        [root popUp:[NSString stringWithFormat:@"獲得道具:%@", goodsName] msg:goodsDesc type:1 delay:.1];
    }
    //NSLog(@"%@",result);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
