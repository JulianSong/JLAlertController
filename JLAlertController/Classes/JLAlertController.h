//
//  JLAlertController.h
//  Pods
//
//  Created by Julian.Song on 16/7/23.
//
//

#import <UIKit/UIKit.h>
#import <JLTransitioning/JLTransitioning.h>
static NSString * const CELL_REUSE_IDENTIFIER = @"CELL_REUSE_IDENTIFIER";
typedef void (^JLAlertControllerActionHandle)(NSString *actonName);
@interface JLAlertController : UITableViewController
@property (nonatomic,strong) UILabel                      * titleLabel;
@property (nonatomic,strong) UILabel                      * messageLabel;
@property (nonatomic,strong) JLPopTransitioning           * popTransitioning;
@property (nonatomic,strong) NSMutableArray               * actions;
@property (nonatomic,strong) NSMutableArray               * actionButtons;
@property (nonatomic,strong) NSMutableDictionary          * actionHandles;
@property (nonatomic,strong) NSMutableArray               * customViews;
@property (nonatomic,strong) NSMutableArray               * totalViews;
@property (nonatomic,strong) UIView                       * footerView;
@property (nonatomic,strong) UIVisualEffectView           * visualEffectView;
@property (nonatomic,assign,getter = isButtonSetup)BOOL buttonSetup;

- (instancetype) initAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)addCustomView:(UIView *)customView;

- (void)addAction:(NSString *)actionName
        withStyle:(UIAlertActionStyle)actionStyle
        andHandle:(JLAlertControllerActionHandle) handle;
@end