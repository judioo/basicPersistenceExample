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
    
    // check to see if our data file already exists ( see method 'saveAttributesToFile'
    // for how we write to this file below).
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFile]]) {
        // IT EXISTS!
        // get the previous value for our switch
        if ([[dict objectForKey:@"previousSwagger"] boolValue]) {
            [swaggerSwitch setOn:YES animated:YES];
        } else {
            [swaggerSwitch setOn:NO animated:YES];
        }
        
        // get the last value for our text box
        resortText.text = [dict objectForKey:@"previousResort"];
    }
                           
    // get reference to our application    
    UIApplication *thisApp  = [UIApplication sharedApplication];
    
    
    // Here we setup a listener which will be triggered when
    // our application is suspended or shutdown
    // The bellow states:
    [[NSNotificationCenter defaultCenter]               // using the default notification center
     addObserver:self                                   // call this object (self) 
     selector:@selector(applicationWillResignActive:)   // with this method
     name:UIApplicationWillResignActiveNotification     // when this event
     object:thisApp];                                   // occurs in this application
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
    // this method is called by the notification center ( see method 'viewDidLoad' 
    // for where we set this up). All it will do is save our attributes
    [self saveAttributesToFile];
}

- (IBAction)SubmitPressed:(id)sender {
    // this is how you can save our attributes via a button press
    [self saveAttributesToFile];
    
    // hide keyboard
    [self.resortText resignFirstResponder];
    
    // write a confirmation alert to screen
    UIAlertView *alert  = [[UIAlertView alloc]
                           initWithTitle:@"DOne"
                           message:@"Saved attributes to file"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
}

- (NSString *)dataFile {
    // returns the file name and location of the place we are going to store the data
    
    // don't worry to much about this bit. It's almost always the same the only difference 
    // being the file name at the end (i.e. @"ustompData.plist" bit).
    NSArray *allPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                              NSUserDomainMask, YES);
    NSString *documentsDirectory    = [allPaths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"ustompData.plist"];
}

- (void)saveAttributesToFile {
    // save our 2 attributes (resortText & swaggerSwitch) to our data file.
    
    // create a dictonary containing the values of our 2 atributes
    NSDictionary *dict  = [[NSDictionary alloc] 
                           initWithObjectsAndKeys:
                           // save our switchs boolean value as a number. Easier this way
                           // when it comes to reading
                           [NSNumber numberWithBool:[swaggerSwitch isOn]], @"previousSwagger",
                           // and save only the text from our resort attribute
                           resortText.text, @"previousResort", nil];

    // now write our dictonary to file. This will be read the next time we start up
    if([dict writeToFile:[self dataFile] atomically:YES]) {
        NSLog(@"Successfully wrote to file %@",[self dataFile]);
    } else {
        NSLog(@"Failed writting to file %@",[self dataFile]);
    }
}



@end
