// Mozilla User Preferences

// ****************************************************************************
// user.js                                                                    *
// ****************************************************************************

/******************************************************************************
 * SECTION: HTML5 / APIs / DOM                                                *
 ******************************************************************************/

// PREF: Disable web notifications
// https://support.mozilla.org/en-US/questions/1140439
user_pref("dom.webnotifications.enabled",                       false);

// PREF: Disable WebRTC entirely to prevent leaking internal IP addresses (Firefox < 42)
// NOTICE: Disabling WebRTC breaks peer-to-peer file sharing tools (reep.io ...)
user_pref("media.peerconnection.enabled",                       false);

/******************************************************************************
 * SECTION: Misc                                                              *
 ******************************************************************************/

// PREF: Disable GeoIP lookup on your address to set default search engine region
user_pref("browser.search.countryCode",                         "US");
user_pref("browser.search.region",                              "US");
user_pref("browser.search.suggest.enabled",                     false);

/******************************************************************************
 * SECTION: Extensions / plugins                                              *
 ******************************************************************************/

// PREF: Disable Pocket
user_pref("extensions.pocket.enabled",                          false);

// PREF: Disable screenshot feature to the ... menu on the address bar
user_pref("extensions.screenshots.disabled",                    true);

// PREF: Disable reader mode
user_pref("reader.parse-on-load.enabled",                       false);

/******************************************************************************
 * SECTION: Firefox (anti-)features / components                              *
 ******************************************************************************/

// PREF: Disable Mozilla telemetry/experiments
// https://wiki.mozilla.org/Platform/Features/Telemetry
// https://wiki.mozilla.org/Privacy/Reviews/Telemetry
// https://wiki.mozilla.org/Telemetry
// https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
// https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
// https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
// https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
// https://wiki.mozilla.org/Telemetry/Experiments
user_pref("toolkit.telemetry.enabled",                          false);
user_pref("toolkit.telemetry.unified",                          false);
user_pref("experiments.supported",                              false);
user_pref("experiments.enabled",                                false);
user_pref("experiments.manifest.uri",                           "");

// PREF: Disable collection/sending of the health report (healthreport.sqlite*)
user_pref("datareporting.healthreport.uploadEnabled",           false);

/*******************************************************************************
 * SECTION: Caching                                                            *
 ******************************************************************************/

// PREF: Disable disk cache
// http://kb.mozillazine.org/Browser.cache.disk.enable
user_pref("browser.cache.disk.enable",                          false);

// PREF: Allow decoded images, chrome, and secure pages to be
//       cached in memory. (Default)
user_pref("browser.cache.memory.enable",                        true);

// PREF: Longer interval between session information record (10 minutes)
//       (Default 15 seconds)
// https://wiki.archlinux.org/index.php/Firefox/Tweaks#Longer_interval_between_session_information_record
user_pref("browser.sessionstore.interval",                      600000);

/*******************************************************************************
 * SECTION: UI related                                                         *
 *******************************************************************************/

// Startup page
user_pref("browser.startup.homepage",                           "about:blank");

// Download button
user_pref("browser.download.autohideButton",                    false);
user_pref("browser.download.useDownloadDir",                    false);

// New tab page
user_pref("browser.newtabpage.enabled",                         false);
user_pref("browser.onboarding.tour-type",                       "new");

// Do not close with last tab and draw in title bar
user_pref("browser.tabs.closeWindowWithLastTab",                false);
//user_pref("browser.tabs.drawInTitlebar",                        false);

// PREF: Disable smooth when scrolling
user_pref("general.smoothScroll",                               false);
user_pref("layout.spellcheckDefault",                           0);

// PREF: Fix problem with context menu on XFCE
//       The context menu is not rightfully positioned.
user_pref("ui.context_menus.after_mouseup",                     true);
