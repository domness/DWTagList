//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f
#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
#define DEFAULT_AUTOMATIC_RESIZE NO

@interface DWTagList()

- (void)touchedTag:(id)sender;

@end

@implementation DWTagList

@synthesize view, textArray, automaticResize;
@synthesize tagDelegate = _tagDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
        [self setClipsToBounds:YES];
        self.automaticResize = DEFAULT_AUTOMATIC_RESIZE;
        self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:view];
        [self setClipsToBounds:YES];
        self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
    if (automaticResize) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeFit.width, sizeFit.height);
    }
}

- (void)setTagBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)setTagHighlightColor:(UIColor *)color
{
    self.highlightedBackgroundColor = color;
    [self display];
}

- (void)setViewOnly:(BOOL)viewOnly
{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self display];
    }
}

- (void)touchedTag:(id)sender
{
    UITapGestureRecognizer *t = (UITapGestureRecognizer *)sender;
    DWTagView *tagView = (DWTagView *)t.view;
    if(tagView && self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(selectedTag:)])
        [self.tagDelegate selectedTag:tagView.label.text];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self display];
}

- (void)display
{
    for (DWTagView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        DWTagView *tagView = [[DWTagView alloc] initWithString:text
                                             constrainedToSize:CGSizeMake(self.frame.size.width-HORIZONTAL_PADDING*2, self.frame.size.height)];
        if (!gotPreviousFrame) {
            totalHeight = tagView.frame.size.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + tagView.frame.size.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + tagView.frame.size.height + BOTTOM_MARGIN);
                totalHeight += tagView.frame.size.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = tagView.frame.size;
            [tagView setFrame:newRect];
        }
        
        previousFrame = tagView.frame;
        gotPreviousFrame = YES;

        [tagView setBackgroundColor:[self getBackgroundColor]];

        // Davide Cenzi, added gesture recognizer to label
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedTag:)];
        // if labelView is not set userInteractionEnabled, you must do so
        [tagView setUserInteractionEnabled:YES];
        [tagView addGestureRecognizer:gesture];
        
        [self addSubview:tagView];

        if (!_viewOnly) {
            [tagView.button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
            [tagView.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [tagView.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [tagView.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        }
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
    self.contentSize = sizeFit;
}

- (CGSize)fittedSize
{
    return sizeFit;
}

- (void)touchDownInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [[button superview] setBackgroundColor:self.highlightedBackgroundColor];
}

- (void)touchUpInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [[button superview] setBackgroundColor:[self getBackgroundColor]];
    if(button && self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(selectedTag:)])
        [self.tagDelegate selectedTag:button.accessibilityLabel];
}

- (void)touchDragExit:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [[button superview] setBackgroundColor:[self getBackgroundColor]];
}

- (void)touchDragInside:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [[button superview] setBackgroundColor:[self getBackgroundColor]];
}
     
- (UIColor *)getBackgroundColor
{
     if (!lblBackgroundColor) {
         return BACKGROUND_COLOR;
     } else {
         return lblBackgroundColor;
     }
}

- (void)dealloc
{
    view = nil;
    textArray = nil;
    lblBackgroundColor = nil;
}

@end


@implementation DWTagView

- (id)initWithString:(NSString*)text constrainedToSize:(CGSize)size
{
    self = [super init];
    if(self) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(size.width, FONT_SIZE) lineBreakMode:NSLineBreakByTruncatingTail];
        textSize.height += VERTICAL_PADDING*2;
        self.frame = CGRectMake(0, 0, textSize.width+HORIZONTAL_PADDING*2, textSize.height);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, 0, textSize.width, textSize.height)];
        CGRect lRect = _label.frame;
        lRect.size.width = MIN(_label.frame.size.width, self.frame.size.width);
        [_label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [_label setFrame:lRect];
        [_label setTextColor:TEXT_COLOR];
        [_label setText:text];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setShadowColor:TEXT_SHADOW_COLOR];
        [_label setShadowOffset:TEXT_SHADOW_OFFSET];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:CORNER_RADIUS];
        [self.layer setBorderColor:BORDER_COLOR];
        [self.layer setBorderWidth: BORDER_WIDTH];
        [self addSubview:_label];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:self.frame];
        [_button setAccessibilityLabel:self.label.text];
        [self addSubview:_button];
    }
    return self;
}

- (void)setLabelText:(NSString*)text
{
    [_label setText:text];
}

- (void)dealloc
{
    _label = nil;
    _button = nil;
}

@end
