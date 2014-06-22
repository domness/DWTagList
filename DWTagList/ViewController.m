//
//  ViewController.m
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//- (void)selectedTag:(NSString *)tagName{
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                    message:[NSString stringWithFormat:@"You tapped tag %@", tagName]
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:[NSString stringWithFormat:@"You tapped tag %@ at index %ld", tagName,(long)tagIndex]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, self.view.bounds.size.width-40.0f, 50.0f)];
    [_tagList setAutomaticResize:YES];
    _array = [[NSMutableArray alloc] initWithObjects:@"Foo",
                        @"Tag Label 1",
                        @"Tag Label 2",
                        @"Tag Label 3",
                        @"Tag Label 4",
                        @"Long long long long long long Tag", nil];
    [_tagList setTags:_array];
    [_tagList setTagDelegate:self];

    // Customisation
    [_tagList setCornerRadius:4.0f];
    [_tagList setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tagList setBorderWidth:1.0f];

    [self.view addSubview:_tagList];
}

- (IBAction)tappedAdd:(id)sender
{
    [_addTagField resignFirstResponder];
    [[_addTagField text] length]?[_array addObject:[_addTagField text]]:nil;
    [_addTagField setText:@""];
    [_tagList setTags:_array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
