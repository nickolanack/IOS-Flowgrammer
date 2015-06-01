//
//  NodeLibraryViewController.h
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Flow.h"


@interface NodeLibraryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)onCloseClick:(id)sender;
@property (strong, nonatomic) Flow *flow;
@property Connection *connection;
@property NSValue *point;

- (void) selectFlowNode:(Block *)node;

@property (weak, nonatomic) IBOutlet UICollectionView *blockCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *variableCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *sensorCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *logicCollection;

@end
