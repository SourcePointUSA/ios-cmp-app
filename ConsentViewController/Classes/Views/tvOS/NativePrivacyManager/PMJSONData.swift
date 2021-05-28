//
//  PMJSONData.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 20/04/21.
//

import Foundation

// swiftlint:disable all

public let MockNativePMResponse = """
{
   "categories":[
      {
         "_id":"608bad95d08d3112188e0e29",
         "type":"IAB_PURPOSE",
         "name":"Store and/or access information on a device",
         "description":"Cookies, device identifiers, or other information can be stored or accessed on your device for the purposes presented to you."
      },
      {
         "_id":"608bad95d08d3112188e0e2f",
         "type":"IAB_PURPOSE",
         "name":"Select basic ads",
         "description":"Ads can be shown to you based on the content you’re viewing, the app you’re using, your approximate location, or your device type."
      },
      {
         "_id":"608bad95d08d3112188e0e36",
         "type":"IAB_PURPOSE",
         "name":"Create a personalised ads profile",
         "description":"A profile can be built about you and your interests to show you personalised ads that are relevant to you."
      },
      {
         "_id":"608bad95d08d3112188e0e3d",
         "type":"IAB_PURPOSE",
         "name":"Select personalised ads",
         "description":"Personalised ads can be shown to you based on a profile about you."
      },
      {
         "_id":"608bad96d08d3112188e0e4d",
         "type":"IAB_PURPOSE",
         "name":"Measure ad performance",
         "description":"The performance and effectiveness of ads that you see or interact with can be measured."
      },
      {
         "_id":"608bad96d08d3112188e0e53",
         "type":"IAB_PURPOSE",
         "name":"Measure content performance",
         "description":"The performance and effectiveness of content that you see or interact with can be measured."
      },
      {
         "_id":"608bad96d08d3112188e0e59",
         "type":"IAB_PURPOSE",
         "name":"Apply market research to generate audience insights",
         "description":"Market research can be used to learn more about the audiences who visit sites/apps and view ads."
      },
      {
         "_id":"608bad96d08d3112188e0e5f",
         "type":"IAB_PURPOSE",
         "name":"Develop and improve products",
         "description":"Your data can be used to improve existing systems and software, and to develop new products"
      },
      {
         "_id":"5e37fc3e973acf1e955b8966",
         "name":"Use precise geolocation data",
         "description":"Your precise geolocation data can be used in support of one or more purposes. This means your location can be accurate to within several meters."
      }
   ],
   "message_json":{
      "id":"Root",
      "type":"View",
      "style":{

      },
      "components":[
         {
            "id":"HomeView",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"HeaderText",
                  "type":"Text",
                  "text":"Privacy",
                  "style":{
                     "font":{
                        "fontSize":50,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, trebuchet, sans-serif"
                     }
                  }
               },
               {
                  "id":"CategoriesDescriptionText",
                  "type":"Text",
                  "text":"We and our partners use device identifiers or similar technologies on the app and to collect and use personal data (e.g., your IP address). If you consent, the device identifiers or or the information can be stored locally or accessed on your device for the purpose described below. You can click “Accept All” or “manage Preferences” to customize your consent.",
                  "style":{
                     "font":{
                        "fontSize": 28,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"CategoriesSubDescriptionText",
                  "type":"Text",
                  "text":"We and our partners process personal data to",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"600",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"AcceptAllButton",
                  "type":"Button",
                  "text":"Accept",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"NavCategoriesButton",
                  "type":"Button",
                  "text":"Manage Preferences",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"NavVendorsButton",
                  "type":"Button",
                  "text":"Our Partners",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"NavPrivacyPolicyButton",
                  "type":"Button",
                  "text":"Privacy Policy",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"LogoImage",
                  "type":"Image",
                  "src":"https://www.sourcepoint.com/wp-content/themes/sourcepoint/assets/svg/logo.svg",
                  "style":{
                     "width":250
                  }
               },
               {
                  "id":"CategoryButtons",
                  "type":"LongButton",
                  "onText":"",
                  "offText":"",
                  "onSubText":"Custom",
                  "offSubText":"",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#f1f2f6"
                  }
               }
            ]
         },
         {
            "id":"CategoriesView",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"BackButton",
                  "type":"Button",
                  "text":"Back",
                  "style":{
                     "backgroundColor":"#ffffff",
                     "font":{
                        "fontSize":16,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"Header",
                  "type":"Text",
                  "text":"Manage Preferences",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"AcceptAllButton",
                  "type":"Button",
                  "text":"Accept All",
                  "style":{
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff",
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SaveButton",
                  "type":"Button",
                  "text":"Save & Exit",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"CategoriesHeader",
                  "type":"Text",
                  "text":"We and our partners process person data to:",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"600",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"PurposesHeader",
                  "type":"Text",
                  "text":"Purposes",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"PurposesDefinition",
                  "type":"Text",
                  "text":"You give affirmative action to indicate that we can use your data for this purpose",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"FeaturesHeader",
                  "type":"Text",
                  "text":"Features",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"FeaturesDefinition",
                  "type":"Text",
                  "text":"Features are a use of the data that you have already agreed to share with us",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SpecialPurposesHeader",
                  "type":"Text",
                  "text":"Special Purposes",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SpecialPurposesDefinition",
                  "type":"Text",
                  "text":"We have a need to use your data for this processing purpose that is required for us to deliver services to you",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SpecialFeaturesHeader",
                  "type":"Text",
                  "text":"Special features",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SpecialFeaturesDefintion",
                  "type":"Text",
                  "text":"Special Features are purposes that require your explicit content",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"CategoriesSlider",
                  "type":"Slider",
                  "onText":"CONSENT",
                  "offText":"LEGITIMATE INTEREST",
                  "style":{
                     "backgroundColor":"#d8d9dd",
                     "activeBackgroundColor":"#777a7e",
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "activeFont":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "color":"#ffffff",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"CategoryButton",
                  "type":"LongButton",
                  "onText":"On",
                  "offText":"Off",
                  "onSubText":"Custom",
                  "offSubText":"",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#f1f2f6"
                  }
               }
            ]
         },
         {
            "id":"VendorsView",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"HeaderText",
                  "type":"Text",
                  "text":"Our Partners",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"BackButton",
                  "type":"Button",
                  "text":"Back",
                  "style":{
                     "backgroundColor":"#ffffff",
                     "font":{
                        "fontSize":16,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"AcceptAllButton",
                  "type":"Button",
                  "text":"Accept All",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"SaveButton",
                  "type":"Button",
                  "text":"Save & Exit",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"VendorsHeader",
                  "type":"Text",
                  "text":"Partners",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"600",
                        "color":"#22243b",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               }
            ]
         },
         {
            "id":"CategoryDetailsView",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"BackButton",
                  "type":"Button",
                  "text":"Back",
                  "style":{
                     "backgroundColor":"#ffffff",
                     "font":{
                        "fontSize":16,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"OnButton",
                  "type":"Button",
                  "text":"On",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"OffButton",
                  "type":"Button",
                  "text":"Off",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"Header",
                  "type":"Text",
                  "text":"Partners",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"600",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"CategoryDescription",
                  "type":"Text",
                  "text":"",
                  "style":{
                     "font":{
                        "fontSize":10,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               }
            ]
         },
         {
            "id":"VendorDetails",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"BackButton",
                  "type":"Button",
                  "text":"Back",
                  "style":{
                     "backgroundColor":"#ffffff",
                     "font":{
                        "fontSize":16,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"OnText",
                  "type":"Text",
                  "text":"On",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"OffText",
                  "type":"Text",
                  "text":"Off",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#575757",
                     "onFocusTextColor":"#000000",
                     "onUnfocusTextColor":"#ffffff"
                  }
               },
               {
                  "id":"PurposesText",
                  "type":"Text",
                  "text":"Purposes",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"VendorLongButton",
                  "type":"LongButton",
                  "onText":"On",
                  "offText":"Off",
                  "onSubText":"Custom",
                  "offSubText":"Other",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     },
                     "onFocusBackgroundColor":"#ffffff",
                     "onUnfocusBackgroundColor":"#f1f2f6"
                  }
               },
               {
                  "id":"SpecialPurposes",
                  "type":"Text",
                  "text":"Special Purposes",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"SpecialFeatures",
                  "type":"Text",
                  "text":"Special Features",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"LegitInterests",
                  "type":"Text",
                  "text":"Legitimate Interests",
                  "style":{
                     "font":{
                        "fontSize":9,
                        "fontWeight":"400",
                        "color":"#828386",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"VendorDescription",
                  "type":"Text",
                  "text":"",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"QrInstructions",
                  "type":"Text",
                  "text":"To scan use your camera app or a QR code reader on your device",
                  "style":{
                     "font":{
                        "fontSize":28,
                        "fontWeight":"400",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               }
            ]
         },
         {
            "id":"PrivacyPolicyView",
            "type":"View",
            "style":{
               "backgroundColor":"#e5e8ef"
            },
            "components":[
               {
                  "id":"BackButton",
                  "type":"Button",
                  "text":"Back",
                  "style":{
                     "backgroundColor":"#ffffff",
                     "font":{
                        "fontSize":16,
                        "fontWeight":"400",
                        "color":"#000000",
                        "fontFamily":"arial, helvetica, sans-serif"
                     }
                  }
               },
               {
                  "id":"Body",
                  "type":"Text",
                  "text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam egestas at eros at ullamcorper. Aliquam porttitor urna augue, a bibendum risus elementum et. Proin suscipit pulvinar mauris in ullamcorper. Suspendisse et porttitor tortor, eu interdum augue. Nunc sollicitudin dui nunc, nec elementum lectus auctor at. Etiam laoreet lacus quis ante finibus pulvinar. Suspendisse potenti. Aenean ac suscipit nunc. Proin elementum elit id porttitor fringilla. Vivamus consequat scelerisque rhoncus. Suspendisse posuere id enim vel vulputate. Nulla consequat lobortis efficitur. Cras in augue quis neque laoreet condimentum at id felis. Mauris pretium viverra ligula, non ullamcorper lacus ullamcorper id.<br/><br/>Mauris et lorem eget erat fermentum ultrices. Pellentesque gravida, sem vel luctus condimentum, neque nibh lacinia neque, ac tempus sapien orci ut odio. Donec bibendum erat quis augue dignissim, rutrum fringilla sem egestas. Sed eu sem erat. Mauris sit amet lectus blandit, sollicitudin dui vel, fermentum velit. Suspendisse potenti. Sed vestibulum malesuada lorem posuere scelerisque. Suspendisse egestas nisl non neque posuere tincidunt. <br/><br/>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam egestas at eros at ullamcorper. Aliquam porttitor urna augue, a bibendum risus elementum et. Proin suscipit pulvinar mauris in ullamcorper. Suspendisse et porttitor tortor, eu interdum augue. Nunc sollicitudin dui nunc, nec elementum lectus auctor at. Etiam laoreet lacus quis ante finibus pulvinar. Suspendisse potenti. Aenean ac suscipit nunc. Proin elementum elit id porttitor fringilla. Vivamus consequat scelerisque rhoncus. Suspendisse posuere id enim vel vulputate. Nulla consequat lobortis efficitur. Cras in augue quis neque laoreet condimentum at id felis. Mauris pretium viverra ligula, non ullamcorper lacus ullamcorper id.",
                  "style":{

                  }
               }
            ]
         }
      ]
   }
}
"""
