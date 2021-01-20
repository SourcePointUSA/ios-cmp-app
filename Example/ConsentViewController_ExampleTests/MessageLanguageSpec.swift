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
                    expect(MessageLanguage.BrowserDefault.rawValue).to(equal(""))
                }
            }

            context("English") {
                it("has the raw value language code is EN") {
                    expect(MessageLanguage.English.rawValue).to(equal("EN"))
                }
            }

            context("Bulgarian") {
                it("has the raw value language code is BG") {
                    expect(MessageLanguage.Bulgarian.rawValue).to(equal("BG"))
                }
            }

            context("Catalan") {
                it("has the raw value language code is CA") {
                    expect(MessageLanguage.Catalan.rawValue).to(equal("CA"))
                }
            }

            context("Chinese") {
                it("has the raw value language code is ZH") {
                    expect(MessageLanguage.Chinese.rawValue).to(equal("ZH"))
                }
            }

            context("Croatian") {
                it("has the raw value language code is HR") {
                    expect(MessageLanguage.Croatian.rawValue).to(equal("HR"))
                }
            }

            context("Czech") {
                it("has the raw value language code is CS") {
                    expect(MessageLanguage.Czech.rawValue).to(equal("CS"))
                }
            }

            context("Danish") {
                it("has the raw value language code is DA") {
                    expect(MessageLanguage.Danish.rawValue).to(equal("DA"))
                }
            }

            context("Dutch") {
                it("has the raw value language code is NL") {
                    expect(MessageLanguage.Dutch.rawValue).to(equal("NL"))
                }
            }

            context("Estonian") {
                it("has the raw value language code is ET") {
                    expect(MessageLanguage.Estonian.rawValue).to(equal("ET"))
                }
            }

            context("Finnish") {
                it("has the raw value language code is FI") {
                    expect(MessageLanguage.Finnish.rawValue).to(equal("FI"))
                }
            }

            context("French") {
                it("has the raw value language code is FR") {
                    expect(MessageLanguage.French.rawValue).to(equal("FR"))
                }
            }

            context("Gaelic") {
                it("has the raw value language code is GD") {
                    expect(MessageLanguage.Gaelic.rawValue).to(equal("GD"))
                }
            }

            context("German") {
                it("has the raw value language code is DE") {
                    expect(MessageLanguage.German.rawValue).to(equal("DE"))
                }
            }

            context("Greek") {
                it("has the raw value language code is EL") {
                    expect(MessageLanguage.Greek.rawValue).to(equal("EL"))
                }
            }

            context("Hungarian") {
                it("has the raw value language code is HU") {
                    expect(MessageLanguage.Hungarian.rawValue).to(equal("HU"))
                }
            }

            context("Icelandic") {
                it("has the raw value language code is IS") {
                    expect(MessageLanguage.Icelandic.rawValue).to(equal("IS"))
                }
            }

            context("Italian") {
                it("has the raw value language code is IT") {
                    expect(MessageLanguage.Italian.rawValue).to(equal("IT"))
                }
            }

            context("Japanese") {
                it("has the raw value language code is JA") {
                    expect(MessageLanguage.Japanese.rawValue).to(equal("JA"))
                }
            }

            context("Latvian") {
                it("has the raw value language code is LV") {
                    expect(MessageLanguage.Latvian.rawValue).to(equal("LV"))
                }
            }

            context("Lithuanian") {
                it("has the raw value language code is LT") {
                    expect(MessageLanguage.Lithuanian.rawValue).to(equal("LT"))
                }
            }

            context("Norwegian") {
                it("has the raw value language code is NO") {
                    expect(MessageLanguage.Norwegian.rawValue).to(equal("NO"))
                }
            }

            context("Polish") {
                it("has the raw value language code is PL") {
                    expect(MessageLanguage.Polish.rawValue).to(equal("PL"))
                }
            }

            context("Portuguese") {
                it("has the raw value language code is PT") {
                    expect(MessageLanguage.Portuguese.rawValue).to(equal("PT"))
                }
            }

            context("Romanian") {
                it("has the raw value language code is RO") {
                    expect(MessageLanguage.Romanian.rawValue).to(equal("RO"))
                }
            }

            context("Russian") {
                it("has the raw value language code is RU") {
                    expect(MessageLanguage.Russian.rawValue).to(equal("RU"))
                }
            }

            context("Serbian_Cyrillic") {
                it("has the raw value language code is SR-CYRL") {
                    expect(MessageLanguage.Serbian_Cyrillic.rawValue).to(equal("SR-CYRL"))
                }
            }

            context("Serbian_Latin") {
                it("has the raw value language code is SR-LATN") {
                    expect(MessageLanguage.Serbian_Latin.rawValue).to(equal("SR-LATN"))
                }
            }

            context("Slovakian") {
                it("has the raw value language code is SK") {
                    expect(MessageLanguage.Slovakian.rawValue).to(equal("SK"))
                }
            }

            context("Slovenian") {
                it("has the raw value language code is SL") {
                    expect(MessageLanguage.Slovenian.rawValue).to(equal("SL"))
                }
            }

            context("Spanish") {
                it("has the raw value language code is ES") {
                    expect(MessageLanguage.Spanish.rawValue).to(equal("ES"))
                }
            }

            context("Swedish") {
                it("has the raw value language code is SV") {
                    expect(MessageLanguage.Swedish.rawValue).to(equal("SV"))
                }
            }

            context("Turkish") {
                it("has the raw value language code is TR") {
                    expect(MessageLanguage.Turkish.rawValue).to(equal("TR"))
                }
            }
        }
    }
}
