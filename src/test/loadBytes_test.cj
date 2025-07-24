package dataloader.test

import dataloader.*
import std.unittest.*

@Test
class TestLoadBytes {
    @LoadBytes[private static let staticBytes]("test_data/file2.bin")

    let expectedBytes: Array<Byte> = [0x00, 0x01, 0x02, 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xFE, 0xFF]

    @TestCase
    func loadBytes() {
        @LoadBytes[bytes]("test_data/file2.bin")
        @Expect(bytes.size, 10)
        @Expect(bytes, expectedBytes)
    }

    @TestCase
    func loadBytes_as_var() {
        @LoadBytes[var bytes]("test_data/file2.bin")

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
}
