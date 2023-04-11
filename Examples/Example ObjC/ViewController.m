#import "ViewController.h"
@import Shift4;

@interface ViewController ()
@end

@implementation ViewController

- (IBAction)didTapPaymentButton:(id)sender {
    Shift4SDK.shared.publicKey = @"";
    Shift4SDK.shared.bundleIdentifier = @"";
    S4CheckoutRequest *checkoutRequest = [[S4CheckoutRequest alloc] initWithContent:@""];
    [Shift4SDK.shared showCheckoutViewControllerIn:self
                                   checkoutRequest:checkoutRequest
                                      merchantName:@"Example Merchant"
                                       description:@"Example payment"
                                      merchantLogo:nil
                            collectShippingAddress:false
                             collectBillingAddress:false
                                             email:nil
                                        completion:^(S4PaymentResult *result, S4Error *error) {
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
