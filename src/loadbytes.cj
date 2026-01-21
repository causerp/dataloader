macro package dataloader

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind, ToTokens}
import std.collection.last
import std.env.getWorkingDirectory
import std.fs.{exists, File, FSException}

/**
 * Loads bytes from file. If the file doesn't exist, it tries to load it from the current working directory.
 *
 * @param filePath file path.
 *
 * @throws FSException when file not found.
 */
func loadBytes(filePath: String): Array<Byte> {
    if (exists(filePath) == true) {
        return File.readFrom(filePath)
    }
    let currentDir = getWorkingDirectory()
    let fullPath = currentDir.join(filePath)
    if (exists(fullPath) == true) {
        return File.readFrom(fullPath)
    }
    throw FSException("File not found: ${filePath}\nCurrent directory: ${currentDir}")
}

public macro LoadBytes(attrTokens: Tokens, inputTokens: Tokens) {
    var ret = quote()
    if (attrTokens.size == 1) {
        match (attrTokens[0].kind) {
            case IDENTIFIER => ret.append(quote(let $(attrTokens[0]): Array<Byte> =))
            case _ => ()
        }
    } else {
        for (token in attrTokens) {
            ret.append(token)
        }
        if (let Some(token) <- (attrTokens |> last)) {
            match (token.kind) {
                case ASSIGN => ()
                case _ => ret.append(quote(: Array<Byte> =))
            }
        }
    }
    if (inputTokens.size != 1) {
        diagReport(DiagReportLevel.ERROR, inputTokens, "more than 1 file path found",
            "Example: LoadBytes[public let](\"file.bin\")")
    }
    let token = inputTokens[0]
    match (token.kind) {
        case STRING_LITERAL | MULTILINE_STRING | MULTILINE_RAW_STRING => ret.append(quote($(loadBytes(token.value))))
        case _ => diagReport(DiagReportLevel.ERROR, inputTokens, "invalid file path",
            "Example: LoadBytes[public let](\"file.bin\")")
    }
    return ret
}
