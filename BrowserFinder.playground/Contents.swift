//
//  BrowserFinder.swift
//  Jamf Connect Sync
//
//  Created by Jerry Walton on 1/8/20.
//  Copyright © 2020 Jamf Software. All rights reserved.
//

import Foundation

/// A class to find installed webbrowsers and determine the user's default browser setting.
public class JCBrowserFinder {

    // MARK: - Public Properties
    /// A shared singleton to use when accessing `BrowserFinder` operations.
    public static let shared = JCBrowserFinder()

    /// The name of the default web browser on the system in a `BrowserInfo?`.
    /// If no default browser  is set, value is `nil`.
    public var defaultBrowser: BrowserInfo? {
        guard let browser = getDefaultBrowser() else { return nil }
        return createBrowserInfo(browser: browser)
    }

    /// The names of all installed web browsers on the system in a `[String: BrowserInfo]`.
    /// If no browsers are installed, value is  nil.
    public var installedBrowsers: [String: BrowserInfo]? {
        guard let browserList = getBrowsers() else { return nil }
        // Create a set to unique the list in case of duplicates
        let browserSet = Set(browserList)
        var browserInfoDict = [String: BrowserInfo]()
        for browser in browserSet {
            let browserInfo = createBrowserInfo(browser: browser)
            guard let bunderIdentifier: String = browserInfo.bunderIdentifier else { continue }
            guard let displayName: String = browserInfo.displayName else { continue }
//            if JCBrowserWhiteListChecker.shared.isBrowserSupported(bundleIdentifier: bunderIdentifier) {
                browserInfoDict.updateValue(browserInfo, forKey: displayName)
//            }
        }
        return browserInfoDict
    }

    // MARK: - Internal Properties

    /// A static `NSURL` to be used when asking Launch Services for what apps handle http.
    ///
    /// Using `NSURL` here as it is toll-free to use in place of a `CFURLReference`.
    let staticUrl = NSURL(string: "http://www.apple.com")!

    // MARK: - Lifecycle Management
    /// Internal init to make sure this is a singleton.
    init() {
        // This init is empty because it's just here to ensure singleton status.
    }

    // MARK: - Internal Methods

    /// Method to get a list of all apps that are registered as http handlers.
    ///
    /// Queries launch services and returns a list to the location of all apps that register as http handlers.
    func getBrowsers() -> [URL]? {
        return LSCopyApplicationURLsForURL(staticUrl, .viewer)?.takeUnretainedValue() as? [URL]
    }

    /// Method to get the default web browser on the Mac.
    ///
    /// Queries launch services and returns the location of the browser that is registered as the default on the Mac.
    func getDefaultBrowser() -> URL? {
        return LSCopyDefaultApplicationURLForURL(staticUrl, .viewer, nil)?.takeUnretainedValue() as URL?
    }

    /// Creates a `BrowserInfo` struct from a given `URL`.
    /// - Parameter browser: A `URL` to the location of an app to create a `BrowserInfo` from.
    func createBrowserInfo(browser: URL) -> BrowserInfo {
        return BrowserInfo(displayName: browser.deletingPathExtension().lastPathComponent,
                           bunderIdentifier: Bundle(url: browser)?.bundleIdentifier)
    }
}

extension JCBrowserFinder {
    /// A struct to hold information about a web browser.
    public struct BrowserInfo {

        /// The display name of the browser.
        var displayName: String?

        /// The bundle ID of the browser.
        var bunderIdentifier: String?
    }
}

JCBrowserFinder.shared.getBrowsers()
