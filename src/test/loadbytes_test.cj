package dataloader.test

import dataloader.LoadBytes

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestLoadBytes {
    private static let staticBytes: Array<Byte> = @LoadBytes("test_data/file2.bin")

    let expectedBytes: Array<Byte> = [0x00, 0x01, 0x02, 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xFE, 0xFF]

    @TestCase
    func loadBytes() {
        let bytes: Array<Byte> = @LoadBytes("test_data/file2.bin")
        @Expect(bytes.size, 10)
        @Expect(bytes, expectedBytes)
    }

    @TestCase
    func loadBytes_as_var() {
        var bytes: Array<Byte> = @LoadBytes("test_data/file2.bin")

        var arr = expectedBytes.clone()

        @Expect(bytes, arr)
        @Expect(bytes.size, 10)

        bytes[0] = 0xDA
        arr[0] = 0xDA

        @Expect(bytes, arr)
    }

    @TestCase
    func loadBytes_as_private_static() {
        @Expect(staticBytes, expectedBytes)
    }

    @TestCase
    func loadBytes_as_varray() {
        var bytes: VArray<Byte, $105340> = @LoadBytes("test_data/opensource.png")

        @Expect(bytes.size, 105340)
        @Expect(bytes[0], 0x89)
        @Expect(bytes[105339], 0x82)
    }
}

// cjlint-ignore -end function names should be lower camel case
