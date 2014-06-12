//
//  DropDownMenuController.m
//  DropDownMenu
//
//  Created by Kevin Chen on 6/11/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "DropDownMenuController.h"
#import "UIBarButtonItem+Frame.h"

NSString *const DropDownMenuTitleKey = @"DropDownMenuTitleKey";

const CGFloat DropDownMenuMinWidth = 120.0f;

@interface DropDownMenuController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *menu;
@property (nonatomic, strong) id trigger;

@end

@implementation DropDownMenuController {
    BOOL _isShow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"-[DropDownMenuController viewDidLoad]");
    
    self.view.frame = self.parentViewController.view.frame;
    self.view.alpha = 0.0;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
     
    
    if (self.menu == nil) {
        self.menu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DropDownMenuMinWidth, DropDownMenuMinWidth) style:UITableViewStylePlain];
        self.menu.dataSource = self;
        self.menu.delegate = self;
        self.menu.scrollEnabled = NO;
        
        [self.view addSubview:self.menu];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [tapGesture setCancelsTouchesInView:NO];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOrientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)show:(id)sender {
    self.trigger = sender;
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [self showFromBarButtomItem:sender];
    } else if ([sender isKindOfClass:[UIView class]]) {
        [self showFromRect:((UIView *)sender).frame];
    }

}

- (CGRect)menuFrameFromRect:(CGRect)rect {
    
    
    CGRect menuFrame = self.menu.frame;
    
    CGFloat fromRectMidX = rect.origin.x + rect.size.width / 2;
    CGFloat menuWidth = menuFrame.size.width;
    CGFloat halfMenuWidth = menuWidth / 2;
    
    CGFloat menuX = 0;
    
    if ((fromRectMidX - halfMenuWidth) < 0) {
        menuX = 0;
    } else if ((fromRectMidX + halfMenuWidth) > self.view.frame.size.width) {
        menuX = self.view.frame.size.width - menuFrame.size.width;
    } else {
        menuX = fromRectMidX - halfMenuWidth;
    }
    
    CGFloat menuY = 0;
    if ([self.trigger isKindOfClass:[UIBarButtonItem class]]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            menuY = 0;
        } else {
            menuY = rect.origin.y + rect.size.height;
        }
    } else {
        menuY = rect.origin.y + rect.size.height;
    }
    
    
    CGFloat menuHeight = menuFrame.size.height;
    
    if ((menuY + menuHeight) > self.view.frame.size.height) {
        self.menu.scrollEnabled = YES;
        menuHeight = self.view.frame.size.height - menuY;
    }
    
    menuFrame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    
    return menuFrame;
}

- (void)showFromRect:(CGRect)rect {
    
    if (self.parentViewController == nil) {
        NSLog(@"Please addChildViewController first at the UIViewController which wanna show DropDownMenu");
        return;
    }
    
    [self.parentViewController.view addSubview:self.view];
    
    [self.menu reloadData];
    self.menu.frame = CGRectMake(0, 0, [self maxTableViewWidth], self.menu.contentSize.height);
    
    CGRect menuFrame = [self menuFrameFromRect:rect];
    
    
    self.menu.alpha = 0.0;
    self.menu.frame = CGRectMake(menuFrame.origin.x,
                                 menuFrame.origin.y - menuFrame.size.height,
                                 menuFrame.size.width,
                                 menuFrame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.menu.frame = menuFrame;
        self.view.alpha = 1.0;
        self.menu.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        _isShow = YES;
    }];
    
    [UIView commitAnimations];

}

- (void)showFromBarButtomItem:(UIBarButtonItem *)item{
    
    UIView *viewInItem = [item viewInItem];
    UIView *superview = [viewInItem superview];
    
    CGRect itemFrame = viewInItem.frame;
    CGRect superviewFrame = superview.frame;
    
    CGRect frame = CGRectMake(itemFrame.origin.x,
                              superviewFrame.origin.y,
                              itemFrame.size.height,
                              superviewFrame.size.height);
    
    [self showFromRect:frame];
    
}

- (void)hide {
    
    CGRect menuFrame = self.menu.frame;
    
    [UIView animateWithDuration:0.4 animations:^{        
        self.view.alpha = 0.0;
        self.menu.alpha = 0.0;
        self.menu.frame = CGRectMake(menuFrame.origin.x,
                                     menuFrame.origin.y - menuFrame.size.height,
                                     menuFrame.size.width,
                                     menuFrame.size.height);
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        _isShow = NO;
        self.trigger = nil;
    }];
    
    [UIView commitAnimations];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapLocation = [tapGesture locationInView:self.view];
    if (!CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden) {
        [self hide];
    }
}

#pragma mark -

- (BOOL)isShow {
    return _isShow;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MenuItemCell = @"MenuItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuItemCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuItemCell];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:DropDownMenuTitleKey];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *menuItem = [self.menuItems objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectMenuItem:atIndexPath:)]) {
        [self.delegate menu:self didSelectMenuItem:menuItem atIndexPath:indexPath];
    }
    
    [self hide];
}

- (CGFloat)maxTableViewWidth {
    CGFloat maxWidth = 0.0;
    CGSize maxSize = CGSizeMake(self.view.frame.size.width, 99999);
    CGFloat indent = 15;
    for (NSDictionary *menuItem in self.menuItems) {
        
        NSString *text = [menuItem objectForKey:DropDownMenuTitleKey];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15.0f]
                           constrainedToSize:maxSize];
        
        maxWidth = MAX(maxWidth, textSize.width + 2 * indent);

    }
    
    return MAX(DropDownMenuMinWidth, maxWidth);
}

#pragma mark - 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.menu]) {
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)handleOrientationDidChangeNotification:(NSNotification *)notification {
    
    self.view.frame = self.parentViewController.view.frame;
    
    if (self.menu) {
        CGRect frame = CGRectZero;
        if ([self.trigger isKindOfClass:[UIBarButtonItem class]]) {
            UIView *viewInItem = [self.trigger viewInItem];
            UIView *superview = [viewInItem superview];
            
            CGRect itemFrame = viewInItem.frame;
            CGRect superviewFrame = superview.frame;
            frame = CGRectMake(itemFrame.origin.x,
                               superviewFrame.origin.y,
                               itemFrame.size.height,
                               superviewFrame.size.height);

        } else if ([self.trigger isKindOfClass:[UIView class]]) {
            frame = ((UIView *)self.trigger).frame;
        }
        
        self.menu.frame = [self menuFrameFromRect:frame];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
