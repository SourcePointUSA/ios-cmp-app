(function () {
    function postToWebView (name, body) {
        window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });
    }
    window.JSReceiver = {
        onMessageReady: function () {
            postToWebView('onMessageReady');
        },
        onMessageChoiceSelect: function (choiceId) {
            postToWebView('onMessageChoiceSelect', { choiceId: choiceId });
        },
        onPrivacyManagerAction: function (pmData) {
            postToWebView('onPrivacyManagerAction', { pmData: pmData });
        },
        onMessageChoiceError: function (errorObj) {
            postToWebView('onMessageChoiceError', { error: errorObj });
        },
        onConsentReady: function (consentUUID, euconsent) {
            postToWebView('onConsentReady', { consentUUID: consentUUID, euconsent: euconsent });
        },
        onErrorOccurred: function (errorType) {
            postToWebView('onErrorOccurred', { errorType: errorType });
        },
        onPMCancel: function () {
            postToWebView('onPMCancel');
        },
        onSPPMObjectReady: function () {
            postToWebView('onSPPMObjectReady');
        },
        xhrLog: function (logPayload) {
            postToWebView('xhrLog', JSON.parse(logPayload));
        }
    };
})();
