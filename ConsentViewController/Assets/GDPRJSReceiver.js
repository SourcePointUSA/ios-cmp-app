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

  var getActionFromMessage = function (actions) {
    var choiceAction = actions.filter(function (action) { return action.type === 'choice'; })[0] || {};
    var choiceData = choiceAction.data || {};
    return { id: String(choiceData.choice_id), type: choiceData.type };
  };

  var getActionFromPM = function (payload, actionType) {
    var _id = function(consent) { return consent._id; };
    var consents = payload.consents && {
        vendors: {
            accepted: payload.vendors.map(_id)
        },
        categories: {
            accepted: payload.categories.map(_id)
        }
    };
    return {
      type: actionType,
      consents: consents || {
        vendors: { accepted: [] },
        categories: { accepted: [] }
      }
    };
  };

  var handleMessageEvent = function(SDK) {
    return function(eventData) {
        debugger
      switch(eventData.name) {
        case "sp.showMessage":
          SDK.onMessageReady();
          break;
        case "sp.hideMessage":
          eventData.fromPM ?
            SDK.onAction(getActionFromPM(eventData.payload, eventData.actionType)) :
            SDK.onAction(getActionFromMessage(eventData.payload));
          break;
        default:
          eventData.payload.action = eventData.name;
          SDK.onMessageEvent(eventData.payload);
      }
    };
  };

  var handleMessageOrPMEvent = function (SDK) {
    return function (event) {
      try {
        handleMessageEvent(SDK)({
          name: event.name,
          fromPM: event.fromPM,
          actionType: event.actionType,
          payload: event.payload || event.actions || {}
        });
      } catch (error) {
        SDK.onError(error);
      }
    };
  }(window.SDK);

  window.postMessage = handleMessageOrPMEvent;
})();
