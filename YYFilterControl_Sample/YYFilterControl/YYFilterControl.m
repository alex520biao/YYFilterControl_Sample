//
//  SEFilterControl.m
//  SEFilterControl_Test
//
//  Created by alex on 6/13/12.
//  Copyright (c) 2012 mash, ltd. All rights reserved.

#import "YYFilterControl.h"

//#define LEFT_OFFSET 25
//#define RIGHT_OFFSET 25


#define TITLE_SELECTED_DISTANCE 5
#define TITLE_FADE_ALPHA .5f

#define TITLE_FONT [UIFont fontWithName:@"Optima" size:13]
#define TITLE_FONT_SELECTED [UIFont fontWithName:@"Optima" size:13]

#define TITLE_SHADOW_COLOR [UIColor lightGrayColor]
#define TITLE_COLOR [UIColor blackColor]

#define LABEL_WIDTH 50  //文本宽度
#define STEP_LENGTH 40  //默认步长


@interface YYFilterControl (){
    YYFilterKnob *handler;
    CGPoint diffPoint;
    NSArray *titlesArr;
}

@end

@implementation YYFilterControl
@synthesize selectedIndex;

-(id) initWithTitles:(NSArray *) titles{
    CGFloat height=titles.count*STEP_LENGTH;//高度
    CGRect frame=CGRectMake(0, 0, LABEL_WIDTH+60, height);
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        titlesArr = [[NSArray alloc] initWithArray:titles];
                        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [self addGestureRecognizer:gest];
        [gest release];
        
        handler = [[YYFilterKnob buttonWithType:UIButtonTypeCustom] retain];
        [handler setFrame:CGRectMake(0, 0, 20, 20)];
        [handler setCenter:CGPointMake([self getXCenterPoint], [self getYCenterPointForIndex:0])];
        [handler setAdjustsImageWhenHighlighted:NO];
        [handler addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        [handler addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [handler addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        [self addSubview:handler];
        
        for (int i = 0; i < titlesArr.count; i++) {
            NSString *title = [titlesArr objectAtIndex:i];
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, [self getYCenterPointForIndex:i]-STEP_LENGTH/2,LABEL_WIDTH,STEP_LENGTH)];
            [lbl setText:title];
            [lbl setFont:TITLE_FONT];
            [lbl setShadowColor:TITLE_SHADOW_COLOR];
            [lbl setTextColor:TITLE_COLOR];
            [lbl setLineBreakMode:UILineBreakModeTailTruncation];
            //[lbl setAdjustsFontSizeToFitWidth:YES];
            [lbl setAdjustsFontSizeToFitWidth:NO];
            //[lbl setMinimumFontSize:8];
            lbl.numberOfLines=1;//1行
            [lbl setTextAlignment:UITextAlignmentLeft];
            [lbl setShadowOffset:CGSizeMake(0, 1)];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTag:i+50];
            
            if (i) {
                [lbl setAlpha:TITLE_FADE_ALPHA];
            }
            
            [self addSubview:lbl];
            [lbl release];
        }
    }
    return self;
}

