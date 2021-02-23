(function () {
  var postToWebView = function (webview) {
    return function(name, body) {
      webview.postMessage({ name: name, body: body || {} });
    };
  }(window.webkit.messageHandlers.GDPRJSReceiver);

  window.SDK = function (postToWebView) {
    return {
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
      consentLanguage : eventData.consentLanguage
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
            SDK.onAction({ type: eventData.actionType, payload: eventData.payload, consentLanguage: eventData.consentLanguage }) :
            SDK.onAction(getActionFromMessage(eventData));
          break;
        default:
          eventData.payload.action = eventData.name;
          SDK.onMessageEvent(eventData.payload);
      }
    };
  };
    
  function isFromPM(event) {
    event.settings = event.settings || {}
    return event.fromPM || event.settings.vendorList
  }

    function isError(event) {
        return event.stackTrace !== undefined
    }

    function handleError(event) {
        window.SDK.onError({
            code: event.code,
            title: event.title,
            stackTrace: event.stackTrace
        })
    }

  var handleMessageOrPMEvent = function (SDK) {
    return function (event) {
      try {
          isError(event) ?
            handleError(event) :
            handleMessageEvent(SDK)({
              name: event.name,
              fromPM: isFromPM(event),
              actionType: event.actionType,
              payload: event.payload || event.actions || {},
              consentLanguage: event.consentLanguage
            });
      } catch (error) {
        SDK.onError(error);
      }
    };
  }(window.SDK);

  window.postMessage = handleMessageOrPMEvent;
})();
