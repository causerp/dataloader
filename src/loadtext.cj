macro package dataloader

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind, ToTokens}
import std.collection.last

private func loadText(filePath: String): String {
    String.fromUtf8(loadBytes(filePath))
}

public macro LoadText(attrTokens: Tokens, inputTokens: Tokens) {
    var ret = quote()
    if (attrTokens.size == 1) {
        match (attrTokens[0].kind) {
            case IDENTIFIER => ret.append(quote(let $(attrTokens[0]) =))
            case _ => ()
        }
    } else {
        for (token in attrTokens) {
            ret.append(token)
        }
        if (let Some(token) <- (attrTokens |> last)) {
            match (token.kind) {
                case ASSIGN => ()
                case _ => ret.append(Token(ASSIGN))
            }
        }
    }
    if (inputTokens.size != 1) {
        diagReport(DiagReportLevel.ERROR, inputTokens, "more than 1 file path found",
            "Example: loadText[public let](\"file.txt\")")
    }
    let token = inputTokens[0]
    match (token.kind) {
        case STRING_LITERAL | MULTILINE_STRING | MULTILINE_RAW_STRING => ret.append(
            Token(MULTILINE_STRING, loadText(token.value)))
        case _ => diagReport(DiagReportLevel.ERROR, inputTokens, "invalid file path",
            "Example: loadText[public let](\"file.txt\")")
    }
    return ret
}
