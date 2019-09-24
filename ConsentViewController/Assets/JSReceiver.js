(function () {
    function postToWebView (name, body) {
        window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });
    }
    window.JSReceiver = {
        onMessageReady: function () {
            postToWebView('onMessageReady');
        },
        onMessageChoiceSelect: function (choice_id) {
            postToWebView('onMessageChoiceSelect', { choice_id: choice_id });
        },
        onPrivacyManagerAction: function (pmData) {
            postToWebView('onPrivacyManagerAction', { pmData: pmData });
        },
        onMessageChoiceError: function (errorObj) {
            postToWebView('onMessageChoiceError', { error: errorObj});
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
        }
    };
})();
