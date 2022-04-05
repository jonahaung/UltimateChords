//
//  Html.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 27/3/22.
//

import SwiftUI

struct Html {
    
    static func parse(from song: Song) -> String {
        var html = """
                   <!DOCTYPE html>
                   <html lang="en">
                   <head>
                     <meta charset="utf-8">
                     <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
                   <style>
                   :root {
                     supported-color-schemes: light dark;\n
                   """
        /// Add  colors from the assets catalog  to the css
        html += "--accentColor: \(Color.red);\n"
        html += "--highlightColor: \(Color.yellow);\n"
        html += "--sectionColor: \(Color.blue);\n"
        html += "--commentBackground: \(Color.gray);\n"
        html += "}\n"
        /// Add the main CSS
        if let filepath = Bundle.main.path(forResource: "style", ofType: "css") {
            do {
                let contents = try String(contentsOfFile: filepath)
                html += contents
            } catch {
                print(error)
            }
        }
        html += """
                </style>
                </script>
                </head>
                <body>
                <div id="container">
                <div id="grid">
                """
        song.sections.forEach { section in
            html += sectionView(section)
            if !section.lines.isEmpty {
                html += "<div class=\"lines " + (section.type ?? "") + "\">"
                section.lines.forEach { line in
                    if !line.measures.isEmpty {
                        html += measuresView(line)
                    } else if line.tablature != nil {
                        html += "<div class=\"tablature\">" +  line.tablature! + "</div>"
                    } else if line.comment != nil {
                        html += "<div class=\"comment\">" +  line.comment! + "</div>"
                    } else if section.type == nil {
                        html += "<div class=\"plain\">"
                        html += plainView(line)
                        html += "</div>"
                    } else {
                        html += partsView(line)
                    }
                }
                html += "</div>"
            }
        }
        html += "</div>"
        html += "</div>"
        html += "</body></html>"

        return html
    }
    private static func sectionView(_ section:  Song.Sections) -> String {

        var html = ""
        html += "<div class=\"section "
        if section.lines.isEmpty {
            html += "no-name\">&nbsp;</div><div class=\"section single "
        }
        if section.name == nil {
            html += "no-name "
        }
        html += (section.type != nil ? section.type! : "")
        html += "\">"
        html += (section.name != nil ? "<div class=\"name\">" + section.name! + "</div>" : "&nbsp;")
        html += "</div>"
        
        return html
    }
    private static func measuresView(_ line: Song.Line) -> String {
        
        var html = "<div class=\"measures\">"
        line.measures.forEach { measure in
            html += "<div class=\"measure\">"
            measure.chords.forEach { chord in
                html += "<div class=\"chord\">" + chord + "</div>"
            }
            html += "</div>"
        }
        html += "</div>"
        
        return html
    }
    
    private static func partsView(_ line: Song.Line) -> String {
        
        var html = "<div class=\"line\">"
        line.parts.forEach { part in
            html += "<div class=\"part\"><div class=\"chord\">"
            html += (part.chord ?? "").isEmpty ? "&nbsp;" : part.chord!
            html += "</div><div class=\"lyric\">\(part.lyric!)</div></div>"
        }
        html += "</div>"
        
        return html
    }
    
    private static func plainView(_ line: Song.Line) -> String {
        
        var html = "<div class=\"line\">"
        line.parts.forEach { part in
            html += "<div class=\"plain\">\(part.lyric!)</div>"
        }
        html += "</div>"
        
        return html
    }
}
