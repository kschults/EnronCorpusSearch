//
//  ECSSearchController.h
//  EnronCorpusSearch
//
//  Created by Karl Schults on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECSSearchController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *searchBox;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *resultsField;
- (IBAction)search;

@end
