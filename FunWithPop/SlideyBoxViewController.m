//
//  SlideyBoxViewController.m
//  FunWithPop
//
//  Created by Matt Amerige on 6/19/16.
//  Copyright © 2016 Wubbyland. All rights reserved.
//

#import "SlideyBoxViewController.h"
#import <POP/POP.h>

@interface SlideyBoxViewController ()

@property (weak, nonatomic) IBOutlet UIView *redSquare;

@property (nonatomic) CGPoint redSquareCurrentLocation;
@property (nonatomic) CGRect redSquareOriginalFrame;

@end

@implementation SlideyBoxViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self _addGestures];
}

- (void)_addGestures
{
	// Dragging
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
	[self.redSquare addGestureRecognizer:panGesture];
}

- (void)_handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
	
	if (panGesture.state == UIGestureRecognizerStateBegan) {
		self.redSquareCurrentLocation = [panGesture locationInView:self.view];
	}
	else if (panGesture.state == UIGestureRecognizerStateChanged) {
		
		CGPoint newLocation = [panGesture locationInView:self.view];
		CGFloat dx = newLocation.x - self.redSquareCurrentLocation.x;
		CGFloat dy = newLocation.y - self.redSquareCurrentLocation.y;
		self.redSquare.frame = CGRectMake(panGesture.view.frame.origin.x + dx,
																			panGesture.view.frame.origin.y + dy,
																			panGesture.view.frame.size.width,
																			panGesture.view.frame.size.height);
		self.redSquareCurrentLocation = newLocation;
		
	}
	else if (panGesture.state == UIGestureRecognizerStateEnded) {
		[self _slideAnimationForVelocity:[panGesture velocityInView:self.view]];
	}
}

- (void)_slideAnimationForVelocity:(CGPoint)velocity
{
	POPDecayAnimation *slide = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
	slide.velocity = [NSValue valueWithCGPoint:velocity];
	slide.deceleration = .99;
		
	[self.redSquare.layer pop_addAnimation:slide forKey:@"Slide"];
}

- (void)_returnToOriginAnimation
{
	POPSpringAnimation *returnAnimation = [self.redSquare pop_animationForKey:@"ReturnAnimation"];
	if (returnAnimation) {
		returnAnimation.toValue = [NSValue valueWithCGRect:self.redSquareOriginalFrame];
	}
	else {
		returnAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
		returnAnimation.toValue = [NSValue valueWithCGRect:self.redSquareOriginalFrame];
		returnAnimation.springSpeed = 20.0;
		returnAnimation.springBounciness = 15.0;
		[self.redSquare pop_addAnimation:returnAnimation forKey:@"ReturnAnimation"];
	}
}

@end
