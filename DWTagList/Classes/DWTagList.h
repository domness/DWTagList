//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@protocol DWTagListDelegate, DWTagViewDelegate;

@interface DWTagList : UIScrollView
{
    UIView      *view;
    NSArray     *textArray;
    CGSize      sizeFit;
    UIColor     *lblBackgroundColor;
}

@property (nonatomic) BOOL viewOnly;
@property (nonatomic) BOOL showTagMenu;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, weak) id<DWTagListDelegate> tagDelegate;
@property (nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;
@property (nonatomic) IBInspectable BOOL automaticResize;
@property (nonatomic, strong) IBInspectable UIFont *font;
@property (nonatomic, assign) IBInspectable CGFloat labelMargin;
@property (nonatomic, assign) IBInspectable CGFloat bottomMargin;
@property (nonatomic, assign) IBInspectable CGFloat horizontalPadding;
@property (nonatomic, assign) IBInspectable CGFloat verticalPadding;
@property (nonatomic, assign) IBInspectable CGFloat minimumWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, strong) IBInspectable UIColor *textShadowColor;
@property (nonatomic, assign) IBInspectable CGSize textShadowOffset;

- (void)setTagBackgroundColor:(UIColor *)color;
- (void)setTagHighlightColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end

@interface DWTagView : UIView

@property (nonatomic, strong) UIButton              *button;
@property (nonatomic, strong) UILabel               *label;
@property (nonatomic, weak)   id<DWTagViewDelegate> delegate;

- (void)updateWithString:(NSString*)text
                    font:(UIFont*)font
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth;
- (void)setLabelText:(NSString*)text;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(CGColorRef)borderColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)setTextColor:(UIColor*)textColor;
- (void)setTextShadowColor:(UIColor*)textShadowColor;
- (void)setTextShadowOffset:(CGSize)textShadowOffset;

@end


@protocol DWTagListDelegate <NSObject>

@optional

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex;
- (void)selectedTag:(NSString *)tagName;
- (void)tagListTagsChanged:(DWTagList *)tagList;

@end

@protocol DWTagViewDelegate <NSObject>

@required

- (void)tagViewWantsToBeDeleted:(DWTagView *)tagView;

@end
