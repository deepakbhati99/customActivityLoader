//
//  runningView.m
//  customActivityLoader
//
//  Created by Himanshu Khatri on 1/19/16.
//  Copyright © 2016 bdAppManiac. All rights reserved.
//

#import "runningView.h"

@interface runningView ()

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIView *leftBall;
@property (nonatomic, strong) UIView *rigthBall;

@property (nonatomic, strong) NSMutableArray *reflectionBalls;
@property (nonatomic, strong) UIView *leftReflectionBall;
@property (nonatomic ,strong) UIView *rightReflectionBall;


@property (nonatomic, strong) UIColor *ballColor;
@property (nonatomic, assign) CGFloat ballDiameter;

@property (nonatomic, assign) BOOL isRandomColor;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL shouldAnimate;



@end

static const NSUInteger ballCount = 3;
static const CGFloat defaultBallDiameter = 10;
static const CGFloat timeFreq=0.5;

@implementation runningView

- (id)initWithFrame:(CGRect)frame
{
    self.isRandomColor=YES;
    return [self initWithFrame:frame ballColor:[self getRandomColor]];
}

- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor
{

    return [self initWithFrame:frame ballColor:ballColor ballDiameter:defaultBallDiameter];
}

- (id)initWithFrame:(CGRect)frame ballColor:(UIColor *)ballColor ballDiameter:(CGFloat)ballDiameter
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.hidesWhenStopped = YES;
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.3];
        self.ballColor = ballColor;
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        if (ballDiameter < 0)
        {
            ballDiameter = defaultBallDiameter;
        }
        
        if (ballDiameter > CGRectGetWidth(frame) / ballCount)
        {
            ballDiameter = CGRectGetWidth(frame) / ballCount;
        }
        
        self.ballDiameter = ballDiameter;
        
        [self createBalls];
        [self createReflection];
        
        self.animating = NO;
        [self startAnimating];
    }
    return self;
}

- (void)createBalls
{
    self.balls = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat xPos = width / 2 - (ballCount / 2 + 0.5) * self.ballDiameter;
    CGFloat yPos = CGRectGetHeight(self.frame) / 2 - self.ballDiameter / 2;
    
    for (int i = 0; i < ballCount; i++)
    {
        UIView *ball = [self ball];
        ball.frame = CGRectMake(xPos, yPos, self.ballDiameter, self.ballDiameter);
        ball.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        [self addSubview:ball];
        [self.balls addObject:ball];
        
        xPos += self.ballDiameter;
    }
    
    UIView *Ball0=_balls[0];
    CGRect frame=Ball0.frame;
    frame.origin.x=frame.origin.x-frame.size.width;
    Ball0.frame=frame;
    
    self.leftBall = self.balls[0];
    self.rigthBall = self.balls[ballCount - 1];
}

