/** Script allowing to use the Web SDK from a WebView */

// Check if SDK is still initializing and should not display the notice yet
var initializationInProgress = true;
// Check if notice was initially displayed
var noticeDisplayed = false;

/**
 * Initialize the SDK with the specified configuration
 */
function initSdk(config, gvl, sdkURL, languageCode, isUnderage) {
  if (config) {
    // Set the global window configuration to the config object
    window.didomiConfig = prepareConfigFromMobile(config, languageCode, isUnderage);

    // Set the location properties
    window.didomiCountry = extractCountryFromMobileConfig(config);
    window.didomiRegion = extractRegionFromMobileConfig(config);
    
    // If app, vendors, and iab exist, set the vendorList property
    if (
      window.didomiConfig.app &&
      window.didomiConfig.app.vendors &&
      window.didomiConfig.app.vendors.iab
    ) {
      window.didomiConfig.app.vendors.iab.vendorList = prepareGVLFromMobile(gvl);
    }
  }

  var script = document.createElement("script");
  script.setAttribute("type", "text/javascript");
  script.setAttribute("src", sdkURL);

  document.getElementsByTagName("head")[0].appendChild(script);

  addReadyHandler();
  addErrorHandler();
}

// Used to trigger a "ready" message when the Web SDK is ready.
function addReadyHandler() {
  window.didomiOnReady = window.didomiOnReady || [];
  window.didomiOnReady.push(function () {
    if (isIOS()) {
      window.webkit.messageHandlers.ready.postMessage("");
    }
  });
}

// Used to detect when there's an error loading files so native can dismiss the notice if required.
function addErrorHandler() {
  window.addEventListener('error', function(event) {
    if (event.target.tagName === 'IMG' || event.target.tagName === 'SCRIPT' || event.target.tagName === 'LINK') {
      const errorObject = {
        url: event.target.src || event.target.href,
        tagName: event.target.tagName,
        errorMessage: event.message || "Resource failed to load"
      };
      if (isIOS()) {
        window.webkit.messageHandlers.errorLoadingResource.postMessage(errorObject);
      } else {
        androidInterface.onErrorLoadingResource(JSON.stringify(errorObject));
      }
    }
  }, true);
}

/**
 * Open the notice screen
 */
function openNotice(userStatus, options) {
  var hasDeepLink = options != null && options.deepLinkView != null
  if (!hasDeepLink) {
      initializationInProgress = false
  }
  handleWebSDKEvents();
  window.didomiOnReady = window.didomiOnReady || [];
  window.didomiOnReady.push(function (Didomi) {
    Didomi.setUserStatus(userStatus);
    if (hasDeepLink) {
      initializationInProgress = false;
      Didomi.preferences.show(
        options.deepLinkView == 0 ? "purposes" : "vendors"
      );
    } else {
      Didomi.notice.show();
    }
    noticeDisplayed = true;
  });
}

/**
 * Listen to SDK events
 */
