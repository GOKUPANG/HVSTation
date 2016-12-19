//
//  ErrorController.m
//  HV station
//
//  Created by sswukang on 2016/10/25.
//  Copyright © 2016年 sswukang. All rights reserved.
//

#import "ErrorController.h"
#import "ErrorView.h"

@interface ErrorController ()

@end

@implementation ErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    ErrorView *errorView = [[ErrorView alloc] initWithFrame:self.view.bounds];
    self.view = errorView;
}



@end
