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
                it("has the raw value language code is EN") {
                    expect(SPMessageLanguage.English.rawValue) == "EN"
                }
            }

            context("Bulgarian") {
                it("has the raw value language code is BG") {
                    expect(SPMessageLanguage.Bulgarian.rawValue) == "BG"
                }
            }

            context("Catalan") {
                it("has the raw value language code is CA") {
                    expect(SPMessageLanguage.Catalan.rawValue) == "CA"
                }
            }

            context("Chinese") {
                it("has the raw value language code is ZH") {
                    expect(SPMessageLanguage.Chinese.rawValue) == "ZH"
                }
            }

            context("Croatian") {
                it("has the raw value language code is HR") {
                    expect(SPMessageLanguage.Croatian.rawValue) == "HR"
                }
            }

            context("Czech") {
                it("has the raw value language code is CS") {
                    expect(SPMessageLanguage.Czech.rawValue) == "CS"
                }
            }

            context("Danish") {
                it("has the raw value language code is DA") {
                    expect(SPMessageLanguage.Danish.rawValue) == "DA"
                }
            }

            context("Dutch") {
                it("has the raw value language code is NL") {
                    expect(SPMessageLanguage.Dutch.rawValue) == "NL"
                }
            }

            context("Estonian") {
                it("has the raw value language code is ET") {
                    expect(SPMessageLanguage.Estonian.rawValue) == "ET"
                }
            }

            context("Finnish") {
                it("has the raw value language code is FI") {
                    expect(SPMessageLanguage.Finnish.rawValue) == "FI"
                }
            }

            context("French") {
                it("has the raw value language code is FR") {
                    expect(SPMessageLanguage.French.rawValue) == "FR"
                }
            }

            context("Gaelic") {
                it("has the raw value language code is GD") {
                    expect(SPMessageLanguage.Gaelic.rawValue) == "GD"
                }
            }

            context("German") {
                it("has the raw value language code is DE") {
                    expect(SPMessageLanguage.German.rawValue) == "DE"
                }
            }

            context("Greek") {
                it("has the raw value language code is EL") {
                    expect(SPMessageLanguage.Greek.rawValue) == "EL"
                }
            }

            context("Hungarian") {
                it("has the raw value language code is HU") {
                    expect(SPMessageLanguage.Hungarian.rawValue) == "HU"
                }
            }

            context("Icelandic") {
                it("has the raw value language code is IS") {
                    expect(SPMessageLanguage.Icelandic.rawValue) == "IS"
                }
            }

            context("Italian") {
                it("has the raw value language code is IT") {
                    expect(SPMessageLanguage.Italian.rawValue) == "IT"
                }
            }

            context("Japanese") {
                it("has the raw value language code is JA") {
                    expect(SPMessageLanguage.Japanese.rawValue) == "JA"
                }
            }

            context("Latvian") {
                it("has the raw value language code is LV") {
                    expect(SPMessageLanguage.Latvian.rawValue) == "LV"
                }
            }

            context("Lithuanian") {
                it("has the raw value language code is LT") {
                    expect(SPMessageLanguage.Lithuanian.rawValue) == "LT"
                }
            }

            context("Norwegian") {
                it("has the raw value language code is NO") {
                    expect(SPMessageLanguage.Norwegian.rawValue) == "NO"
                }
            }

            context("Polish") {
                it("has the raw value language code is PL") {
                    expect(SPMessageLanguage.Polish.rawValue) == "PL"
                }
            }

            context("Portuguese") {
                it("has the raw value language code is PT") {
                    expect(SPMessageLanguage.Portuguese.rawValue) == "PT"
                }
            }

            context("Romanian") {
                it("has the raw value language code is RO") {
                    expect(SPMessageLanguage.Romanian.rawValue) == "RO"
                }
            }

            context("Russian") {
                it("has the raw value language code is RU") {
                    expect(SPMessageLanguage.Russian.rawValue) == "RU"
                }
            }

            context("Serbian_Cyrillic") {
                it("has the raw value language code is SR-CYRL") {
                    expect(SPMessageLanguage.Serbian_Cyrillic.rawValue) == "SR-CYRL"
                }
            }

            context("Serbian_Latin") {
                it("has the raw value language code is SR-LATN") {
                    expect(SPMessageLanguage.Serbian_Latin.rawValue) == "SR-LATN"
                }
            }

            context("Slovakian") {
                it("has the raw value language code is SK") {
                    expect(SPMessageLanguage.Slovakian.rawValue) == "SK"
                }
            }

            context("Slovenian") {
                it("has the raw value language code is SL") {
                    expect(SPMessageLanguage.Slovenian.rawValue) == "SL"
                }
            }

            context("Spanish") {
                it("has the raw value language code is ES") {
                    expect(SPMessageLanguage.Spanish.rawValue) == "ES"
                }
            }

            context("Swedish") {
                it("has the raw value language code is SV") {
                    expect(SPMessageLanguage.Swedish.rawValue) == "SV"
                }
            }

            context("Turkish") {
                it("has the raw value language code is TR") {
                    expect(SPMessageLanguage.Turkish.rawValue) == "TR"
                }
            }
        }
    }
}
