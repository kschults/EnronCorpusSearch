//
//  ECSSearchController.m
//  EnronCorpusSearch
//
//  Created by Karl Schults on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ECSSearchController.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ECSSearchController
@synthesize searchBox;
@synthesize resultsField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSearchBox:nil];
    [self setResultsField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)search {
    NSString* term = [searchBox text];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [term dataUsingEncoding: NSUTF8StringEncoding]; /* or some other encoding */
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *hex = [NSMutableString string];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            [hex appendFormat:@"%02x", digest[i]];
        }
        NSString *hS = [hex substringToIndex:10]; //Use first half of the hash - we don't care about uniqueness
        unsigned long long longVal;
        [[NSScanner scannerWithString:hS] scanHexLongLong:&longVal];
        
        int dictNum = fmod(longVal, 10);
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        NSString *dictToRead = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"index/dict%d", dictNum]];
        if ([fm fileExistsAtPath:dictToRead]) {
            NSData *data = [fm contentsAtPath:dictToRead];
            
            NSError *e;
            NSDictionary *mappings = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            
            NSArray* emailIds = [mappings objectForKey:term];
            if (nil != emailIds) {
                [resultsField setText:[emailIds componentsJoinedByString:@", "]];
            } else {
                [resultsField setText:@"No Emails Found"];
            }
        }
    }
}
@end
