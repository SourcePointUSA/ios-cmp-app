var postToWebView = function (webview) {
    return function(name, body) {
        webview.postMessage({ name: name, body: body || {} });
    };
}(window.webkit.messageHandlers.SPJSReceiver);

window.SDK = function (postToWebView) {
    return {
    loadMessage: function(messageJSON) {
        postToWebView("before");
        var messagePayload = Object.assign({}, messageJSON, {
            name: "sp.loadMessage",
            fromNativeSDK: true
        });
        window.postMessage(messagePayload);
        postToWebView("after");
    },
    onMessageReady: function() {
        postToWebView("onMessageReady");
    },
    onPMReady: function() {
        postToWebView("onPMReady");
    },
    onAction: function(action) {
        postToWebView("onAction", action);
    },
    onError: function(error) {
        postToWebView("onError", { error: error });
    },
    onMessageEvent: function(payload) {
        postToWebView("onMessageEvent", payload);
    }
    };
}(postToWebView);

var getActionFromMessage = function (eventData) {
    var choiceAction = eventData.payload.filter(function (action) {
        return action.type === 'choice';
    })[0] || {};
    var choiceData = choiceAction.data || {};
    return {
    id: String(choiceData.choice_id),
    type: choiceData.type,
    payload: { pm_url: choiceData.iframe_url },
    consentLanguage: eventData.consentLanguage
    };
};

var handleMessageEvent = function(SDK) {
    return function(eventData) {
        switch(eventData.name) {
            case "sp.showMessage":
                eventData.fromPM ? SDK.onPMReady() : SDK.onMessageReady();
                break;
            case "sp.hideMessage":
                eventData.fromPM ?
                SDK.onAction({
                type: eventData.actionType,
                payload: eventData.payload,
                consentLanguage: eventData.consentLanguage
                }) :
                SDK.onAction(getActionFromMessage(eventData));
                break;
            default:
                eventData.payload.action = eventData.name;
                SDK.onMessageEvent(eventData.payload);
        }
    };
};

function isFromPM(event) {
    event.settings = event.settings || {};
    return event.fromPM || event.settings.vendorList;
}

function isError(event) {
    return event.stackTrace !== undefined;
}

function handleError(event) {
    window.SDK.onError({
    code: event.code,
    title: event.title,
    stackTrace: event.stackTrace
    });
}

var handleMessageOrPMEvent = function (SDK) {
    return function ({ data }) {
        try {
            isError(event) ? handleError(data) : handleMessageEvent(SDK)({
            name: event.name,
            fromPM: isFromPM(data),
            actionType: data.actionType,
            payload: data.payload || data.actions || {},
            consentLanguage: data.consentLanguage
            });
        } catch (error) {
            window.SDK.onError(error);
        }
    };
};

window.addEventListener("message", handleMessageOrPMEvent(window.SDK));
