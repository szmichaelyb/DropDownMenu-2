//
//  ViewController.m
//  DropDownMenu
//
//  Created by Kevin Chen on 6/11/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "ViewController.h"
#import "IonIcons.h"
#import "DropDownMenuController.h"

@interface ViewController () <DropDownMenuDelegate>

@property (nonatomic, strong) DropDownMenuController *menu;

@end

@implementation ViewController

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
    
    UIImage *image = [IonIcons imageWithIcon:icon_navicon_round size:30.0f color:[UIColor grayColor]];    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleShowHideMenu:)];
    
    self.menu = [[DropDownMenuController alloc] init];
    self.menu.menuItems = @[
                            @{DropDownMenuTitleKey : @"iPhone"},
                            @{DropDownMenuTitleKey : @"iPad"},
                            @{DropDownMenuTitleKey : @"MacBook Air"},
                            @{DropDownMenuTitleKey : @"MacBook Pro"},
                            @{DropDownMenuTitleKey : @"MacBook Pro(Retina)"},
                            @{DropDownMenuTitleKey : @"Mac Mini"},
                            @{DropDownMenuTitleKey : @"Mac Pro"}];

    [self addChildViewController:self.menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleShowHideMenu:(id)sender {
    if ([self.menu isShow]) {
        [self.menu hide];
    } else {
        [self.menu show:sender];
    }
}

- (IBAction)handleDropDownMenuButton:(id)sender {
    if ([self.menu isShow]) {
        [self.menu hide];
    } else {
        [self.menu show:sender];
    }}

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
