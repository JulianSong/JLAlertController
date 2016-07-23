//
//  JLAlertController.m
//  Pods
//
//  Created by Julian.Song on 16/7/23.
//
//

#import "JLAlertController.h"
#define JLAlertBlue  [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f]
#define JLAlertDark  [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]
#define JLAlertRed   [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0f]

@interface JLAlertController()
@end

@implementation JLAlertController

- (instancetype) initAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _titleLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,44)];
        _titleLabel.textColor         = JLAlertDark;
        _titleLabel.textAlignment     = NSTextAlignmentCenter;
        _titleLabel.font              = [UIFont boldSystemFontOfSize:18];
        _titleLabel.backgroundColor   = [UIColor clearColor];
        _titleLabel.text              = title;

        _messageLabel                 = [[UILabel alloc] init];
        _messageLabel.textColor       = JLAlertDark;
        _messageLabel.font            = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment   = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines   = 0;
        _messageLabel.text            = message;

        _actions                      = [[NSMutableArray alloc] init];
        _actionButtons                = [[NSMutableArray alloc] init];
        _actionHandles                = [[NSMutableDictionary alloc] init];
        _customViews                  = [[NSMutableArray alloc] init];
        _totalViews                   = [[NSMutableArray alloc] init];

        if (message != nil) {
            [_totalViews addObject:_messageLabel];
        }

        _footerView                   = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,44)];
        _popTransitioning             = [[JLPopTransitioning alloc] init];

        self.modalTransitionStyle     = UIModalPresentationCustom;
        self.modalPresentationStyle   = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate    = _popTransitioning;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtons];
    
    self.tableView.scrollEnabled   = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.tableHeaderView = self.titleLabel;
    self.tableView.separatorInset  = UIEdgeInsetsZero;
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];

    self.view.backgroundColor      = [UIColor whiteColor];
    UIBlurEffect *blur             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _visualEffectView              = [[UIVisualEffectView alloc] initWithEffect:blur];
    _visualEffectView.frame        = self.view.bounds;
    [self.view insertSubview:self.visualEffectView atIndex:0];
}

- (void)addCustomView:(UIView *)customView
{
    [self.customViews addObject:customView];
    [self.totalViews addObject:customView];
}

- (void)addAction:(NSString *)actionName
        withStyle:(UIAlertActionStyle)actionStyle
        andHandle:(JLAlertControllerActionHandle) handle
{
    [self.actions addObject:actionName];
    [self.actionHandles setObject:[handle copy] forKey:actionName];
    UIButton *actionButton = [[UIButton alloc] init];
    UIColor *titleColor;
    if (actionStyle == UIAlertActionStyleDefault) {
        titleColor = JLAlertDark;
    }else if(actionStyle == UIAlertActionStyleCancel){
        titleColor = JLAlertBlue;
    }else{
        titleColor = JLAlertRed;
    }
    [actionButton setTitle:actionName forState:UIControlStateNormal];
    [actionButton setTitleColor:titleColor forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    actionButton.backgroundColor = [UIColor clearColor];
    [self.actionButtons addObject:actionButton];
}

- (void)setupButtons
{
    if (self.isButtonSetup) {
        return;
    }
    if (self.actionButtons.count > 2) {
        [self.totalViews addObjectsFromArray:self.actionButtons];
        return;
    }else{
        [self.totalViews addObject:self.footerView];
    }
    [self setButtonSetup:YES];
}

- (void)reloadButtons
{
    NSArray * subViews = [NSArray arrayWithArray:self.footerView.subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }

    CGFloat width = self.view.bounds.size.width / self.actions.count;
    int index = 0;
    for (UIButton *actionButton in self.actionButtons) {
        CGFloat x = index *(width +0.5);
        if (index != 0) {
            UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(x,0,0.5,self.footerView.bounds.size.height)];
            dividingLine.backgroundColor = self.tableView.separatorColor;
            [self.footerView addSubview:dividingLine];
        }
        actionButton.frame = CGRectMake(x,0.5,width,self.footerView.bounds.size.height-0.5);
        [self.footerView addSubview:actionButton];
        index ++;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalViews.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_IDENTIFIER];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    UIView *view = [self.totalViews objectAtIndex:indexPath.row];
    if (view == self.messageLabel) {
        view.frame =  CGRectMake(15,0,self.view.frame.size.width -30 ,[self heightForString:self.messageLabel.text] + 10);
    }else if([self.customViews containsObject:view]) {
        view.frame = CGRectMake(0,0,self.view.bounds.size.width,view.frame.size.height);
    }else if([self.actionButtons containsObject:view]) {
        view.frame = CGRectMake(0,0,self.view.bounds.size.width,44);
    }else if(view == self.footerView) {
        view.frame = CGRectMake(0,0,self.view.bounds.size.width,44);
        [self reloadButtons];
    }
    
    [cell.contentView addSubview:view];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *view = [self.totalViews objectAtIndex:indexPath.row];
    CGFloat height;
    if (view == self.messageLabel) {
        height = [self heightForString:self.messageLabel.text] + 10;
    }else if([self.customViews containsObject:view]) {
        height = view.frame.size.height;
    }else if([self.actionButtons containsObject:view]) {
        height = 44;
    }else if(view == self.footerView) {
        height = 44;
    }else{
        height = 44;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)doAction:(UIButton *)button
{
    JLAlertControllerActionHandle handle = [self.actionHandles objectForKey:button.currentTitle];
    handle(button.currentTitle);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSDictionary *)stringAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    return @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:14],};
}

- (CGFloat) heightForString:(NSString *)string
{
    CGRect drowRect = [string boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 30,CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:[self stringAttributes]
                                           context:nil];
    return drowRect.size.height;
}

@end
