macro package dataloader

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind}

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
 * const myStringVar = @LoadText("path/to/file.txt")
 *
 * // With visibility or mutability
 * public var myStringVar = @LoadText("path/to/file.txt")
 * ```
 *
 * @param inputTokens Tokens containing the file path string literal.
 *
 * @return Tokens representing the variable declaration initialized with the file content.
 */
public macro LoadText(inputTokens: Tokens) {
    if (inputTokens.size != 1) {
        diagReport(DiagReportLevel.ERROR, inputTokens, "more than 1 file path found", "Example: loadText(\"file.txt\")")
    }
    let token = inputTokens[0]
    return match (token.kind) {
        case STRING_LITERAL | MULTILINE_STRING | MULTILINE_RAW_STRING => Token(MULTILINE_STRING, loadText(token.value))
            .toTokens()
        case _ =>
            diagReport(DiagReportLevel.ERROR, inputTokens, "invalid file path", "Example: loadText(\"file.txt\")")
            quote()
    }
}
