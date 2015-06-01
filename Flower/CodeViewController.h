//
//  CodeViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//



#import "NodeViewController.h"

@interface CodeViewController : NodeViewController


@property (weak, nonatomic) IBOutlet UITextView *editor;
@property (weak, nonatomic) IBOutlet UILabel *outputConnectionLabel;


@end
