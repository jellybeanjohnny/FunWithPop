//
//  RABouncyButton.m
//  RidiculousAnimals
//
//  Created by Matt Amerige on 10/1/14.
//  Copyright (c) 2014 Matt Amerige. All rights reserved.
//

#import "RABouncyButton.h"
#import <POP/POP.h>

@implementation RABouncyButton

- (instancetype)init
{
  if (!(self = [super init])) {
    return nil;
  }
  [self _setupTouchEvents];
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (!(self = [super initWithCoder:aDecoder])) {
    return nil;
  }
  [self _setupTouchEvents];
  
  return self;
}

#pragma mark - Setup
- (void)_setupAppearance
{
  self.layer.cornerRadius = 5.0;
  
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self _setupAppearance];
}

- (void)_setupTouchEvents
{
  [self addTarget:self
           action:@selector(_touchDownHandler:)
  forControlEvents:UIControlEventTouchDown];
  
  [self addTarget:self
           action:@selector(_touchUpInsideHandler:)
 forControlEvents:UIControlEventTouchUpInside];
  
  [self addTarget:self
           action:@selector(_draggedOnExitHandler:)
 forControlEvents:UIControlEventTouchDragExit];

}

#pragma mark - Handling Touch Events
/**
 * Button pressed down. Button shrinks down
 */
- (void)_touchDownHandler:(RABouncyButton *)sender
{
   [self _scaleButtonToSize:CGPointMake(0.85, 0.90) bounce:0 speed:20];
}

/**
 * Button released. Button springs back to normal
 */
- (void)_touchUpInsideHandler:(RABouncyButton *)sender
{
  [self _scaleButtonToSize:CGPointMake(1.0, 1.0) bounce:20 speed:20];
}

/**
 * Button is dragged after being pressed. Button springs back to normal
 */
- (void)_draggedOnExitHandler:(RABouncyButton *)sender
{
  [self _touchUpInsideHandler:sender];
}

#pragma mark - Animations
- (void)_scaleButtonToSize:(CGPoint)scaledPoint bounce:(CGFloat)bounce speed:(CGFloat)speed
{
  POPSpringAnimation *anim = [self pop_animationForKey:@"CompressButton"];
  if (anim) {
    anim.toValue = [NSValue valueWithCGPoint:scaledPoint];
    anim.springBounciness = bounce;
    anim.springSpeed = speed;
  }
  else {
    POPSpringAnimation *compressAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    compressAnimation.toValue = [NSValue valueWithCGPoint:scaledPoint];
    compressAnimation.springBounciness = bounce;
    compressAnimation.springSpeed = speed;
    [self.layer pop_addAnimation:compressAnimation forKey:@"CompressButton"];
  }
}


@end
