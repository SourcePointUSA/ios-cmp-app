require("./getAuthId")

describe("getAuthId", () => {
    describe("when authId cookie is not present", () => {
        it("should return null", () => {
            expect(window.getAuthId()).toBeUndefined()
        })
    })

    describe("when authId cookie has a value", () => {
        it("should return its value", () => {
            document.cookie = "authId=foo"
            expect(window.getAuthId()).toEqual("foo")
        })
    })
})
