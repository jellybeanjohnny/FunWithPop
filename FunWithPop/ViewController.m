//
//  ViewController.m
//  FunWithPop
//
//  Created by Matt Amerige on 6/13/16.
//  Copyright © 2016 Wubbyland. All rights reserved.
//

#import "ViewController.h"
#import <POP/POP.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *blueSquare;
@property (weak, nonatomic) IBOutlet UIView *redSquare;

@property (nonatomic) CGPoint redSquareCurrentLocation;
@property (nonatomic) CGRect redSquareOriginalFrame;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Adding gestures
	[self _addGestures];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.redSquareOriginalFrame = self.redSquare.frame;
}

- (void)_addGestures
{
	// Pinching
	UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
																																												action:@selector(_animateScale:)];
	[self.blueSquare addGestureRecognizer:pinchRecognizer];
	
	// Dragging
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
	[self.redSquare addGestureRecognizer:panGesture];
}


- (void)_animateScale:(UIPinchGestureRecognizer *)pinchGesture
{
	// Check to see if there's already an animation for the size key
	POPBasicAnimation *scaleAnim = [self.blueSquare.layer pop_animationForKey:@"LayerScaleXY"];
	if (scaleAnim) {
		// update values
		scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(pinchGesture.scale, pinchGesture.scale)];
	}
	else {
		// Create a new animation
		scaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
		scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(pinchGesture.scale, pinchGesture.scale)];
		[self.blueSquare.layer pop_addAnimation:scaleAnim forKey:@"LayerScaleXY"];
	}
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
	// Decay
	POPDecayAnimation *slide = [self.redSquare.layer pop_animationForKey:@"Slide"];
	if (slide) {
		slide.velocity = [NSValue valueWithCGPoint:velocity];
	}
	else {
		slide = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
		slide.velocity = [NSValue valueWithCGPoint:velocity];
		slide.deceleration = .99;
		
		[self.redSquare.layer pop_addAnimation:slide forKey:@"Slide"];
	}
	
	slide.completionBlock = ^(POPAnimation *anim, BOOL completed) {
		// When the slide animation is completed, animate back to the original location
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
	};
}

@end
