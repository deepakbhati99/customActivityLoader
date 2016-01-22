//
//  runningView.h
//  customActivityLoader
//
//  Created by Himanshu Khatri on 1/19/16.
//  Copyright © 2016 bdAppManiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface runningView : UIView
@property (nonatomic, assign) BOOL hidesWhenStopped;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor;
- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor ballDiameter:(CGFloat)ballDiameter;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
