//
//  JUDIViewController.h
//  basicPersistenceExample
//

#import <UIKit/UIKit.h>

@interface JUDIViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *swaggerSwitch;
@property (strong, nonatomic) IBOutlet UITextField *resortText;

- (void)applicationWillResignActive:(NSNotification *)notification;
- (IBAction)SubmitPressed:(id)sender;
- (NSString *)dataFile;
- (void)saveAttributesToFile;
@end