function handleWebSDKEvents() {
    window.didomiEventListeners = window.didomiEventListeners || [];
    // TODO: Handle all iOS events
    window.didomiEventListeners.push(
      {
        event: 'api.error',
        listener: function ({ id, reason }) {
          if (window.webkit && window.webkit.messageHandlers) {
            window.webkit.messageHandlers.onError.postMessage(reason);
          } else {
            androidInterface.onError(id, reason);
          }
        }
      },
      {
        event: "consent.changed",
        listener: function (event) {
          // If the change is coming from the WebView we don't want to trigger the message back to the WebView.
          if (event.action == "webview") {
            return;
          }

          if (isIOS()) {
            window.webkit.messageHandlers.consentChanged.postMessage(Didomi.getUserStatus());
          } else {
            androidInterface.onConsentChanged(JSON.stringify(Didomi.getUserStatus()));
          }
        },
      },
      {
        event: 'notice.clickagree',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.noticeClickAgree.postMessage("");
          } else {
            androidInterface.onNoticeClickAgree();
          }
        }
      },
      {
        event: 'notice.clickdisagree',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.noticeClickDisagree.postMessage("");
          } else {
            androidInterface.onNoticeClickDisagree();
          }
        }
      },
      {
        event: 'notice.clickmoreinfo',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.noticeClickMoreInfo.postMessage("");
          } else {
            androidInterface.onNoticeClickMoreInfo();
          }
        }
      },
      {
        event: 'notice.clickviewvendors',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.noticeClickViewVendors.postMessage("");
          } else {
            androidInterface.onNoticeClickViewVendors();
          }
        }
      },
      {
        event: 'notice.hidden',
        listener: function () {
          if (noticeDisplayed && !Didomi.preferences.isVisible()) {
            if (isIOS()) {
              window.webkit.messageHandlers.noticeHidden.postMessage("");
            } else {
              androidInterface.onNoticeHidden();
            }
          }
        }
      },
      {
        event: 'notice.shown',
        listener: function () {
          if (initializationInProgress) {
            // Make sure the notice is not displayed if initialization is still in progress
            Didomi.notice.hide();
          } else if (isIOS()) {
            window.webkit.messageHandlers.noticeShown.postMessage("");
          } else {
            androidInterface.onNoticeShown();
          }
        }
      },
      {
        event: 'preferences.clickagreetoall',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickAgreeToAll.postMessage("");
          } else {
            androidInterface.onPreferencesClickAgreeToAll();
          }
        }
      },
      {
        event: 'preferences.clickcategoryagree',
        listener: function ({ categoryId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickCategoryAgree.postMessage(categoryId);
          } else {
            androidInterface.onPreferencesClickCategoryAgree(categoryId);
          }
        }
      },
      {
        event: 'preferences.clickcategorydisagree',
        listener: function ({ categoryId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickCategoryDisagree.postMessage(categoryId);
          } else {
            androidInterface.onPreferencesClickCategoryDisagree(categoryId);
          }
        }
      },
      {
        event: "preferences.clickclose",
        listener: function () {
          // Not handled by mobile SDKs
        },
      },
      {
        event: 'preferences.clickdisagreetoall',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickDisagreeToAll.postMessage("");
          } else {
            androidInterface.onPreferencesClickDisagreeToAll();
          }
        }
      },
      {
        event: 'preferences.clickpurposeagree',
        listener: function ({ purposeId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickPurposeAgree.postMessage(purposeId);
          } else {
            androidInterface.onPreferencesClickPurposeAgree(purposeId);
          }
        }
      },
      {
        event: 'preferences.clickpurposedisagree',
        listener: function ({ purposeId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickPurposeDisagree.postMessage(purposeId);
          } else {
            androidInterface.onPreferencesClickPurposeDisagree(purposeId);
          }
        }
      },
      {
        event: 'preferences.clicksavechoices',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickSaveChoices.postMessage("");
          } else {
            androidInterface.onPreferencesClickSaveChoices();
          }
        }
      },
      {
        event: 'preferences.clickvendoragree',
        listener: function ({ vendorId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickVendorAgree.postMessage(vendorId);
          } else {
            androidInterface.onPreferencesClickVendorAgree(vendorId);
          }
        }
      },
      {
        event: 'preferences.clickvendordisagree',
        listener: function ({ vendorId }) {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickVendorDisagree.postMessage(vendorId);
          } else {
            androidInterface.onPreferencesClickVendorDisagree(vendorId);
          }
        }
      },
      {
        event: 'preferences.clickvendorsavechoices',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickVendorSaveChoices.postMessage("");
          } else {
            androidInterface.onPreferencesClickVendorSaveChoices();
          }
        }
      },
      {
        event: 'preferences.clickviewvendors',
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesClickViewVendors.postMessage("");
          } else {
            androidInterface.onPreferencesClickViewVendors();
          }
        }
      },
      {
        event: "preferences.hidden",
        listener: function () {
          if (Didomi.notice.isVisible()) {
            if (isIOS()) {
              window.webkit.messageHandlers.preferencesHidden.postMessage("");
            } else {
              androidInterface.onPreferencesHidden();
            }
          } else {
            if (isIOS()) {
              window.webkit.messageHandlers.dismissWebView.postMessage("");
            } else {
              androidInterface.onDismissPreferences();
            }
          }
        }
      },
      {
        event: "preferences.shown",
        listener: function () {
          if (isIOS()) {
            window.webkit.messageHandlers.preferencesShown.postMessage("");
          } else {
            androidInterface.onPreferencesShown();
          }
        }
      },
    );
}

/**
 * Show the Preferences screen programmatically after the notice was already opened
 */
function showPreferences() {
  window.didomiOnReady = window.didomiOnReady || [];
  window.didomiOnReady.push(function (Didomi) {
    Didomi.preferences.show();
  });
}

/**
 * Click on the 1st visible slider button if it exists.
 * Used to cache both states of the slider button.
 */
