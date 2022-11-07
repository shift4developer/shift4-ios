#import "ViewController.h"
@import SecurionPay;

@interface ViewController ()
@end

@implementation ViewController

- (IBAction)didTapPaymentButton:(id)sender {
    [SecurionPay shared].publicKey = @"";
    [SecurionPay shared].bundleIdentifier = @"";
    SPCheckoutRequest *checkoutRequest = [[SPCheckoutRequest alloc] initWithContent:@""];
    [[SecurionPay shared] showCheckoutViewControllerIn:self
                                       checkoutRequest:checkoutRequest
                                            completion:^(SPPaymentResult * result, SPError * error) {
        if (result != nil) {
            NSLog(@"%@", result.subscriptionId);
            NSLog(@"%@", result.chargeId);
        } else if (error != nil) {
            NSLog(@"%@", [error localizedMessage]);
        } else {
            // Cancelled
        }
    }];
}

@end
