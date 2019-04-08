(function () {
    function postToWebView (name, body) {
        window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });
    }
    window.JSReceiver = {
        onReceiveMessageData: function (willShowMessage, msgJSON) {
            postToWebView('onReceiveMessageData', { willShowMessage: willShowMessage, msgJSON: msgJSON });
        },
        onMessageChoiceSelect: function (choiceType) {
            postToWebView('onMessageChoiceSelect', { choiceType: choiceType });
        },
        onErrorOccurred: function (errorType) {
            postToWebView('onErrorOccurred', { errorType: errorType });
        },
        sendConsentData: function (euconsent, consentUUID) {
            postToWebView('interactionComplete', { euconsent: euconsent, consentUUID: consentUUID });
        },
        onPrivacyManagerChoiceSelect: function (choiceData) {
            postToWebView('onPrivacyManagerChoiceSelect', { choiceData: choiceData });
        },
        onMessageChoiceError: function (errorObj) {
            postToWebView('onMessageChoiceError', { error: errorObj.error });
        }
    };
})();
