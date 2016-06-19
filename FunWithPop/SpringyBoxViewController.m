//
//  SpringyBoxViewController.m
//  FunWithPop
//
//  Created by Matt Amerige on 6/19/16.
//  Copyright © 2016 Wubbyland. All rights reserved.
//

#import "SpringyBoxViewController.h"
#import <POP/POP.h>

@interface SpringyBoxViewController ()

@property (weak, nonatomic) IBOutlet UIView *blueSquare;
@property (nonatomic) CGPoint blueSquareCurrentLocation;
@property (nonatomic) CGRect blueSquareOriginalFrame;

@end

@implementation SpringyBoxViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self _addGestures];
}

- (void)viewDidAppear:(BOOL)animated
{
	self.blueSquareOriginalFrame = self.blueSquare.frame;
}

- (void)_addGestures
{
	// Dragging
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
	[self.blueSquare addGestureRecognizer:panGesture];
}

- (void)_handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
	
	if (panGesture.state == UIGestureRecognizerStateBegan) {
		self.blueSquareCurrentLocation = [panGesture locationInView:self.view];
	}
	else if (panGesture.state == UIGestureRecognizerStateChanged) {
		
		CGPoint newLocation = [panGesture locationInView:self.view];
		CGFloat dx = newLocation.x - self.blueSquareCurrentLocation.x;
		CGFloat dy = newLocation.y - self.blueSquareCurrentLocation.y;
		self.blueSquare.frame = CGRectMake(panGesture.view.frame.origin.x + dx,
																			panGesture.view.frame.origin.y + dy,
																			panGesture.view.frame.size.width,
																			panGesture.view.frame.size.height);
		self.blueSquareCurrentLocation = newLocation;
		
	}
	else if (panGesture.state == UIGestureRecognizerStateEnded) {
		[self _returnToOriginAnimation];
	}
}

- (void)_returnToOriginAnimation
{
	POPSpringAnimation *returnAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
	
	returnAnimation.toValue = [NSValue valueWithCGRect:self.blueSquareOriginalFrame];
	returnAnimation.springSpeed = 20.0;
	returnAnimation.springBounciness = 15.0;
	
	[self.blueSquare pop_addAnimation:returnAnimation forKey:@"ReturnAnimation"];
}


@end
