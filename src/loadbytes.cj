macro package dataloader

import std.ast.{diagReport, DiagReportLevel, Token, Tokens, TokenKind, ToTokens}
import std.env.getWorkingDirectory
import std.fs.{exists, File, FSException}

/**
 * @brief Loads bytes from file. If the file doesn't exist, it tries to load it from the current working directory.
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

/**
 * @brief Macro to load a binary file and assign it to a variable.
 *
 * This macro generates a variable declaration initialized with the
 * byte content of the specified file. It handles file path resolution
 * relative to the source or working directory.
 *
 * Example:
 * ```
 * // Simple usage (infers 'let' and type Array<Byte>)
 * let myDataVar: Array<Byte> = @LoadBytes("path/to/file.bin")
 *
 * // With visibility
 * public var myDataVar: Array<Byte> = @LoadBytes("path/to/file.bin")
 * ```
 *
 * @param inputTokens Tokens containing the file path string literal.
 *
 * @return Token with the file bytes.
 */
public macro LoadBytes(inputTokens: Tokens) {
    if (inputTokens.size != 1) {
        diagReport(DiagReportLevel.ERROR, inputTokens, "more than 1 file path found", "Example: LoadBytes(\"file.bin\")")
    }
    let token = inputTokens[0]
    return match (token.kind) {
        case STRING_LITERAL | MULTILINE_STRING | MULTILINE_RAW_STRING => quote($(loadBytes(token.value)))
        case _ =>
            diagReport(DiagReportLevel.ERROR, inputTokens, "invalid file path", "Example: LoadBytes(\"file.bin\")")
            quote()
    }
}
