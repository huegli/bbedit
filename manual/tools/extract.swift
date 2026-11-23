import Foundation
import PDFKit

// usage: extract <pdf> <outdir>
// Writes <outdir>/manual.txt (page-marked), <outdir>/outline.txt (bookmarks with page numbers)
let args = CommandLine.arguments
guard args.count == 3, let doc = PDFDocument(url: URL(fileURLWithPath: args[1])) else {
    FileHandle.standardError.write("usage: extract <pdf> <outdir>\n".data(using: .utf8)!); exit(1)
}
let out = args[2]
try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)

var text = ""
for i in 0..<doc.pageCount {
    text += "\n=== PAGE \(i + 1) ===\n" + (doc.page(at: i)?.string ?? "") + "\n"
}
try text.write(toFile: out + "/manual.txt", atomically: true, encoding: .utf8)

var outline = ""
func walk(_ o: PDFOutline, _ depth: Int) {
    for i in 0..<o.numberOfChildren {
        guard let c = o.child(at: i) else { continue }
        var pg = "?"
        if let p = c.destination?.page { pg = String(doc.index(for: p) + 1) }
        outline += String(repeating: "  ", count: depth) + "\(c.label ?? "") ... p.\(pg)\n"
        walk(c, depth + 1)
    }
}
if let root = doc.outlineRoot { walk(root, 0) }
try outline.write(toFile: out + "/outline.txt", atomically: true, encoding: .utf8)
print("pages: \(doc.pageCount), outline lines: \(outline.split(separator: "\n").count)")
