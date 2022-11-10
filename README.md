# Shift4 iOS SDK

Welcome to Shift4 iOS SDK. Framework allows you to easily add Shift4 payments to your mobile apps. It allows you to integrate Shift4 with just a few lines of code. It also exposes low-level Shift4 API which you can use to create custom payment form.

## Features

#### Security

All sensitive data is sent directly to our servers instead of using your backend, so you can be sure that your payments are highly secure.

#### 3D-Secure

Add a smart 3D Secure verification with superior UX to your transactions. Provide smooth and uninterrupted payment experience that doesn’t interfere with your conversion process.

#### Shift4 API

We provide methods corresponding to Shift4 API. It allows you creating an entirely custom UI embedded into your application to increase conversion by keeping clients inside your app.

#### Translations

You can process payments in 18 languages.

#### Example application

We created simple application to demonstrate Framework's features.

## Requirements and limitations

Strict requirements of PCI 3DS SDK make development impossible. Running on simulator or debugging are forbidden in a production build of your application. We provide two versions of Framework both for Debug and Release builds so you can create and debug your application without any issues.

Notice that XCode release builds and AdHoc builds with release version of Framework are forbidden too. Any attempt to perform the operation results with error. The only tool that allows to test the release version is Apple TestFlight.

## App Store Review

