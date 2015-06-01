//
//  NodeViewCell.h
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Block.h"
#import "NodeLibraryViewController.h"

@interface NodeViewCell : UICollectionViewCell
@property (nonatomic) Block *node;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property NodeLibraryViewController *nodeLibraryViewController;

@end
