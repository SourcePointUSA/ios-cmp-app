(function () {
    console.log("[JSReceiver] Loading JSReceiver.js file");
    function postToWebView (name, body) {
        console.log("[JSReceiver] postToWebView: "+name+body);
        window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });
    }
    window.JSReceiver = {
        onReceiveMessageData: function (messageData) {
            console.log("[JSReceiver] onReceiveMessageData: "+messageData);
            postToWebView('onReceiveMessageData', JSON.parse(messageData));
        },
        onMessageChoiceSelect: function (choiceType) {
            console.log("[JSReceiver] onMessageChoiceSelect: "+choiceType);
            postToWebView('onMessageChoiceSelect', { choiceType: choiceType });
        },
        onErrorOccurred: function (errorType) {
            console.log("[JSReceiver] onErrorOccurred: "+errorType);
            postToWebView('onErrorOccurred', { errorType: errorType });
        },
        sendConsentData: function (euconsent, consentUUID) {
            console.log("[JSReceiver] sendConsentData: "+"euconsent"+euconsent+"consentUUID"+consentUUID);
            postToWebView('onInteractionComplete', { euconsent: euconsent, consentUUID: consentUUID });
        },
        onPrivacyManagerChoiceSelect: function (choiceData) {
            console.log("[JSReceiver] onPrivacyManagerChoiceSelect: "+choiceData);
            postToWebView('onPrivacyManagerChoiceSelect', { choiceData: choiceData });
        },
        onMessageChoiceError: function (errorObj) {
            console.log("[JSReceiver] onMessageChoiceError: "+errorObj);
            postToWebView('onMessageChoiceError', { error: errorObj.error });
        }
    };
    console.log("[JSReceiver] Done Loading JSReceiver.js file");
})();