function toggleFirstSlider() {
  new Promise(function(resolve) {
    setTimeout(() => {  // Add delay to let time for the element to be attached
      var elements = document.getElementsByClassName('didomi-switch');
      var clicked = false;

      // Click on 1st active slider
      for (var index = 0; index < elements.length; index++) {
        if (isClickable(elements[index])) {
          elements[index].click();
          clicked = true;
          break;
        }
      }

      resolve(clicked);
    }, 100);
  }).then((result) => {
      enabledToggleIsCachedOrNotRequired(result);
  });
}

/**
 * Check if a DOM element is clickable (visible and not disabled)
 */
function isClickable(element) {
  if (element.disabled) return false;
  if (element.style.display === 'none' || element.style.visibility === 'hidden') return false;
  if (element.offsetParent === null) return false;
  return true;
}

/**
 * If the preferences page shows toggles, we let the native code know that the enable toggle image should be loaded on the page and cached now.
 * If the preferences page does not show toggles, we also let native know that we can continue.
 * @param {*} result whether the toggle has been found and clicked or not.
 */
function enabledToggleIsCachedOrNotRequired(result) {
  if (isIOS()) {
    window.webkit.messageHandlers.enabledToggleIsCached.postMessage("");
  } else if (!result) {
    androidInterface.onSliderNotPresent();
  }
}

/**
 * Hide the Preferences screen programmatically
 */
function hidePreferences() {
  window.didomiOnReady = window.didomiOnReady || [];
  window.didomiOnReady.push(function (Didomi) {
    Didomi.preferences.hide();
  });
}

/**
 * Hide the Vendors screen programmatically
 */
function hideVendors() {
  // preferences.show() command will display the purposes screen with no changes in user choices
  showPreferences();
}

/**
 * Function used to convert objects that are mapped by ID into an array of objects that only contain IDs.
 * @param {*} object JSON object.
 * @returns array of objects that only contain an ID.
 */
function convertObjectToArrayWithIDs(object) {
  if (!object) {
    return [];
  }
  return Object.keys(object).map(function (id) {
    return {
      id: Number(id),
    };
  });
}

/**
 * Remove all accents and special characters from id field
 * @param {string} id
 * @returns the sanitized id
 */
function sanitizeID(id) {
  return id
    // Remove accents and diacritics
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    // Remove special characters
    .replace(/[^a-zA-Z0-9_-]/g, '');
}

/**
 * Fix unescaped quotes.
 * Note: lookbehinds (`(?<=...)` or `(?<!...)`) are only supported from safari 17+ 
 * @param {string} text
 * @returns the sanitized text
 */
