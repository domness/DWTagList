//
//  ViewController.h
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"

@interface ViewController : UIViewController <DWTagListDelegate>

@property (nonatomic, strong) NSMutableArray        *array;
@property (nonatomic, weak) IBOutlet DWTagList    *tagList;
@property (nonatomic, weak) IBOutlet UITextField    *addTagField;

- (IBAction)tappedAdd:(id)sender;

@end
