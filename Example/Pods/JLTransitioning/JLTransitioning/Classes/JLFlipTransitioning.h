//
//  JLFlipTransitioning.h
//  Pods
//
//  Created by Julian.Song on 16/7/21.
//
//

#import <Foundation/Foundation.h>

@interface JLFlipTransitioning : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign,getter=isReverse)BOOL reverse;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,weak)UIViewController *presentedController;
@property(nonatomic,weak)UIView *containerView;
@end
