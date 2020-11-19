window.getAuthId = function getAuthId () {
    return document.cookie
        .split("; ")
        .filter(c => c.startsWith('authId='))
        .map(c => c.replace('authId=', ''))[0]
}

getAuthId()
