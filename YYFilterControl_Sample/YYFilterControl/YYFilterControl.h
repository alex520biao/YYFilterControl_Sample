//
//  SEFilterControl.h
//  SEFilterControl_Test
//
//  Created by alex on 6/13/12.
//  Copyright (c) 2012 mash, ltd. All rights reserved.

#import <UIKit/UIKit.h>
#import "YYFilterKnob.h"

/*
 SEFilterControl说明
 1.综合UISlider功能，可拖动
 2.综合UISegmentControl功能,可点选
 */
@interface YYFilterControl : UIControl{

}
-(id) initWithTitles:(NSArray *) titles;
-(void) setSelectedIndex:(int)index;
-(void) setTitlesColor:(UIColor *)color;
-(void) setTitlesFont:(UIFont *)font;
@property(nonatomic, readonly) int selectedIndex;//当前选中的index
@end
