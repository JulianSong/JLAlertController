//
//  JLFlipTransitioning.m
//  Pods
//
//  Created by Julian.Song on 16/7/21.
//
//

#import "JLFlipTransitioning.h"

@implementation JLFlipTransitioning

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.containerView   = [transitionContext containerView];
    if (self.backButton == nil) {
        self.backButton = [[UIButton alloc] init];
        self.backButton.frame = self.containerView.bounds;
        self.backButton.alpha = 0;
        self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.backButton addTarget:self action:@selector(dismissPresentedController) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self.containerView addSubview:self.backButton];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect toFrame;
    if(!self.isReverse){
        self.presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        self.presentedController.view.frame = CGRectMake(- 280,0,280,self.containerView.bounds.size.height);
        toFrame = CGRectMake(0,0,280,self.containerView.bounds.size.height);
        [self.containerView addSubview:self.presentedController.view];
    }else{
        self.presentedController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        toFrame = CGRectMake(-280,0,280,self.containerView.bounds.size.height);
        [self.containerView addSubview:self.presentedController.view];
    }
    
    CGFloat toAlpha = self.isReverse ? 0 :1 ;
    
    [UIView animateWithDuration:duration animations:^{
        self.presentedController.view.frame = toFrame;
        self.backButton.alpha = toAlpha;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        if (!self.reverse) {
            [self.containerView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        }else{
            [self.containerView removeObserver:self forKeyPath:@"frame"];
        }
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
    }
}

- (void)dismissPresentedController
{
    [self.presentedController dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.reverse = false;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.reverse =  true;
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.backButton.frame = self.containerView.bounds;
        if (self.isReverse) {
            self.presentedController.view.frame  = CGRectMake(-280,0,280,self.containerView.bounds.size.height);
        }else{
            self.presentedController.view.frame  = CGRectMake(0,0,280,self.containerView.bounds.size.height);
        }
    }
}
@end


@interface MDFlipInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController:(UIViewController*)viewController;

@end

@interface MDFlipInteractiveTransition()
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@end

@implementation MDFlipInteractiveTransition
-(void)wireToViewController:(UIViewController *)viewController
{
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat x = translation.x - (gestureRecognizer.view.superview.bounds.size.width - 300);
    NSLog(@"x is %f",x);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            self.interacting = YES;
            [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. Calculate the percentage of guesture
            CGFloat fraction = x / gestureRecognizer.view.superview.bounds.size.width;
            //Limit it between 0 and 1
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end

