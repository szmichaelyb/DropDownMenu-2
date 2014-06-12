//
//  UIBarButtonItem+Frame.m
//  DropDownMenu
//
//  Created by Kevin Chen on 6/11/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "UIBarButtonItem+Frame.h"

@implementation UIBarButtonItem (Frame)

- (CGRect)frame {
    UIView *view = [self performSelector:@selector(view)];
    if (view) {
        return view.frame;
    } else {
        return CGRectZero;
    }
}

- (UIView *)viewInItem; {
    return [self performSelector:@selector(view)];
}

@end
