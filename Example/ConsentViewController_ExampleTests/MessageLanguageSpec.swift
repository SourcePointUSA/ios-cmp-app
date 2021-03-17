//
//  MessageLanguageSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 12/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class MessageLanguageSpec: QuickSpec {
    override func spec() {

        describe("MessageLanguage") {
            context("BrowserDefault") {
                it("has the raw value language code empty") {
                    expect(SPMessageLanguage.BrowserDefault.rawValue).to(equal(""))
                }
            }

            context("English") {
                it("has the raw value language code is EN") {
                    expect(SPMessageLanguage.English.rawValue).to(equal("EN"))
                }
            }

            context("Bulgarian") {
                it("has the raw value language code is BG") {
                    expect(SPMessageLanguage.Bulgarian.rawValue).to(equal("BG"))
                }
            }

            context("Catalan") {
                it("has the raw value language code is CA") {
                    expect(SPMessageLanguage.Catalan.rawValue).to(equal("CA"))
                }
            }

            context("Chinese") {
                it("has the raw value language code is ZH") {
                    expect(SPMessageLanguage.Chinese.rawValue).to(equal("ZH"))
                }
            }

            context("Croatian") {
                it("has the raw value language code is HR") {
                    expect(SPMessageLanguage.Croatian.rawValue).to(equal("HR"))
                }
            }

            context("Czech") {
                it("has the raw value language code is CS") {
                    expect(SPMessageLanguage.Czech.rawValue).to(equal("CS"))
                }
            }

            context("Danish") {
                it("has the raw value language code is DA") {
                    expect(SPMessageLanguage.Danish.rawValue).to(equal("DA"))
                }
            }

            context("Dutch") {
                it("has the raw value language code is NL") {
                    expect(SPMessageLanguage.Dutch.rawValue).to(equal("NL"))
                }
            }

            context("Estonian") {
                it("has the raw value language code is ET") {
                    expect(SPMessageLanguage.Estonian.rawValue).to(equal("ET"))
                }
            }

            context("Finnish") {
                it("has the raw value language code is FI") {
                    expect(SPMessageLanguage.Finnish.rawValue).to(equal("FI"))
                }
            }

            context("French") {
                it("has the raw value language code is FR") {
                    expect(SPMessageLanguage.French.rawValue).to(equal("FR"))
                }
            }

            context("Gaelic") {
                it("has the raw value language code is GD") {
                    expect(SPMessageLanguage.Gaelic.rawValue).to(equal("GD"))
                }
            }

            context("German") {
                it("has the raw value language code is DE") {
                    expect(SPMessageLanguage.German.rawValue).to(equal("DE"))
                }
            }

            context("Greek") {
                it("has the raw value language code is EL") {
                    expect(SPMessageLanguage.Greek.rawValue).to(equal("EL"))
                }
            }

            context("Hungarian") {
                it("has the raw value language code is HU") {
                    expect(SPMessageLanguage.Hungarian.rawValue).to(equal("HU"))
                }
            }

            context("Icelandic") {
                it("has the raw value language code is IS") {
                    expect(SPMessageLanguage.Icelandic.rawValue).to(equal("IS"))
                }
            }

            context("Italian") {
                it("has the raw value language code is IT") {
                    expect(SPMessageLanguage.Italian.rawValue).to(equal("IT"))
                }
            }

            context("Japanese") {
                it("has the raw value language code is JA") {
                    expect(SPMessageLanguage.Japanese.rawValue).to(equal("JA"))
                }
            }

            context("Latvian") {
                it("has the raw value language code is LV") {
                    expect(SPMessageLanguage.Latvian.rawValue).to(equal("LV"))
                }
            }

            context("Lithuanian") {
                it("has the raw value language code is LT") {
                    expect(SPMessageLanguage.Lithuanian.rawValue).to(equal("LT"))
                }
            }

            context("Norwegian") {
                it("has the raw value language code is NO") {
                    expect(SPMessageLanguage.Norwegian.rawValue).to(equal("NO"))
                }
            }

            context("Polish") {
                it("has the raw value language code is PL") {
                    expect(SPMessageLanguage.Polish.rawValue).to(equal("PL"))
                }
            }

            context("Portuguese") {
                it("has the raw value language code is PT") {
                    expect(SPMessageLanguage.Portuguese.rawValue).to(equal("PT"))
                }
            }

            context("Romanian") {
                it("has the raw value language code is RO") {
                    expect(SPMessageLanguage.Romanian.rawValue).to(equal("RO"))
                }
            }

            context("Russian") {
                it("has the raw value language code is RU") {
                    expect(SPMessageLanguage.Russian.rawValue).to(equal("RU"))
                }
            }

            context("Serbian_Cyrillic") {
                it("has the raw value language code is SR-CYRL") {
                    expect(SPMessageLanguage.Serbian_Cyrillic.rawValue).to(equal("SR-CYRL"))
                }
            }

            context("Serbian_Latin") {
                it("has the raw value language code is SR-LATN") {
                    expect(SPMessageLanguage.Serbian_Latin.rawValue).to(equal("SR-LATN"))
                }
            }

            context("Slovakian") {
                it("has the raw value language code is SK") {
                    expect(SPMessageLanguage.Slovakian.rawValue).to(equal("SK"))
                }
            }

            context("Slovenian") {
                it("has the raw value language code is SL") {
                    expect(SPMessageLanguage.Slovenian.rawValue).to(equal("SL"))
                }
            }

            context("Spanish") {
                it("has the raw value language code is ES") {
                    expect(SPMessageLanguage.Spanish.rawValue).to(equal("ES"))
                }
            }

            context("Swedish") {
                it("has the raw value language code is SV") {
                    expect(SPMessageLanguage.Swedish.rawValue).to(equal("SV"))
                }
            }

            context("Turkish") {
                it("has the raw value language code is TR") {
                    expect(SPMessageLanguage.Turkish.rawValue).to(equal("TR"))
                }
            }
        }
    }
}
