//
//  SEFilterKnob.m
//  SEFilterControl_Test
//
//  Created by Shady A. Elyaski on 6/15/12.
//  Copyright (c) 2012 mash, ltd. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "YYFilterKnob.h"
#define KNOB_IMAGE @"dot_selected.png"

@implementation YYFilterKnob
@synthesize handlerColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        // Initialization code
        [self setHandlerColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1]];
    }
    return self;
}

-(void) setHandlerColor:(UIColor *)hc{
    [handlerColor release];
    handlerColor = nil;
    
    handlerColor = [hc retain];
    [self setNeedsDisplay];//重绘
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage*img =[UIImage imageNamed:KNOB_IMAGE];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
    
    //重绘内容
}

-(void) dealloc{
    [handlerColor release];
    [super dealloc];
}

@end
