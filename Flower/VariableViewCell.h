//
//  VariableViewCell.h
//  Flower
//
//  Created by Nick Blackwell on 3/11/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeLibraryViewController.h"
#import "Block.h"

@interface VariableViewCell : UICollectionViewCell
@property (nonatomic) Block *node;
@property NodeLibraryViewController *nodeLibraryViewController;
@end
