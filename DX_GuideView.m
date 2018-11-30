//
//  AppDelegate.h
//  DX_GuideView
//
//  Created by Du on 2018/11/27.
//  Copyright © 2018 Du. All rights reserved.
//

#import "DX_GuideView.h"
#import "Header.h"
//
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define imageCount 4

@interface DX_GuideView () <UIScrollViewDelegate> {
    int lastindex;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *skipButton;
@end

@implementation DX_GuideView
#pragma mark UI
- (void)createGuideViewWithImages:(NSArray *)imageArray{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.contentSize = CGSizeMake((SCREEN_WIDTH)*imageCount, self.scrollView.frame.size.height);
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    UIImage * skipimage = [UIImage imageNamed:@"Skip"];
    for (int i = 0; i < imageCount; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = (CGRect){SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT};
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString * _Nullable imagePath = [[NSBundle mainBundle] pathForResource:imageArray[i] ofType:@"jpg"];
        NSURL *imageUrl = [NSURL fileURLWithPath:imagePath];//图片资源为空会报错
        [imageView sd_setImageWithURL:imageUrl];
        [self.scrollView addSubview:imageView];
        
        self.skipButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-skipimage.size.width + SCREEN_WIDTH*i, 5+SafeAreaHeaderDifferenceHeight, skipimage.size.width, skipimage.size.height)];
        [self.skipButton setTintColor:[UIColor whiteColor]];
        [self.skipButton setBackgroundImage:skipimage forState:UIControlStateNormal];
        [self.skipButton addTarget:self action:@selector(didFinishedIntro) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.skipButton];
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT-35-SafeAreaBottomHeight, 200, 30)];
    self.pageControl.currentPageIndicatorTintColor = COLOR_153;//(rgba:153,153,153,1)
    self.pageControl.pageIndicatorTintColor = COLOR_225;//(rgba:225,225,225,1)
    self.pageControl.numberOfPages = imageCount;
    [self addSubview:self.pageControl];
}

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    lastindex = imageCount;
    if(self){
        //隐藏=YES,显示=NO; Animation:动画效果
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        NSArray *imageArr = [NSArray array];
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
            //ipad设备
            NSLog(@"ipad设备");
            imageArr = @[@"1_2",@"2_2",@"3_2",@"4_2"];
        }
        else{
            //iphone设备
            NSLog(@"iphone设备");
            imageArr = @[@"1",@"2",@"3",@"4"];
        }
        [self createGuideViewWithImages:imageArr];
    }
    return self;
}

#pragma mark user action
- (void)didFinishedIntro {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if ([self.delegate respondsToSelector:@selector(onSkipButtonPressed)]) {
        [self.delegate onSkipButtonPressed];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int Offset = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    NSLog(@"%d",Offset);
    if (lastindex == Offset && lastindex != 0)
    {
        [self didFinishedIntro];
        return;
    }
    self.pageControl.currentPage = Offset;
    lastindex = Offset;
}
@end

/*
 #define SafeAreaTopHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88 : 64)
 #define SafeAreaBottomHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34 : 0)
 #define SafeAreaHeaderDifferenceHeight SafeAreaTopHeight-NAVIGATIONBAR_HEIGHT（64）
*/
