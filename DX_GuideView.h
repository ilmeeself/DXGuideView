//
//  AppDelegate.h
//  DX_GuideView
//
//  Created by Du on 2018/11/27.
//  Copyright © 2018 Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DX_GuideView;
@protocol DX_GuideViewDelegate <NSObject>
- (void)onSkipButtonPressed;
@end

@interface DX_GuideView:UIView
@property id <DX_GuideViewDelegate>delegate;
@end
