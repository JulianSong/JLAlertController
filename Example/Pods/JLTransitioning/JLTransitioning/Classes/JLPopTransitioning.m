//
//  JLPopTransitioning.m
//  Pods
//
//  Created by Julian.Song on 16/7/21.
//
//

#import "JLPopTransitioning.h"

@implementation JLPopTransitioning

- (instancetype) init
{
    self = [super init];
    if (self) {
        _backButton = [[UIButton alloc] init];
        _backButton.alpha = 0;
        _backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_backButton addTarget:self action:@selector(dismissPresentedController) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrHideNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.containerView   = [transitionContext containerView];
    self.backButton.frame = self.containerView.bounds;
    
    [self.containerView addSubview:self.backButton];
    
    CGAffineTransform fromTransform,toTransform;
    CGFloat fromAlpha,toAlpha;
    CGPoint center ;
    
    if(!self.isReverse){
        self.presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        center = self.containerView.center;
        fromTransform = CGAffineTransformMakeScale(0.9,0.9);
        toTransform = CGAffineTransformIdentity;
        fromAlpha = 0;
        toAlpha = 1;
    }else{
        self.presentedController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        center = CGPointMake(self.presentedController.view.center.x, self.presentedController.view.center.y) ;
        toTransform = CGAffineTransformMakeScale(0.9,0.9);
        fromTransform = CGAffineTransformIdentity;
        fromAlpha = 1;
        toAlpha = 0;
    }
    
    self.presentedController.view.layer.cornerRadius = 8.0f;
    [self.containerView addSubview:self.presentedController.view];
    id view = self.presentedController.view;
    
    CGFloat height;
    if ([view isKindOfClass:[UIScrollView class]]) {
        height = [view contentSize].height;
    }else{
        height = [view frame].size.height;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (height == 0 || height > 400) {
            height = 400;
        }
        self.presentedController.view.frame = CGRectMake(0,0,self.containerView.frame.size.width - 50,height);
    }else{
        if (height == 0 || height > 500) {
            height = 500;
        }
        self.presentedController.view.frame = CGRectMake(0,0,500,height);
    }
    
    self.presentedController.view.alpha = fromAlpha;
    self.presentedController.view.transform = fromTransform;
    self.presentedController.view.center = center;
    
    self.popFrame = self.presentedController.view.frame;
    self.popCenter = center;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        self.backButton.alpha = toAlpha;
        self.presentedController.view.alpha = toAlpha;
        self.presentedController.view.transform = toTransform;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        if (!self.reverse) {
            [self.containerView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        }else{
            [self.containerView removeObserver:self forKeyPath:@"frame"];
        }
    }];
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

- (void)keyboardWillShowOrHideNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect presentedFrame = self.presentedController.view.frame;
    BOOL isShowNotification = [notification.name isEqualToString:UIKeyboardWillShowNotification];
//    CGFloat keyboardHeight = isShowNotification ? CGRectGetHeight(keyboardFrame) : 0.0;
    if (isShowNotification) {
        if (presentedFrame.origin.y + presentedFrame.size.height > keyboardFrame.origin.y) {
            self.presentedController.view.frame = CGRectMake(presentedFrame.origin.x,keyboardFrame.origin.y - presentedFrame.size.height - 10,presentedFrame.size.width,presentedFrame.size.height);
        }
    }else{
        self.presentedController.view.center = self.presentedController.view.superview.center;
    }
    self.popFrame = self.presentedController.view.frame;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.backButton.frame = self.containerView.bounds;
        self.presentedController.view.frame  = self.popFrame;
        self.presentedController.view.center = self.containerView.center;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

