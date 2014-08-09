//
//  AFPopupView.h
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDPopupView : UIView {
    
}

@property (nonatomic) BOOL hideOnBackgroundTap;

+(GDPopupView *)popupWithView:(UIView *)popupView;

-(void)show;
-(void)hide;

@end