function sanitizeText(text) {
  return text.replace(/(^|[^\\])(['"])/g, '$1\$2');
}

/**
 * Function used to sanitize custom fields in config.
 * @param {*} jsonConfig
 * @returns the sanitized config
 */
function sanitizeConfig(jsonConfig) {
  const resultJson = JSON.parse(JSON.stringify(jsonConfig));

  if (resultJson && resultJson.app) {
    if(resultJson.app.vendors && resultJson.app.vendors.custom && Array.isArray(resultJson.app.vendors.custom)) {
      resultJson.app.vendors.custom = resultJson.app.vendors.custom.map(vendor => {
          if (vendor.id) {
              vendor.id = sanitizeID(vendor.id);
          }
          if (vendor.purposeIds) {
            vendor.purposeIds = vendor.purposeIds.map(purposeID => sanitizeID(purposeID));
          }
          if (vendor.legIntPurposeIds) {
            vendor.legIntPurposeIds = vendor.legIntPurposeIds.map(purposeID => sanitizeID(purposeID));
          }
          if (vendor.name) {
            vendor.name = sanitizeText(vendor.name);
          }
          return vendor;
      });
    }

    if (resultJson.app.customPurposes) {
      resultJson.app.customPurposes = resultJson.app.customPurposes.map(purpose => {
        if (purpose.id) {
          purpose.id = sanitizeID(purpose.id);
        }
        if (purpose.name) {
          for (const key in purpose.name) {
            if (purpose.name.hasOwnProperty(key)) {
              purpose.name[key] = sanitizeText(purpose.name[key]);
            }
          }
        }
        if (purpose.description) {
          for (const key in purpose.description) {
            if (purpose.description.hasOwnProperty(key)) {
              purpose.description[key] = sanitizeText(purpose.description[key]);
            }
          }
        }
        if (purpose.descriptionLegal) {
          for (const key in purpose.descriptionLegal) {
            if (purpose.descriptionLegal.hasOwnProperty(key)) {
              purpose.descriptionLegal[key] = sanitizeText(purpose.descriptionLegal[key]);
            }
          }
        }
        return purpose;
      });
    }
  }

  return resultJson;
}

/**
 * Check if the platform is iOS.
 * @returns true if the platform is iOS, false otherwise.
 */
function isIOS() {
  return window.webkit != null && window.webkit.messageHandlers != null;
}

/**
 * Extract the country from the mobile config.
 * @param {*} configFromMobile 
 * @returns the country or null if not defined.
 */
function extractCountryFromMobileConfig(configFromMobile) {
  return configFromMobile.user ? configFromMobile.user.country : null;
}

/**
 * Extract the region from the mobile config.
 * @param {*} configFromMobile 
 * @returns the region or null if not defined.
 */
function extractRegionFromMobileConfig(configFromMobile) {
  return configFromMobile.user ? configFromMobile.user.region : null;
}

/**
 * Prepare config file to be consumed by the Web SDK, by disabling the features already handled by Mobile SDKs.
 * @param {*} configFromMobile Config provided by mobile.
 * @param {string} languageCode language code to be set in the Config.
 * @param {boolean} isUnderage whether the notice should be underage or not.
 * @returns Config with unneeded features disabled
 */
function prepareConfigFromMobile(configFromMobile, languageCode, isUnderage) {
  if (configFromMobile == null) {
    return null;
  }

  configFromMobile = sanitizeConfig(configFromMobile);

  // If the `events` object is not defined, we define it and make sure the enabled property is set to `false`.
  configFromMobile.events = configFromMobile.events || {};
  configFromMobile.events.enabled = false;

  if (configFromMobile.sync) {
    configFromMobile.sync.enabled = false;
  }

  if (configFromMobile.app && configFromMobile.app.consentString) {
    configFromMobile.app.consentString.signatureEnabled = false;
  }

  // Ignore daysBeforeShowingAgain as this is already handled by the mobile SDKs.
  if (configFromMobile.notice) {
    delete configFromMobile.notice.daysBeforeShowingAgain;
  }

  if (languageCode) {
    if (languageCode == "pt-PT") {
      // Temporary workaround for https://didomi.atlassian.net/browse/CMP-5552
      languageCode = "pt";
    }
    configFromMobile.languages = { enabled: [languageCode], default: languageCode };
  }

  if (isUnderage) {
    configFromMobile.user = configFromMobile.user || {};
    configFromMobile.user.isUnderage = isUnderage;
  }

  return configFromMobile;
}

/**
 * Prepare GVL to be consumed by the Web SDK based on the format used by Mobile SDKs.
 * @param {*} gvlFromMobile GVL in the format used by mobile.
 * @returns GVL in the format used by web.
 */
function prepareGVLFromMobile(gvlFromMobile) {
  if (gvlFromMobile == null) {
    return null;
  }

  gvlFromMobile.purposes = convertObjectToArrayWithIDs(gvlFromMobile.purposes);
  gvlFromMobile.specialPurposes = convertObjectToArrayWithIDs(gvlFromMobile.specialPurposes);
  gvlFromMobile.features = convertObjectToArrayWithIDs(gvlFromMobile.features);
  gvlFromMobile.specialFeatures = convertObjectToArrayWithIDs(gvlFromMobile.specialFeatures);
  gvlFromMobile.dataCategories = convertObjectToArrayWithIDs(gvlFromMobile.dataCategories);

  gvlFromMobile.stacks = Object.keys(gvlFromMobile.stacks).map(function (key) {
    var stack = gvlFromMobile.stacks[key];
    return {
      id: stack.id,
      purposeIds: stack.purposes || [],
      specialFeatureIds: stack.specialFeatures || [],
    };
  });

  gvlFromMobile.vendors = Object.keys(gvlFromMobile.vendors).map(function (key) {
    var vendor = gvlFromMobile.vendors[key];
    var {
      purposes,
      flexiblePurposes,
      specialPurposes,
      legIntPurposes,
      features,
      specialFeatures,
      ...rest
    } = vendor;
  
    return {
      ...rest,
      purposeIds: purposes || [],
      flexiblePurposeIds: flexiblePurposes || [],
      specialPurposeIds: specialPurposes || [],
      legIntPurposeIds: legIntPurposes || [],
      featureIds: features || [],
      specialFeatureIds: specialFeatures || [],
      tmpDeletedDate: rest.deletedDate,
    };
  });
  return gvlFromMobile;
}
