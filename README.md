SiriKit2018
===========

## This app is an example of how to use the INPayBillIntent to pay bills using
## Siri voice commands. The api calls are fake and hardcoded just to provide a working
## example for people to experiment with.

## How use this app and its extension:

1. Build the app (It must be built before you try to use the Siri commands)
    * Running the SiriKit extension itself doesn't install anything so the extension
    can be used immediately after installing the main application
2. Run the app
3. Press OK when it prompts you "If you would like to use SiriKit2018 with Siri" to
   give the app authorization to use Siri commands
4. Press the button that says "Sign In" to trigger a fake sign in
    * This updates the UserDefaults so that the extension knows the user is
   logged in otherwise you cannot use the SiriKit extension

## The next step is up to you
## There are three different ways you could trigger the SiriKit extension
## after the app was built:

5. a) If you are using the simulator go to the simulator toolbar:
    * Hardware > Siri (or option + shift + command + H)
    * Say "Pay my bill" or "Pay my electric bill" or "Pay my bill with SiriKit2018" or something similar
    * If the user isn't logged in, an error message will appear

   b) If you are using a device and you have signed in:
    * Say "Pay my bill" or "Pay my electric bill" or "Pay my bill with SiriKit2018" or something similar

   c) You could also choose to run SiriKit from Xcode itself after the app is built
    in the simulated device or a real device
    * Set the active scheme to "SiriKitExtension"
    * Under "Choose an app to run" select Siri
    * Say "Pay my bill" or "Pay my electric bill" or "Pay my bill with SiriKit2018" or something similar

6. Say or tap the address you want
7. A modal will show up if you want to confirm the payment
8. If so, say or press "Send"