To ensure that an application using our SDK successfully passes the review process to the App Store, we have integrated it into the SecurionPay application. It also allows you to familiarize yourself with the features of our Framework in a convenient way. To do this, download the application (https://apps.apple.com/us/app/shift4-sentinel/id6444154679), then in the Profile tab, turn on the test mode. A Developers section will appear at the bottom of the screen with a demonstration of the Framework.

## Installation

### CocoaPods

Because of issues related with XCFramework, you have to use version **1.10.1** of CocoaPods or higher.

3D Secure library license requirements force us to distribute it via email. Contact devsupport@shift4.com to get it. Download both ipworks3ds_sdk_debug.xcframework and ipworks3ds_sdk_release.xcframework 3D-Secure libraries and copy them to Frameworks directory in your project's root. Then add a new script that selects proper version of 3DS framework to Build Phases:

```
rm -rf ${SRCROOT}/ipworks3ds_sdk.xcframework

if [ $CONFIGURATION == "Release" ]; then
    cp -rf ${SRCROOT}/Frameworks/ipworks3ds_sdk_release.xcframework ${SRCROOT}/ipworks3ds_sdk.xcframework
fi

if [ $CONFIGURATION == "Debug" ]; then
    cp -rf ${SRCROOT}/Frameworks/ipworks3ds_sdk_debug.xcframework ${SRCROOT}/ipworks3ds_sdk.xcframework
fi
```

This step is called `Copy Shift4 3DS framework` in Example app where you can check it.

Then build an app. New file ipworks3ds_sdk.xcframework will appear in your project's root directory. Add it to your project. Select `Embed & Sign` option.

Next you need to install the Framework using Cocoapods. Add the following entry in your Podfile:

```ruby
pod 'Shift4'
```
Then run `pod install`.

Do not forget to import the framework at the beginning of any file you'd like to use Shift4 in.

##### Swift

```swift
import Shift4
```

##### Objective-C

```objective-c
@import Shift4;
```

## Usage

If you have not created an account yet, you can do it here: https://dev.shift4.com/signup.

### Configuration

To configure the framework you need to provide the public key. You can find it here: https://dev.shift4.com/account-settings. Notice that there are two types of keys: live and test. The type of key determines application mode. Make sure you used a live key in build released to App Store. You can provide it on your backend side as well.

Framework also requires you to specify Bundle Identifier of application. This should match the Bundle Identifier used when building the application. Any attempt to perform the operation in release mode results in error if they do not match. This value should not be hardcoded in the application for security reasons. You should provide it on your backend side.

##### Swift

```swift
Shift4.shared.publicKey = "pk_test_..."
Shift4.shared.bundleIdentifier = "..."
```

##### Objective-C

```objective-c
Shift4.shared.publicKey = @"pk_test_...";
Shift4.shared.bundleIdentifier = @"";
```

### Checkout View Controller

Checkout View Controller is an out-of-box solution designed to provide the smoothest payment experience possible. It is a simple overlay with payments that appears on top of your page. Well-designed and ready to use.

To present Checkout View Controller you need to create Checkout Request on your backend side. You can find more informations about Checkout Requests here: https://dev.shift4.com/docs/api#checkout-request. You can also create test Checkout Request here: https://dev.shift4.com/docs/checkout-request-generator.

##### Swift

```swift
let checkoutRequest = ...
Shift4.shared.showCheckoutViewController(
    in: self,
    checkoutRequest: checkoutRequest) { [weak self] result, error in
        if let result = result {
            print(result.subscriptionId)
            print(result.chargeId)
        } else if let error = error {
            print(error.localizedMessage())
        } else {
            // cancelled
        }
    }
```

##### Objective-C

```objective-c
SPCheckoutRequest* checkoutRequest = ...;
[[Shift4 shared] showCheckoutViewControllerIn:self
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
```

#### Saved cards

Checkout View Controller has a feature allowing to remember cards used before. To delete them, use code:

##### Swift

```swift
Shift4.shared.cleanSavedCards()
```

##### Objective-C

```objective-c
[[Shift4 shared] cleanSavedCards];
```

#### Possible errors

| Type          | Code                      | Message                                                | Explanation                                                  |
| ------------- | ------------------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| .sdk          | .unsupportedValue         | "Unsupported value: \(value)"                          | Framework does not accept Checkout Request fields: **termsAndConditionsUrl**, **customerId**, **crossSaleOfferIds**. |
| .sdk          | .incorrectCheckoutRequest | "Incorrect checkout request"                           | Checkout Request looks corrupted. Make sure you create it according to documentation. |
| .threeDSecure | .unknown                  | "Unknown 3D Secure Error. Check your SDK integration." |                                                              |
| .threeDSecure | .deviceJailbroken         | "The device is jailbroken."                            |                                                              |
| .threeDSecure | .integrityTampered        | "The integrity of the SDK has been tampered."          |                                                              |
| .threeDSecure | .simulator                | "An emulator is being used to run the app."            |                                                              |
| .threeDSecure | .osNotSupported           | "The OS or the OS version is not supported."           |                                                              |



### Custom Form

SDK allows user to present 3DS authentication screen or to push it into UINavigationController stack.

#### UINavigationController based app

##### Swift

```swift
let request = TokenRequest(
    number: "4242424242424242",
    expirationMonth: "10",
    expirationYear: "2023",
    cvc: "123"
)

Shift4.shared.createToken(with: request) { token, error in
    guard let self = self else { return }
    guard let navController = self.navigationController else { return }
    guard let token = token else { print(error); return }

    Shift4.shared.authenticate(token: token, amount: 10000, currency: "EUR", navigationControllerFor3DS: navController) { [weak self] authenticatedToken, authenticationError in
        print(authenticatedToken)      
        print(authenticationError)                                                                                                     
    }
}
```

#### Presenting 3DS screen as a dialog

##### Swift

```swift
let request = TokenRequest(
    number: "4242424242424242",
    expirationMonth: "10",
    expirationYear: "2023",
    cvc: "123"
)

Shift4.shared.createToken(with: request) { token, error in
    guard let self = self else { return }
    guard let token = token else { print(error); return }

    Shift4.shared.authenticate(token: token, amount: 10000, currency: "EUR", viewControllerPresenting3DS: self) { [weak self] authenticatedToken, authenticationError in
        print(authenticatedToken)      
        print(authenticationError)                                                                                                     
    }
}
```

#### Possible errors

##### Creating token

| Type       | Code                | Message                                              | Explanation |
| ---------- | ------------------- | ---------------------------------------------------- | ----------- |
| .cardError | .invalidNumber      | "The card number is not a valid credit card number." |             |
| .cardError | .invalidExpiryMonth | "The card's expiration month is invalid."            |             |
| .cardError | .invalidExpiryYear  | "The card's expiration year is invalid."             |             |
| .cardError | .expiredCard        | "The card has expired."                              |             |
| .cardError | .invalidCVC         | "Your card's security code is invalid."              |             |

##### Authentication

| Type          | Code               | Message                                                | Explanation                                                  |
| ------------- | ------------------ | ------------------------------------------------------ | ------------------------------------------------------------ |
| .sdk          | .anotherOperation  | "Another task is in progress."                         | You can complete only one authentication operation at a time. Your UI should prevent it from being triggered multiple times. |
| .threeDSecure | .unknown           | "Unknown 3D Secure Error. Check your SDK integration." |                                                              |
| .threeDSecure | .deviceJailbroken  | "The device is jailbroken."                            |                                                              |
| .threeDSecure | .integrityTampered | "The integrity of the SDK has been tampered."          |                                                              |
| .threeDSecure | .simulator         | "An emulator is being used to run the app."            |                                                              |
| .threeDSecure | .osNotSupported    | "The OS or the OS version is not supported."           |                                                              |

## Testing

When making requests in test mode you have to use special card numbers to simulate successful charges or processing errors. You can find list of card numbers here: https://dev.shift4.com/docs/testing. You can check status of every charge you made here: https://dev.shift4.com/charges.

Remember not to make too many requests in a short period of time or you may reach a rate limit. If you reach the limit you have to wait 24h.

## Translations

SDK supports localization for 18 languages. Your application must be localized.

## License

Framework is released under the MIT Licence.
