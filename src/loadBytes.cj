macro package dataloader

import std.ast.*
import std.collection.*
import std.fs.*

private func loadBytes(filePath: String): Array<Byte> {
    try {
        return File.readFrom(filePath)
    } catch (_: Exception) {}
    return Array<Byte>()
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
