//
//  MessageLanguageSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 12/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
// swiftlint:disable function_body_length

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPMessageLanguageSpec: QuickSpec {
    override func spec() {
        describe("SPMessageLanguage") {
            context("BrowserDefault") {
                it("has the raw value language code empty") {
                    expect(SPMessageLanguage.BrowserDefault.rawValue) == ""
                }
            }

            context("English") {
                it("has the raw value language code is en") {
                    expect(SPMessageLanguage.English.rawValue) == "en"
                }
            }

            context("Bulgarian") {
                it("has the raw value language code is bg") {
                    expect(SPMessageLanguage.Bulgarian.rawValue) == "bg"
                }
            }

            context("Catalan") {
                it("has the raw value language code is ca") {
                    expect(SPMessageLanguage.Catalan.rawValue) == "ca"
                }
            }

            context("Chinese") {
                it("has the raw value language code is zh") {
                    expect(SPMessageLanguage.Chinese_Simplified.rawValue) == "zh"
                }
            }

            context("Croatian") {
                it("has the raw value language code is hr") {
                    expect(SPMessageLanguage.Croatian.rawValue) == "hr"
                }
            }

            context("Czech") {
                it("has the raw value language code is cs") {
                    expect(SPMessageLanguage.Czech.rawValue) == "cs"
                }
            }

            context("Danish") {
                it("has the raw value language code is da") {
                    expect(SPMessageLanguage.Danish.rawValue) == "da"
                }
            }

            context("Dutch") {
                it("has the raw value language code is nl") {
                    expect(SPMessageLanguage.Dutch.rawValue) == "nl"
                }
            }

            context("Estonian") {
                it("has the raw value language code is et") {
                    expect(SPMessageLanguage.Estonian.rawValue) == "et"
                }
            }

            context("Finnish") {
                it("has the raw value language code is fi") {
                    expect(SPMessageLanguage.Finnish.rawValue) == "fi"
                }
            }

            context("French") {
                it("has the raw value language code is fr") {
                    expect(SPMessageLanguage.French.rawValue) == "fr"
                }
            }

            context("Gaelic") {
                it("has the raw value language code is gd") {
                    expect(SPMessageLanguage.Galician.rawValue) == "gl"
                }
            }

            context("German") {
                it("has the raw value language code is de") {
                    expect(SPMessageLanguage.German.rawValue) == "de"
                }
            }

            context("Greek") {
                it("has the raw value language code is el") {
                    expect(SPMessageLanguage.Greek.rawValue) == "el"
                }
            }

            context("Hungarian") {
                it("has the raw value language code is hu") {
                    expect(SPMessageLanguage.Hungarian.rawValue) == "hu"
                }
            }

            context("Italian") {
                it("has the raw value language code is it") {
                    expect(SPMessageLanguage.Italian.rawValue) == "it"
                }
            }

            context("Japanese") {
                it("has the raw value language code is ja") {
                    expect(SPMessageLanguage.Japanese.rawValue) == "ja"
                }
            }

            context("Latvian") {
                it("has the raw value language code is lv") {
                    expect(SPMessageLanguage.Latvian.rawValue) == "lv"
                }
            }

            context("Lithuanian") {
                it("has the raw value language code is lt") {
                    expect(SPMessageLanguage.Lithuanian.rawValue) == "lt"
                }
            }

            context("Norwegian") {
                it("has the raw value language code is no") {
                    expect(SPMessageLanguage.Norwegian.rawValue) == "no"
                }
            }

            context("Polish") {
                it("has the raw value language code is pl") {
                    expect(SPMessageLanguage.Polish.rawValue) == "pl"
                }
            }

            context("Portuguese") {
                it("has the raw value language code is pt") {
                    expect(SPMessageLanguage.Portuguese_Brazil.rawValue) == "pt-br"
                }
            }

            context("Romanian") {
                it("has the raw value language code is ro") {
                    expect(SPMessageLanguage.Romanian.rawValue) == "ro"
                }
            }

            context("Russian") {
                it("has the raw value language code is ru") {
                    expect(SPMessageLanguage.Russian.rawValue) == "ru"
                }
            }

            context("Serbian_Cyrillic") {
                it("has the raw value language code is sr-cyrl") {
                    expect(SPMessageLanguage.Serbian_Cyrillic.rawValue) == "sr-cyrl"
                }
            }

            context("Serbian_Latin") {
                it("has the raw value language code is sr-latn") {
                    expect(SPMessageLanguage.Serbian_Latin.rawValue) == "sr-latn"
                }
            }

            context("Slovakian") {
                it("has the raw value language code is sk") {
                    expect(SPMessageLanguage.Slovak.rawValue) == "sk"
                }
            }

            context("Slovenian") {
                it("has the raw value language code is sl") {
                    expect(SPMessageLanguage.Slovenian.rawValue) == "sl"
                }
            }

            context("Spanish") {
                it("has the raw value language code is es") {
                    expect(SPMessageLanguage.Spanish.rawValue) == "es"
                }
            }

            context("Swedish") {
                it("has the raw value language code is sv") {
                    expect(SPMessageLanguage.Swedish.rawValue) == "sv"
                }
            }

            context("Turkish") {
                it("has the raw value language code is tr") {
                    expect(SPMessageLanguage.Turkish.rawValue) == "tr"
                }
            }

            context("Basque") {
                it("has the raw value language code is tr") {
                    expect(SPMessageLanguage.Basque.rawValue) == "eu"
                }
            }
        }
    }
}
