//
//  FlowLibraryViewController.h
//  Flower
//
//  Created by Nick Blackwell on 3/14/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowView.h"
#import "FlowViewController.h"

@interface FlowLibraryViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

- (IBAction)onNewClick:(id)sender;

- (IBAction)onCloseClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *onNewClick;

@property FlowView *flow;
@property FlowViewController *flowViewController;


-(void)selectFile:(NSString *)path;

@end
