// CUSTOM OPTIONS FOR FIREFOX
// This 'user.js' file should be saved in /home/.mozilla/{randomNumbersFollowedByUsernameOrDefault}/user.js
// Adding this file will overrule the default settings of the 'about:config' menu without having to change it.
// the 'about:config' file is aka 'prefs.js' and is located in the same directory where this file belongs.




// RESOURCE USAGE
user_pref("config.trim_on_minimize", true);	// Default = false (and does not exist). Lowers RAM usage when minimized


// UI
user_pref("browser.urlbar.clickSelectsAll", true);	// Default = false. Select all text when you click in the URL bar
user_pref("security.dialog_enable_delay", 0);	// The amount of miliseconds to wait before allowing user to install new addon. Default = 1000
user_pref("extensions.getAddons.maxResults", 25);	// Amount of results to display when searching for addons. Default = 15
//user_pref("browser.download.dir", /home/rdogg/Desktop);	// Change the download directory
user_pref("browser.startup.homepage", https://www.google.com/);	// Default homepage
user_pref("browser.tabs.warnOnClose", false);	// Warn me before closing multiple tabs. Default = true
user_pref("browser.newtabpage.activity-stream.showSponsored", false);	// Show sponsored content on 'new tab' page. Default = true
user_pref("browser.shell.checkDefaultBrowser", false);	// Bug you to make Firefox your default browser.


// COMPATABILITY
user_pref("extensions.checkCompatibility", false);	// Enable/Disable compatability checks for addons. Default = ture


// CONNECTIVITY
user_pref("network.http.max-persistent-connections-per-server", 8);	// Max number of connections you may have to a server. Default = 6
//user_pref("network.http.max-connections", 1350);	// Controlls the number of connections to a server. Defualt = 900


// PRIVACY
user_pref("dom.battery.enabled", false);	// AllowPrevent website owners from tracking your computer's battery status. Default = true
user_pref("dom.event.clipboardevents.enabled", false);	// Allow/prevent websites from viewing what you copy/paste. Default = true
//user_pref("media.navigator.enabled", false);	// Allow/prevent websites from tracking your microphone and camera connected to the PC. Default = true
user_pref("privacy.trackingprotection.enabled", true);	// Enabled tracking protection. Deafult = false
user_pref("privacy.donottrackheader.enabled", true);	// Send a "do not track" request when visiting sites. Default = false
user_pref("app.shield.optoutstudies.enabled", false);	// Dis/Allows Mozilla from studying your PC. Default = true




// RETIRED BY MOZILLA
//network.http.pipelining	boolean field
//network.http.pipelining.maxrequests	integer field


















