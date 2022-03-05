# ios-applovin-mediation
## Enables you to serve Start.io (formerly StartApp) Ads in your iOS application using AppLovin mediation network

### 1. Getting Started

The following instructions assume you are already familiar with the AppLovin MAX SDK and have already integrated the AppLovin MAX iOS SDK into your application. Otherwise, please start by visiting AppLovin site and reading the instructions on how to add AppLovin mediation code into your app.
  * [AppLovin site](https://dash.applovin.com/documentation/mediation)
  * [AppLovin instructions](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)
  
### 2. Adding Your Application to Your Start.io Developer's Account
1. Login into your [Start.io developer's account](https://portal.start.io/#/signin)
1. Add your application and get its App ID

### 3. Integrating the Start.io <-> AppLovin Mediation Adapter
The easiest way is to use CocoaPods, just add to your Podfile the dependency
```
pod 'startio-applovin-mediation'
```
But you might as well use [this source code](https://github.com/StartApp-SDK/ios-applovin-mediation) from Github and add it to your project

### 4. Adding a Custom Event
1. Login into your [AppLovin account](https://dash.applovin.com/)
1. On the left menu expand "MAX->Mediation->Networks"
1. Scroll down and select "Click here to add a Custom Network"
1. On a Manage Network page select SDK as Network Type
1. Set Custom Network Name to "Start.io"
1. Set iOS Adapter Class Name to "StartioAppLovinAdapter"
1. Tap Save
1. Start creating your Ad Units. Now in the Ad Unit waterfall you should see "Custom Network (SDK) - Start.io" under "Custom Networks & Deals" section. Expand it
1. Change Status to enabled
1. IMPORTANT! Set your Start.io AppID in corresponding field
1. You may also pass custom parameters in JSON format. Supported names and values you may find in adapter's StartioAppLovinExtras.m

#### If you need additional assistance you can take a look on our app example which works with this mediation adapter [here](https://github.com/StartApp-SDK/ios-applovin-mediation)
