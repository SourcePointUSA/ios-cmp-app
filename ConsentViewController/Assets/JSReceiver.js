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

  var getActionFrom = function (payload) {
    var actions = payload.actions || [];
    var choiceAction = actions.filter(function (action) { return action.type === 'choice'; })[0] || {};
    var choiceData = choiceAction.data || {};
    return { id: choiceData.choice_id, type: choiceData.type };
  };
 
  var handlePMEvent = function(SDK) {
    return function(eventName, eventPayload) {
      var payload = eventPayload || {};
      switch(eventName) {
        case "sp.pmComplete":
          SDK.onAction({ id: 99, type: 99 }); // TODO: change to real id/type when the new PM is implemented
          break;
        case "sp.cancel":
          SDK.onAction({ id: 98, type: 98 }); // TODO: change to real id/type when the new PM is implemented
          break;
        case "sp.pmLoaded":
          SDK.onPMReady();
          break;
        case "sp.error":
          SDK.onError();
          break;
        default:
          payload.action = eventName;
          SDK.onMessageEvent(payload);
      }
    }
  };

  var handleMessageEvent = function(SDK) {
    return function(eventName, eventPayload) {
      var payload = eventPayload || {}
      switch(eventName) {
        case "sp.showMessage":
          SDK.onMessageReady();
          break;
        case "sp.hideMessage":
          SDK.onAction(getActionFrom(payload));
          break;
        default:
          payload.action = eventName;
          SDK.onMessageEvent(payload);
      }
    }
  };

  var handleMessageOrPMEvent = function (SDK) {
    return function (event) {
      try {
        var payload = event.data || {};
        var eventName = payload.name;
        payload.action ?
          handlePMEvent(SDK)(payload.action, payload.data) :
          handleMessageEvent(SDK)(eventName, payload);
      } catch (error) { SDK.onError(error); }
    }
  }(window.SDK);

  window.addEventListener('message', handleMessageOrPMEvent);
})();
