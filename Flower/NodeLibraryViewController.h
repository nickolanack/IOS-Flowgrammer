//
//  NodeLibraryViewController.h
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeLibraryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)onCloseClick:(id)sender;
@property (strong, nonatomic) id delegate;
@end
