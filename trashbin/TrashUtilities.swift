//  Copyright © 2018 Rui Nelson Magalhães Carneiro. All rights reserved.

import Foundation

func trashBinContents() -> [String] {
	let trashHome = glob(pattern: "~/.Trash/*")
	let trashVolumes = glob(pattern: "/Volumes/*/.Trashes/*/*")
	let trashiCloud = glob(pattern: "~/Library/Mobile Documents/com~apple~CloudDocs/.Trash/*")
	
	let allTrashes = [trashHome, trashVolumes, trashiCloud]
	
	let flatAllTrashes = allTrashes.flatMap { (path) -> [String] in
		return path
	}
	
	return flatAllTrashes
}

func listTrashBin() {
	var total: Int64 = 0
	let contents = trashBinContents()

	print(contents.isEmpty ? "Trash is empty" : "Listing trash contents")
	for content in contents {
		var size: Int64?

		if showSize {
			size = fileManager.sizeOfItem(atPath: content)
			total += size ?? 0
		}

		fileInfoPrint(path: content, size: size)
	}

	if showSize {
		print("Total in trash: \(bcf.string(fromByteCount: total))")
	}
}

func emptyTrash() {
	unlink = true
	directories = true
	recursive = true

	var total: Int64 = 0
	let contents = trashBinContents()

	print ("Emptying trash...")

	for content in contents {
		let url = URL(fileURLWithPath: content)

		total += trash(url)
	}

	if showSize {
		print("Total freed: \(bcf.string(fromByteCount: total))")
	}
}