-(void)dealloc{
    [handler removeTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [handler removeTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [handler removeTarget:self action:@selector(TouchMove:withEvent: ) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
    [handler release];
    [titlesArr release];
    [super dealloc];
}


-(void)drawRect:(CGRect)rect{
    //绘制滑杆
    UIImage *bgImg=[UIImage imageNamed:@"slider.png"];
    UIImage *img1=[bgImg stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    UIImageView *imgView=[[UIImageView alloc] initWithImage:img1];
    imgView.frame=CGRectMake(0, 0, 10,STEP_LENGTH*(titlesArr.count-1));
    
    CGFloat xCenterPoint=[self getXCenterPoint];
    [imgView.image drawInRect:CGRectMake(xCenterPoint-imgView.frame.size.width/2,STEP_LENGTH/2, imgView.frame.size.width,STEP_LENGTH*(titlesArr.count-1))];
    
    //绘制step点
    for (int i = 0; i < titlesArr.count; i++) {
        CGFloat centerY=[self getYCenterPointForIndex:i];
        CGFloat centerX=[self getXCenterPoint];        
        
        UIImage*img =[UIImage imageNamed:@"dot.png"];//10,10
        [img drawInRect:CGRectMake(centerX-10/2,centerY-10/2,10, 10)];
    }
}

-(void) setSelectedIndex:(int)index{
    selectedIndex = index;
    
    [self updateView_selectedIndex];//根据selectedIndex改变界面
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];//UIControl对象发送UIControlEventValueChanged事件消息
}

#pragma mark updateView
//selectedIndex导致的界面更新
-(void)updateView_selectedIndex{
    //selectedIndex导致的titles更新
    [self updateView_selectedIndex_titles];
    //selectedIndex导致的handler更新
    [self updateView_selectedIndex_handler];
}

-(void)updateView_selectedIndex_titles{
    [self updateView_selectedIndex_titles:selectedIndex];
}

-(void)updateView_selectedIndex_titles:(int)index{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (i == index) {
            [lbl setCenter:CGPointMake(lbl.center.x, lbl.center.y)];
            lbl.font=TITLE_FONT_SELECTED;
            [lbl setAlpha:1];
        }else{
            [lbl setCenter:CGPointMake(lbl.center.x, lbl.center.y)];
            lbl.font=TITLE_FONT;
            [lbl setAlpha:TITLE_FADE_ALPHA];
        }
        [UIView commitAnimations];
    }
}




-(void) updateView_selectedIndex_handler{    
    [UIView beginAnimations:nil context:nil];
    handler.center=CGPointMake([self getXCenterPoint], [self getYCenterPointForIndex:selectedIndex]);
    [UIView commitAnimations];
}

#pragma mark custom
//当前UIControl控件上的CGPoint点转换为index
-(int)getIndexInPoint:(CGPoint)pnt{
    return round((pnt.y-STEP_LENGTH/2)/STEP_LENGTH);
}

//滑杆的X坐标
-(CGFloat)getXCenterPoint{    
    return LABEL_WIDTH+30;
}

//滑杆上每个index点对应的Y坐标
-(CGFloat)getYCenterPointForIndex:(int) index{    
    return STEP_LENGTH/2+STEP_LENGTH*index;
}


-(void) setHandlerColor:(UIColor *)color{
    [handler setHandlerColor:color];
}


-(void) setTitlesColor:(UIColor *)color{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [lbl setTextColor:color];
    }
}

-(void) setTitlesFont:(UIFont *)font{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [lbl setFont:font];
    }
}

//手势事件处理方法
-(IBAction)tapGestureRecognizer: (UITapGestureRecognizer *) tap {
    int currentIndex = [self getIndexInPoint:[tap locationInView:self]];
    [self setSelectedIndex:currentIndex];
    
    //UIControl对象触发UIControlEventTouchUpInside事件
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}



#pragma mark SEFilterKnob代理事件
- (void) TouchDown: (UIButton *) btn withEvent: (UIEvent *) ev{
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    diffPoint = CGPointMake(currPoint.x - btn.center.x, currPoint.y - btn.center.y);
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    
    CGPoint newPoint=CGPointMake(handler.center.x,currPoint.y-diffPoint.y);
    if (newPoint.y<STEP_LENGTH/2) {
        newPoint=CGPointMake(handler.center.x,STEP_LENGTH/2);
    }
    if (newPoint.y>STEP_LENGTH/2+STEP_LENGTH*(titlesArr.count-1)) {
        newPoint=CGPointMake(handler.center.x,STEP_LENGTH/2+STEP_LENGTH*(titlesArr.count-1));
    }
    
    //handler位置随着拖动
    handler.center=newPoint;

    //此处需要直接更新titles
    int currentIndex = [self getIndexInPoint:newPoint];
    [self updateView_selectedIndex_titles:currentIndex];
    
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}


-(void) TouchUp: (UIButton*) btn{
    int currentIndex = [self getIndexInPoint:btn.center];
    self.selectedIndex = currentIndex;
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end