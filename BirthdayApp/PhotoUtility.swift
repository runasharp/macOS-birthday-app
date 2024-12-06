import AppKit

func selectPhoto() -> NSImage? {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.allowedContentTypes = [.image]

    if panel.runModal() == .OK, let url = panel.url {
        return NSImage(contentsOf: url)
    }
    return nil
}

extension NSImage {
    func toData() -> Data? {
        guard let tiffData = self.tiffRepresentation else { return nil }
        guard let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
        return bitmap.representation(using: .png, properties: [:])
    }
}
