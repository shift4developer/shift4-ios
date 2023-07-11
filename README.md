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

To ensure that an application using our SDK successfully passes the review process to the App Store, we have integrated it into the Shift4 Sentinel application. It also allows you to familiarize yourself with the features of our Framework in a convenient way. To do this, download the application (https://apps.apple.com/us/app/shift4-sentinel/id6444154679), then in the Profile tab, turn on the test mode. A Developers section will appear at the bottom of the screen with a demonstration of the Framework.

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
Then run `pod install --repo-update`.

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
Shift4SDK.shared.publicKey = "pk_test_..."
Shift4SDK.shared.bundleIdentifier = "..."
```

##### Objective-C

```objective-c
Shift4SDK.shared.publicKey = @"pk_test_...";
Shift4SDK.shared.bundleIdentifier = @"";
```

### Checkout View Controller

Checkout View Controller is an out-of-box solution designed to provide the smoothest payment experience possible. It is a simple overlay with payments that appears on top of your page. Well-designed and ready to use.

To present Checkout View Controller you need to create Checkout Request on your backend side. You can find more informations about Checkout Requests here: https://dev.shift4.com/docs/api#checkout-request. You can also create test Checkout Request here: https://dev.shift4.com/docs/checkout-request-generator.

##### Swift

```swift
let checkoutRequest = ...
Shift4SDK.shared.showCheckoutViewController(
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
Shift4SDK.shared.cleanSavedCards()
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

SDK allows user to present 3DS authentication screen as a modal dialog.

##### Swift

```swift
let request = TokenRequest(
    number: "4242424242424242",
    expirationMonth: "10",
    expirationYear: "2023",
    cvc: "123"
)

Shift4SDK.shared.createToken(with: request) { token, error in
    guard let self = self else { return }
    guard let token = token else { print(error); return }

    Shift4SDK.shared.authenticate(token: token, amount: 10000, currency: "EUR", viewControllerPresenting3DS: self) { [weak self] authenticatedToken, authenticationError in
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

## Flutter

The SDK is created in native technologies, but since Flutter allows you to use native components, integrating the library on this platform is possible, but requires a few additional steps.

At first that, open the Xcode project file located in the /ios subdirectory in the main project directory. Then perform the configuration described in the Installation section. Don't forget to request the 3D-Secure library, without which you won't compile the project, and which we can't publish on github for licensing reasons. You will get it by contacting devsupport@shift4.com.

In the native iOS code in AppDelegate.swift create the function:

```swift
private func performCheckout(result: @escaping FlutterResult) {
    let checkoutRequest = CheckoutRequest(content: "...")
    Shift4SDK.shared.publicKey = "pk_test_..."
    Shift4SDK.shared.bundleIdentifier = "com.example.app"
    Shift4SDK.shared.showCheckoutViewController(in: (window?.rootViewController)!, checkoutRequest: checkoutRequest, merchantName: "Example merchant", description: "Example payment") { paymentResult, paymentError in
        if let paymentResult {
            result(paymentResult.dictionary())
        } else if let paymentError {
            result(paymentError.dictionary())
        } else {
            // Cancelled
        }
    }
}
```

In the didFinishLaunching function add the following lines:

```swift
let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
let checkoutChannel = FlutterMethodChannel(name: "com.example/checkout", binaryMessenger: controller.binaryMessenger)
        
checkoutChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    guard call.method == "checkout" else {
        result(FlutterMethodNotImplemented)
        return
    }
    self?.performCheckout(result: result)
})
```

Remember to provide the appropriate publicKey and checkoutRequest.

In the State of your application add the lines:

```dart
static const platform = MethodChannel('com.example/checkout');

Future<void> _checkout() async {
  try {
    final Map result = await platform.invokeMethod('checkout');
    print(result);
  } on PlatformException catch (e) {
    print(e);
  }
}
```

And execute the created function somewhere, such as creating a button:

```dart
TextButton(
    onPressed: _checkout, 
    child: const Text('Hello Shift4!')),
```

That's it. You can launch your app.

## Customization

Interface elements such as fonts, colors and sizes can be freely modified using an object returned from `Shift4SDK.shared.style`. Code example below.

```swift
let style = Shift4SDK.shared.style

style.primaryColor = .blue
style.successColor = .green
style.errorColor = .red
        
style.primaryTextColor = .black
style.placeholderColor = .gray
style.disabledColor = .gray
style.separatorColor = .gray
        
style.button.font = UIFont.boldSystemFont(ofSize: 10)
style.button.height = 60.0
style.button.cornerRadius = 5.0
        
style.font.regularlabel = UIFont.systemFont(ofSize: 10)
style.font.title = UIFont.systemFont(ofSize: 10)
style.font.section = UIFont.systemFont(ofSize: 10)
style.font.body = UIFont.systemFont(ofSize: 10)
style.font.label = UIFont.systemFont(ofSize: 10)
style.font.error = UIFont.systemFont(ofSize: 10)
style.font.tileLabel = UIFont.systemFont(ofSize: 20)
```

#### primaryColor
Main brand color used for buttons and switches.

#### successColor
Color of button after successful payment.

#### errorColor
Color used for error messages.

#### primaryTextColor
Color used for all titles, sections and other labels.

#### placeholderColor
Color for placeholders of text inputs.

#### disabledColor
Color of disabled elements, for example button is disabled when text inputs are empty.

#### separatorColor
Color of separators between sections and other elements responsible for a page structure.

#### button.font
Font style of a button's title.

#### button.height
Height of buttons.

#### button.cornerRadius
Corner radius of buttons. Use 0 if you want your buttons to be rectangles.

## Testing

When making requests in test mode you have to use special card numbers to simulate successful charges or processing errors. You can find list of card numbers here: https://dev.shift4.com/docs/testing. You can check status of every charge you made here: https://dev.shift4.com/charges.

Remember not to make too many requests in a short period of time or you may reach a rate limit. If you reach the limit you have to wait 24h.

## Translations

SDK supports localization for 18 languages. Your application must be localized.

## License

Framework is released under the MIT Licence.
