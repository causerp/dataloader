macro package dataloader

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind, ToTokens}
import std.collection.last

/**
 * @brief Loads the content of a text file at compile time.
 *
 * Reads the file specified in the input tokens and embeds its content
 * as a string literal in the generated code.
 *
 * @param filePath The path to the file to load.
 *
 * @return The content of the file as a string.
 */
private func loadText(filePath: String): String {
    String.fromUtf8(loadBytes(filePath))
}

/**
 * @brief Macro to load a text file and assign it to a variable.
 *
 * This macro generates a variable declaration initialized with the
 * content of the specified text file. It supports various declaration
 * formats provided in the attribute tokens.
 *
 * Example:
 * ```
 * // Simple usage (infers 'let')
 * @LoadText[myStringVar]("path/to/file.txt")
 *
 * // With visibility or mutability
 * @LoadText[public let myStringVar]("path/to/file.txt")
 * ```
 *
 * @param attrTokens Tokens representing the variable declaration (e.g., `public let varName`).
 * @param inputTokens Tokens containing the file path string literal.
 *
 * @return Tokens representing the variable declaration initialized with the file content.
 */
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
