(function () {
  var postToWebView = function (webview) {
    return function(name, body) {
      webview.postMessage({ name: name, body: body || {} });
    }
  }(window.webkit.messageHandlers.JSReceiver);

  window.SDK = function (postToWebView) {
    return {
      onMessageReady: function() {
        postToWebView("onMessageReady");
      },
      onPMReady: function() {
        postToWebView("onPMReady");
      },
      onAction: function(action) { // action: { id: Int, type: Int }
        postToWebView("onAction", action);
      },
      onError: function(error) {
        postToWebView("onError", { error: error });
      },
      onMessageEvent: function(payload) {
        postToWebView("onMessageEvent", payload);
      }
    }
  }(postToWebView);

  var getActionFromMessage = function (actions) {
    var choiceAction = actions.filter(function (action) { return action.type === 'choice'; })[0] || {};
    var choiceData = choiceAction.data || {};
    return { id: choiceData.choice_id, type: choiceData.type };
  };

  var getActionFromPM = function (payload) {
    return {
      type: payload.actionType,
      consents: payload.consents || {
        vendors: { rejected: [], accepted: [] },
        categories: { rejected: [], accepted: [] }
      }
    };
  }

  var handleMessageEvent = function(SDK) {
    return function(name, payload) {
      switch(name) {
        case "sp.showMessage":
          SDK.onMessageReady();
          break;
        case "sp.hideMessage":
          payload.actionType ?
            SDK.onAction(getActionFromPM(payload)) :
            SDK.onAction(getActionFromMessage(payload));
          break;
        default:
          payload.action = name;
          SDK.onMessageEvent(payload);
      }
    }
  };

  var handleMessageOrPMEvent = function (SDK) {
    return function (event) {
      try {
        handleMessageEvent(SDK)(event.name, event.payload || event.actions || {});
      } catch (error) {
        SDK.onError(error);
      }
    }
  }(window.SDK);

  window.postMessage = handleMessageOrPMEvent
})();