- (void)createReflection
{
    self.reflectionBalls = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat xPos = width / 2 - (ballCount / 2 + 0.5) * self.ballDiameter;
    CGFloat yPos = CGRectGetHeight(self.frame) / 2 + self.ballDiameter / 2 + 5;
    
    for (int i = 0; i < ballCount; i++)
    {
        UIView *reflectionBall = [self ball];
        reflectionBall.frame = CGRectMake(xPos, yPos, self.ballDiameter, self.ballDiameter);
        reflectionBall.transform = CGAffineTransformMakeRotation(M_PI);
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = reflectionBall.bounds;
        gradient.startPoint = CGPointMake(0.5, 1);
        gradient.endPoint = CGPointMake(0.5, 0);
        gradient.colors = @[(id)[UIColor colorWithWhite:1 alpha:0.2].CGColor, (id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
        gradient.locations = @[@(0), @(0.35), @(1)];
        
        reflectionBall.layer.mask = gradient;
        
        reflectionBall.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        [self addSubview:reflectionBall];
        
        [self.reflectionBalls addObject:reflectionBall];
        
        xPos += self.ballDiameter;
    }
    
    
    UIView *reflectionBall0=_reflectionBalls[0];
    CGRect frame=reflectionBall0.frame;
    frame.origin.x=frame.origin.x-frame.size.width;
    reflectionBall0.frame=frame;
    
    self.leftReflectionBall = self.reflectionBalls[0];
    self.rightReflectionBall = self.reflectionBalls[ballCount - 1];
}

- (UIView *)ball
{
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ballDiameter, self.ballDiameter)];
    ball.backgroundColor = self.ballColor;
    ball.layer.cornerRadius = self.ballDiameter / 2;
    ball.clipsToBounds = YES;
    
    return ball;
}
-(void)startRunningLeftBall{
    
    [UIView animateWithDuration:timeFreq delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self animateView:self.balls.firstObject withReflectionView:self.reflectionBalls.firstObject changeAlphaTo:1];

        
    }completion:^(BOOL finished){

    }];

    [UIView animateWithDuration:timeFreq delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self animateView:self.balls.lastObject withReflectionView:self.reflectionBalls.lastObject changeAlphaTo:0];
        
        
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:timeFreq delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 1; i < ballCount-1; i++)
        {
            UIView *ball=self.balls[i];
            UIView *ballsReflection=self.reflectionBalls[i];
            
            CGRect initialFrame=ball.frame;
            initialFrame.origin.x=initialFrame.origin.x+initialFrame.size.width;
            ball.frame=initialFrame;
            
            
            CGRect reflectionFrame=ballsReflection.frame;
            reflectionFrame.origin.x=reflectionFrame.origin.x+reflectionFrame.size.width;
            ballsReflection.frame=reflectionFrame;
            
        }
    }completion:^(BOOL finished){
        

        UIColor *newColor;
        if (_isRandomColor) {
            newColor=[self getRandomColor];
        }else{
            newColor=_ballColor;
        }
        
        [self rePositonView:_balls.firstObject withReflectionView:_reflectionBalls.firstObject changeAlphaTo:0 andColor:newColor];
        
        for (int i = 1; i < ballCount-1; i++)
        {
            UIView *ball=self.balls[i];
            UIView *ballsReflection=self.reflectionBalls[i];
            
            CGRect initialFrame=ball.frame;
            initialFrame.origin.x=initialFrame.origin.x-initialFrame.size.width;
            ball.frame=initialFrame;
            
            CGRect reflectionFrame=ballsReflection.frame;
            reflectionFrame.origin.x=reflectionFrame.origin.x-reflectionFrame.size.width;
            ballsReflection.frame=reflectionFrame;
            
            ball.alpha=i;
            ballsReflection.alpha=i;
            
            ball.backgroundColor=newColor;
            ballsReflection.backgroundColor=newColor;
        }
        
        [self rePositonView:_balls.lastObject withReflectionView:_reflectionBalls.lastObject changeAlphaTo:1 andColor:newColor];
        
        if (_shouldAnimate)
            [self startRunningLeftBall];
    }];
}
-(void)rePositonView:(UIView *)ball withReflectionView:(UIView *)ballsReflection changeAlphaTo:(CGFloat)newAlpha andColor:(UIColor *)newColor{
    CGRect initialFrame=ball.frame;
    initialFrame.origin.x=initialFrame.origin.x-2*initialFrame.size.width;
    ball.frame=initialFrame;
    
    CGRect reflectionFrame=ballsReflection.frame;
    reflectionFrame.origin.x=reflectionFrame.origin.x-2*reflectionFrame.size.width;
    ballsReflection.frame=reflectionFrame;
    
    ball.alpha=newAlpha;
    ballsReflection.alpha=newAlpha;
    
    ball.backgroundColor=newColor;
    ballsReflection.backgroundColor=newColor;
}

-(void)animateView:(UIView *)ball withReflectionView:(UIView *)ballsReflection changeAlphaTo:(CGFloat)newAlpha{
    
    CGRect initialFrame=ball.frame;
    initialFrame.origin.x=initialFrame.origin.x+2*initialFrame.size.width;
    ball.frame=initialFrame;
    
    
    CGRect reflectionFrame=ballsReflection.frame;
    reflectionFrame.origin.x=reflectionFrame.origin.x+2*reflectionFrame.size.width;
    ballsReflection.frame=reflectionFrame;
    
    ball.alpha=newAlpha;
    ballsReflection.alpha=newAlpha;
    
}

-(UIColor *)getRandomColor{
    CGFloat redLevel    = rand() / (float) RAND_MAX;
    CGFloat greenLevel  = rand() / (float) RAND_MAX;
    CGFloat blueLevel   = rand() / (float) RAND_MAX;
    
    UIColor *randomBallColor = [UIColor colorWithRed: redLevel
                                               green: greenLevel
                                                blue: blueLevel
                                               alpha: 1.0];
    return randomBallColor;
}

#pragma mark- Public Methods
- (void)startAnimating
{
    if (_animating)
    {
        return;
    }
    _animating = YES;
    _shouldAnimate = YES;
    
    [self startRunningLeftBall];
}

- (void)stopAnimating
{
    if (!_animating)
    {
        return;
    }
    
    _animating = NO;
    _shouldAnimate = NO;
    
    
    
    if (_hidesWhenStopped)
    {
        
        // fade out to disappear
        
        [self removeFromSuperview];
    }
}

- (BOOL)isAnimating
{
    return _animating;
}


@end

