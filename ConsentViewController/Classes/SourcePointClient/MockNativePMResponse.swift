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
   "message_json": {
    "id":"Root",
    "type":"NativeOtt",
    "settings":{
       "supportedLanguages":[
          "EN"
       ],
       "defaultLanguage":"EN",
       "vendorList":null
    },
    "children":[
       {
          "id":"HomeView",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"HeaderText",
                "type":"NativeText",
                "settings":{
                   "text":"Privacy",
                   "style":{
                      "font":{
                         "fontSize":28,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"LogoImage",
                "type":"NativeImage",
                "name":"Logo",
                "settings":{
                   "url":"https://i.pinimg.com/originals/5a/ae/50/5aae503e4f037a5a4375944d8861fb6a.png",
                   "style":{
                      "width":170
                   }
                }
             },
             {
                "id":"CategoriesDescriptionText",
                "type":"NativeText",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"AcceptAllButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Accept",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"NavCategoriesButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Manage Preferences",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"NavVendorsButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Our Partners",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"NavPrivacyPolicyButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Privacy Policy",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"PublisherDescription",
                "type":"NativeText",
                "name":"Publisher Description",
                "settings":{
                   "text":"We and our partners use device identifiers or similar technologies on the app and to collect and use personal data (e.g., your IP address). If you consent, the device identifiers or or the information can be stored locally or accessed on your device for the purpose described below. You can click “Accept All” or “manage Preferences” to customize your consent. For some of the purposes below, our partners use precise geolocation data, and they also rely on legitimate interests to process personal data. View our partners to see the purposes they believe for you can change have legitimate interest & you can change your settings at any time.",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"CategoryButtons",
                "type":"LongButton",
                "settings":{
                   "onText":"",
                   "offText":"",
                   "customText":"",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6"
                   }
                }
             }
          ]
       },
       {
          "id":"CategoriesView",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"BackButton",
                "type":"NativeButton",
                "settings":{
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
                }
             },
             {
                "id":"Header",
                "type":"NativeText",
                "settings":{
                   "text":"Manage Preferences",
                   "style":{
                      "font":{
                         "fontSize":28,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"LogoImage",
                "type":"NativeImage",
                "name":"Logo",
                "settings":{
                   "src":"https://i.pinimg.com/originals/5a/ae/50/5aae503e4f037a5a4375944d8861fb6a.png",
                   "style":{
                      "width":170
                   }
                }
             },
             {
                "id":"CategoriesDescriptionText",
                "type":"NativeText",
                "name":"Categories Description",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"AcceptAllButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Accept All",
                   "style":{
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff",
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SaveButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Save & Exit",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"CategoriesHeader",
                "type":"NativeText",
                "settings":{
                   "text":"We and our partners process person data to:",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"600",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"PurposesHeader",
                "type":"NativeText",
                "settings":{
                   "text":"Purposes",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"PurposesDefinition",
                "type":"NativeText",
                "settings":{
                   "text":"You give affirmative action to indicate that we can use your data for this purpose",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"FeaturesHeader",
                "type":"NativeText",
                "settings":{
                   "text":"Features",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"FeaturesDefinition",
                "type":"NativeText",
                "settings":{
                   "text":"Features are a use of the data that you have already agreed to share with us",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialPurposesHeader",
                "type":"NativeText",
                "settings":{
                   "text":"Special Purposes",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialPurposesDefinition",
                "type":"NativeText",
                "settings":{
                   "text":"We have a need to use your data for this processing purpose that is required for us to deliver services to you",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialFeaturesHeader",
                "type":"NativeText",
                "settings":{
                   "text":"Special features",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialFeaturesDefintion",
                "type":"NativeText",
                "settings":{
                   "text":"Special Features are purposes that require your explicit content",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"CategoriesSlider",
                "type":"Slider",
                "settings":{
                   "leftText":"CONSENT",
                   "rightText":"LEGITIMATE INTEREST",
                   "style":{
                      "backgroundColor":"#d8d9dd",
                      "activeBackgroundColor":"#777a7e",
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "activeFont":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#ffffff",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"CategoryButton",
                "type":"LongButton",
                "settings":{
                   "onText":"On",
                   "offText":"Off",
                   "customText":"Custom",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6"
                   }
                }
             }
          ]
       },
       {
          "id":"VendorsView",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"HeaderText",
                "type":"NativeText",
                "settings":{
                   "text":"Our Partners",
                   "style":{
                      "font":{
                         "fontSize":28,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"BackButton",
                "type":"NativeButton",
                "settings":{
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
                }
             },
             {
                "id":"VendorsSlider",
                "type":"Slider",
                "name":"Vendors Slider",
                "settings":{
                   "leftText":"CONSENT",
                   "rightText":"LEGITIMATE INTEREST",
                   "magnifyingGlassBackgroundColor":"#777a7e",
                   "magnifyingGlassColor":"#ffffff",
                   "style":{
                      "backgroundColor":"#d8d9dd",
                      "activeBackgroundColor":"#777a7e",
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "activeFont":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#ffffff",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"LogoImage",
                "type":"NativeImage",
                "name":"Logo",
                "settings":{
                   "src":"https://i.pinimg.com/originals/5a/ae/50/5aae503e4f037a5a4375944d8861fb6a.png",
                   "style":{
                      "width":170
                   }
                }
             },
             {
                "id":"VendorDescription",
                "type":"NativeText",
                "name":"Vendors Description",
                "settings":{
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
             },
             {
                "id":"AcceptAllButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Accept All",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"SaveButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Save & Exit",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"VendorsHeader",
                "type":"NativeText",
                "settings":{
                   "text":"Partners",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"600",
                         "color":"#22243b",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"VendorButton",
                "type":"LongButton",
                "name":"Vendors Buttons",
                "settings":{
                   "onText":"On",
                   "offText":"Off",
                   "customText":"Custom",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif",
                         "color":"#060606"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6"
                   }
                }
             }
          ]
       },
       {
          "id":"CategoryDetailsView",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"BackButton",
                "type":"NativeButton",
                "settings":{
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
                }
             },
             {
                "id":"HeaderText",
                "type":"NativeText",
                "name":"Category Name",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":16,
                         "fontWeight":"600",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"OnButton",
                "type":"NativeButton",
                "settings":{
                   "text":"On",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"OffButton",
                "type":"NativeButton",
                "settings":{
                   "text":"Off",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"CategoryDescription",
                "type":"NativeText",
                "name":"Categories Description",
                "settings":{
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
             },
             {
                "id":"CategoryDescription",
                "type":"NativeText",
                "settings":{
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
             },
             {
                "id":"VendorsHeader",
                "type":"NativeText",
                "name":"Vendors Header",
                "settings":{
                   "text":"Partners",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"600",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"VendorLongButton",
                "type":"LongButton",
                "name":"Vendor Buttons",
                "settings":{
                   "onText":"",
                   "offText":"",
                   "customText":"Other",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6"
                   }
                }
             }
          ]
       },
       {
          "id":"VendorDetails",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"BackButton",
                "type":"NativeButton",
                "settings":{
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
                }
             },
             {
                "id":"HeaderText",
                "type":"NativeText",
                "name":"Header Text",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":28,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"OnButton",
                "type":"NativeButton",
                "name":"On Button",
                "settings":{
                   "text":"On",
                   "style":{
                      "font":{
                         "fontSize":16,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"OffButton",
                "type":"NativeButton",
                "name":"Off Button",
                "settings":{
                   "text":"Off",
                   "style":{
                      "font":{
                         "fontSize":16,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#575757",
                      "onFocusTextColor":"#000000",
                      "onUnfocusTextColor":"#ffffff"
                   }
                }
             },
             {
                "id":"VendorDescription",
                "type":"NativeText",
                "name":"Vendor Description",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"PurposesText",
                "type":"NativeText",
                "settings":{
                   "text":"Purposes",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"VendorLongButton",
                "type":"LongButton",
                "settings":{
                   "onText":"On",
                   "offText":"Off",
                   "customText":"Other",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "onFocusBackgroundColor":"#ffffff",
                      "onUnfocusBackgroundColor":"#f1f2f6"
                   }
                }
             },
             {
                "id":"FeaturesText",
                "type":"NativeText",
                "name":"Features Text",
                "settings":{
                   "text":"Features",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialPurposes",
                "type":"NativeText",
                "settings":{
                   "text":"Special Purposes",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"SpecialFeatures",
                "type":"NativeText",
                "settings":{
                   "text":"Special Features",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"LegitInterests",
                "type":"NativeText",
                "settings":{
                   "text":"Legitimate Interests",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"VendorDescription",
                "type":"NativeText",
                "settings":{
                   "text":"",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"CookieInfoText",
                "type":"NativeText",
                "name":"Cookie Info Text",
                "settings":{
                   "text":"Cookie Information",
                   "style":{
                      "font":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"CookieTable",
                "type":"CookieTable",
                "name":"Cookie Table",
                "settings":{
                   "nameText":"Cookie Name",
                   "categoryText":"Category",
                   "domainText":"Domain",
                   "durationText":"Duration",
                   "style":{
                      "backgroundColor":"#f1f2f6",
                      "linkColor":"#0294ff",
                      "font":{
                         "fontSize":12,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      },
                      "headerFont":{
                         "fontSize":9,
                         "fontWeight":"400",
                         "color":"#828386",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"QrInstructions",
                "type":"NativeText",
                "settings":{
                   "text":"To scan use your camera app or a QR code reader on your device",
                   "style":{
                      "font":{
                         "fontSize":14,
                         "fontWeight":"400",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             }
          ]
       },
       {
          "id":"PrivacyPolicyView",
          "type":"NativeView",
          "settings":{
             "style":{
                "backgroundColor":"#e5e8ef"
             }
          },
          "children":[
             {
                "id":"BackButton",
                "type":"NativeButton",
                "settings":{
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
                }
             },
             {
                "id":"HeaderText",
                "type":"NativeText",
                "name":"Header Text",
                "settings":{
                   "text":"Privacy Policy",
                   "style":{
                      "font":{
                         "fontSize":28,
                         "fontWeight":"400",
                         "color":"#000000",
                         "fontFamily":"arial, helvetica, sans-serif"
                      }
                   }
                }
             },
             {
                "id":"LogoImage",
                "type":"NativeImage",
                "name":"Logo",
                "settings":{
                   "src":"https://i.pinimg.com/originals/5a/ae/50/5aae503e4f037a5a4375944d8861fb6a.png",
                   "style":{
                      "width":265
                   }
                }
             },
             {
                "id":"Body",
                "type":"NativeText",
                "settings":{
                   "text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam egestas at eros at ullamcorper. Aliquam porttitor urna augue, a bibendum risus elementum et. Proin suscipit pulvinar mauris in ullamcorper. Suspendisse et porttitor tortor, eu interdum augue. Nunc sollicitudin dui nunc, nec elementum lectus auctor at. Etiam laoreet lacus quis ante finibus pulvinar. Suspendisse potenti. Aenean ac suscipit nunc. Proin elementum elit id porttitor fringilla. Vivamus consequat scelerisque rhoncus. Suspendisse posuere id enim vel vulputate. Nulla consequat lobortis efficitur. Cras in augue quis neque laoreet condimentum at id felis. Mauris pretium viverra ligula, non ullamcorper lacus ullamcorper id. Mauris et lorem eget erat fermentum ultrices. Pellentesque gravida, sem vel luctus condimentum, neque nibh lacinia neque, ac tempus sapien orci ut odio. Donec bibendum erat quis augue dignissim, rutrum fringilla sem egestas. Sed eu sem erat. Mauris sit amet lectus blandit, sollicitudin dui vel, fermentum velit. Suspendisse potenti. Sed vestibulum malesuada lorem posuere scelerisque. Suspendisse egestas nisl non neque posuere tincidunt. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam egestas at eros at ullamcorper. Aliquam porttitor urna augue, a bibendum risus elementum et. Proin suscipit pulvinar mauris in ullamcorper. Suspendisse et porttitor tortor, eu interdum augue. Nunc sollicitudin dui nunc, nec elementum lectus auctor at. Etiam laoreet lacus quis ante finibus pulvinar. Suspendisse potenti. Aenean ac suscipit nunc. Proin elementum elit id porttitor fringilla. Vivamus consequat scelerisque rhoncus. Suspendisse posuere id enim vel vulputate. Nulla consequat lobortis efficitur. Cras in augue quis neque laoreet condimentum at id felis. Mauris pretium viverra ligula, non ullamcorper lacus ullamcorper id.",
                   "style":{

                   }
                }
             }
          ]
       }
    ]
 }
}
"""
