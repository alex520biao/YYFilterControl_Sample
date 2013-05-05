//
//  ViewController.m
//  SEFilterControl_Sample
//
//  Created by Shady A. Elyaski on 6/15/12.
//  Copyright (c) 2012 Shady Elyaski. All rights reserved.
//

#import "ViewController.h"
#import "YYFilterControl.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];

    YYFilterControl *filter = [[YYFilterControl alloc]initWithTitles:[NSArray arrayWithObjects:@"Articles", @"News", @"Updates", @"Featured", @"Newest", @"Oldest",@"AKKAK", nil]];
    filter.frame=CGRectMake(50, 20, filter.frame.size.width, filter.frame.size.height);//修改位置
    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:filter];
    [filter release];    
}

-(IBAction)filterValueChanged:(YYFilterControl *) sender{
    [selectedIndex setText:[NSString stringWithFormat:@"%d", sender.selectedIndex]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [selectedIndex release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSelectedIndex:nil];
    [super viewDidUnload];
}
@end
