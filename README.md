# dataloader

dataloader is a cangjie macro package that loads files as arrays or strings.
This is useful to bundle resources inside the binary, like images and sounds.  

**Note:** relative paths are local to the project. The program will fail to compile
if built from a different folder than expected. These macros work best when used
in `executable` projects.  

Loading big files (>~ 200KB) will crash the compiler because the compiler's AST is
creating a token for each byte in the file.

## Macros

* LoadBytes - Load file as Array<Byte>
* LoadText - Load file as String

## Examples

### Load file as array of bytes

Loads file as byte array. Can be slow for big files.

```
let bytes: Array<Byte> = @LoadBytes("test_data/file2.bin")
// will result in this after compiling:
let bytes: Array<Byte> = [0x00, 0x01, 0x02, 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xFE, 0xFF]
```

### Load file as string

Loads text file as string. Multiline files are supported.

```
let text = @LoadText("test_data/file1.txt")
// will result in this after compiling:
let text = "\n this is a \"string\"!\nthis text is in a new line\n"
```

### load as private static const

```
private static const constText = @LoadText("test_data/file1.txt")
// will result in this after compiling:
private static const constText = "\n this is a \"string\"!\nthis text is in a new line\n"
```

## License

MIT No Attribution
