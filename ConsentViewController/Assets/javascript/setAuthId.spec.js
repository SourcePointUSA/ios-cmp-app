require("./setAuthId")

describe("setAuthId", () => {
    it("should set the authId cookie", () => {
        window.setAuthId("foo")
        expect(document.cookie).toContain("authId=foo")
    })
})
