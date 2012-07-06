//
//  JUDIViewController.m
//  basicPersistenceExample
//

#import "JUDIViewController.h"

@interface JUDIViewController ()

@end

@implementation JUDIViewController
@synthesize swaggerSwitch;
@synthesize resortText;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *dict  = [[NSDictionary alloc]
                           initWithContentsOfFile:[self dataFile]];
    
    NSLog(@"dataFile: %@",[self dataFile]);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFile]]) {
        if ([[dict objectForKey:@"previousSwagger"] boolValue]) {
            [swaggerSwitch setOn:YES animated:YES];
        } else {
            [swaggerSwitch setOn:NO animated:YES];
        }
        
        resortText.text = [dict objectForKey:@"previousResort"];
    }
                           
    // get reference to our application    
    UIApplication *thisApp  = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:thisApp];
}

- (void)viewDidUnload
{
    [self setSwaggerSwitch:nil];
    [self setResortText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self saveAttributesToFile];
}

- (IBAction)SubmitPressed:(id)sender {
    [self saveAttributesToFile];
    [self.resortText resignFirstResponder];
    
    UIAlertView *alert  = [[UIAlertView alloc]
                           initWithTitle:@"DOne"
                           message:@"Saved attributes to file"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
}

- (NSString *)dataFile {
    NSArray *allPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory    = [allPaths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"ustompData.plist"];
}

- (void)saveAttributesToFile {
    NSDictionary *dict  = [[NSDictionary alloc] 
                           initWithObjectsAndKeys:
                           [NSNumber numberWithBool:[swaggerSwitch isOn]], @"previousSwagger",
                           resortText.text, @"previousResort", nil];
    
    if([dict writeToFile:[self dataFile] atomically:YES]) {
        NSLog(@"Successfully wrote to file %@",[self dataFile]);
    } else {
        NSLog(@"Failed writting to file %@",[self dataFile]);
    }
}



@end
