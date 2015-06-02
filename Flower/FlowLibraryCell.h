//
//  FlowLibraryCell.h
//  Flower
//
//  Created by Nick Blackwell on 2014-03-27.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowLibraryViewController.h"

@interface FlowLibraryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *file;

@property FlowLibraryViewController *flowLibraryViewController;
@property (nonatomic) NSString *path;

@end
