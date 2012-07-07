//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWTagList : UIView
{
    UIView *view;
    NSMutableArray *textArray;
    CGSize sizeFit;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableArray *textArray;

- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
