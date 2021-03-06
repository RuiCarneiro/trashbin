//  Copyright © 2018 Rui Nelson Magalhães Carneiro. All rights reserved.

import Foundation

var userEnteredFiles = false

/// Returns an URL array with all the files speccified in the command line
func collectFiles() -> [URL] {
    let currentPath = Constants.fileManager.currentDirectoryPath
    let currentPathURL = URL(fileURLWithPath: currentPath, isDirectory: true)

    let files = CommandLine.arguments.dropFirst().filter { (argument) -> Bool in
        argument.first != "-"
    }

    userEnteredFiles = !files.isEmpty

    let globs: [[String]] = files.map { (file) -> [String] in
        let globResult = glob(pattern: file)
        if globResult.isEmpty, !options.force {
            printWarning("cannot \(options.actionPresent) '\(file)': No such file or directory")
        }
        return globResult
    }

    let flatGlobs: [String] = globs.flatMap { $0 }

    let filesUrlsArray: [URL] = flatGlobs.map { (filePath) -> URL in
        URL(fileURLWithPath: filePath, relativeTo: currentPathURL)
    }

    return filesUrlsArray
}
