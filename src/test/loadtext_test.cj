package dataloader.test

import dataloader.LoadText

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestLoadText {
    @LoadText[private static const constText]("test_data/file1.txt")

    let expectedText = "\n this is a \"string\"!\nthis text is in a new line\n"

    @TestCase
    func loadText() {
        @LoadText[text]("test_data/file1.txt")
        @Expect(text, expectedText)
    }

    @TestCase
    func loadText_as_var() {
        @LoadText[var text]("test_data/file1.txt")

        var str = expectedText

        @Expect(text, str)

        text = text + "!"
        str = str + "!"

        @Expect(text, str)
    }

    @TestCase
    func loadText_as_private_static_const() {
        @Expect(constText, expectedText)
    }
}

// cjlint-ignore -end function names should be lower camel case
