import XCTest
import BigInt
@testable import swift_rlp

class swift_rlpTests: XCTestCase {
  
  static var allTests = [
    ("test_decode_invalidRlps_shouldNotCrash", test_decode_invalidRlps_shouldNotCrash),
    ]
  
  func test_decode_invalidRlps_shouldNotCrash() {
    let data: [UInt8] = [239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 191, 189, 29, 239, 191, 189, 77, 239, 191, 189, 239, 191, 189, 239, 191, 189, 93, 122, 239, 191, 189, 239, 191, 189, 239, 191, 189, 103, 239, 191, 189, 239, 191, 189, 239, 191, 189, 26, 239, 191, 189, 18, 69, 27, 239, 191, 189, 239, 191, 189, 116, 19, 239, 191, 189, 239, 191, 189, 66, 239, 191, 189, 64, 212, 147, 71, 239, 191, 189, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 191, 189, 11, 222, 155, 122, 54, 42, 194, 169, 239, 191, 189, 70, 239, 191, 189, 72, 239, 191, 189, 239, 191, 189, 54, 53, 239, 191, 189, 100, 73, 239, 191, 189, 55, 239, 191, 189, 239, 191, 189, 59, 1, 239, 191, 189, 109, 239, 191, 189, 239, 191, 189, 93, 239, 191, 189, 208, 128, 239, 191, 189, 239, 191, 189, 0, 239, 191, 189, 239, 191, 189, 239, 191, 189, 15, 66, 64, 239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 4, 239, 191, 189, 79, 103, 239, 191, 189, 85, 239, 191, 189, 239, 191, 189, 239, 191, 189, 74, 239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 54, 239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 239, 191, 189, 83, 239, 191, 189, 14, 239, 191, 189, 239, 191, 189, 239, 191, 189, 4, 63, 239, 191, 189, 63, 239, 191, 189, 41, 239, 191, 189, 239, 191, 189, 239, 191, 189, 67, 28, 239, 191, 189, 239, 191, 189, 11, 239, 191, 189, 31, 239, 191, 189, 239, 191, 189, 104, 96, 100, 239, 191, 189, 239, 191, 189, 12, 239, 191, 189, 239, 191, 189, 206, 152, 239, 191, 189, 239, 191, 189, 31, 112, 111, 239, 191, 189, 239, 191, 189, 65, 239, 191, 189, 41, 239, 191, 189, 239, 191, 189, 53, 84, 11, 239, 191, 189, 239, 191, 189, 12, 102, 24, 12, 42, 105, 109, 239, 191, 189, 58, 239, 191, 189, 4, 239, 191, 189, 104, 82, 9, 239, 191, 189, 6, 66, 91, 43, 38, 102, 117, 239, 191, 189, 105, 239, 191, 189, 239, 191, 189, 239, 191, 189, 89, 127, 239, 191, 189, 114]
    XCTAssertThrowsError(try RLP.decode(data))
  }
  
  
  func test_encode_singleByteStringLessThan0x7f_returnsItself() {
    let expectation = ["a".utf8.first!]
    let result = try! RLP.encode("a")
    XCTAssertEqual(result, expectation)
  }
  
  func test_encode_stringWithLessThan55Chars_shouldReturn0x80PlusLengthOfDataThenData() {
    //length of string 0-55 should return (0x80+len(data)) plus data
    let encodedDog = try! RLP.encode("dog")
    XCTAssertEqual(4, encodedDog.count)
    XCTAssertEqual(encodedDog[0], 131)
    XCTAssertEqual(encodedDog[1], 100)
    XCTAssertEqual(encodedDog[2], 111)
    XCTAssertEqual(encodedDog[3], 103)
  }
  
  func test_encode_stringWithGreaterThan55Chars_shouldReturn0xb7PlusLengthOfLengthDataThenLengthDataThenData() {
    //length of string >55 should return 0xb7+len(len(data)) plus len(data) plus data
    let encodedLongString = try! RLP.encode("zoo255zoo255zzzzzzzzzzzzssssssssssssssssssssssssssssssssssssssssssssss")
    XCTAssertEqual(72, encodedLongString.count)
    XCTAssertEqual(encodedLongString[0], 184)
    XCTAssertEqual(encodedLongString[1], 70)
    XCTAssertEqual(encodedLongString[2], 122)
    XCTAssertEqual(encodedLongString[3], 111)
    XCTAssertEqual(encodedLongString[12], 53)
    
  }
  
  func test_encode_listWithLengthLessThan55_shouldReturn0xc0PlusLengthOfDataThenData() {
    //length of list 0-55 should return (0xc0+len(data)) plus data"
    let encodedArrayOfStrings = try! RLP.encode(["dog", "god", "cat"])
    XCTAssertEqual(13, encodedArrayOfStrings.count)
    XCTAssertEqual(encodedArrayOfStrings[0], 204)
    XCTAssertEqual(encodedArrayOfStrings[1], 131)
    XCTAssertEqual(encodedArrayOfStrings[11], 97)
    XCTAssertEqual(encodedArrayOfStrings[12], 116)
  }
  
  func test_encode_listWithLengthGreaterThan55_shouldReturn0xb7PlusLengthOfLengthDataThenLengthDataThenData() {
    //length of list >55 should return 0xf7+len(len(data)) plus len(data) plus data
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    let longList = (alphabet + alphabet + alphabet).characters.map { String($0) }
    
    let encodedArrayOfStrings = try! RLP.encode(longList)
    XCTAssertEqual(80, encodedArrayOfStrings.count)
    XCTAssertEqual(encodedArrayOfStrings[0], 248)
    XCTAssertEqual(encodedArrayOfStrings[1], 78)
    XCTAssertEqual(encodedArrayOfStrings[2], 97)
    XCTAssertEqual(encodedArrayOfStrings[3], 98)
  }
  
  
  func test_encode_integerLessThan127_shouldReturnItself() {
    //length of int = 1, less than 0x7f, similar to string
    let encodedNumber = try! RLP.encode(15)
    XCTAssertEqual(1, encodedNumber.count)
    XCTAssertEqual(encodedNumber[0], 15)
  }
  
  func test_encode_integerGreaterThanOrEqualTo127_shouldReturn0x80PlusLengthOfDataThenData() {
    //length of int >= 127, similar to string
    let encodedNumber = try! RLP.encode(1024)
    XCTAssertEqual(3, encodedNumber.count)
    XCTAssertEqual(encodedNumber[0], 130)
    XCTAssertEqual(encodedNumber[1], 4)
    XCTAssertEqual(encodedNumber[2], 0)
  }
  
  func test_encode_integerZero_shouldReturn0x80() {
    let encodedNumber = try! RLP.encode(0)
    XCTAssertEqual(encodedNumber, [0x80])
  }
  
  func test_decodeFirstByteLessThan0x7f_shouldReturnByteItself() {
    //first byte < 0x7f, return byte itself
    let decodedValue = try! RLP.decode([97])
    let decodedString = decodedValue.stringValue!
    XCTAssertEqual(1, decodedString.characters.count)
    XCTAssertEqual(decodedString, "a")
  }
  
  func test_decodeFirstByteLessThan0xb7_shouldReturnByteItself() {
    //first byte < 0xb7, data is everything except first byte
    let decodedValue = try! RLP.decode([131, 100, 111, 103])
    let decodedString = decodedValue.stringValue!
    XCTAssertEqual(3, decodedString.characters.count)
    XCTAssertEqual(decodedString, "dog")
  }
  
  
  func test_decodeList_shouldReturnDogGodCat() {
    let decodedValue = try! RLP.decode([204, 131, 100, 111, 103, 131, 103, 111, 100, 131, 99, 97, 116])
    XCTAssertEqual(decodedValue.stringList!, ["dog", "god", "cat"])
  }
  
  func test_decodeSmallInt_shouldReturnItself() {
    //first byte < 0x7f, return itself
    let decodedValue = try! RLP.decode([15])
    XCTAssertEqual(decodedValue.intValue, 15)
  }
  
  func test_decodeMultipleBytes_shouldLengthAndBytes() {
    //first byte < 0xb7, data is everything except first byte
    let decodedValue = try! RLP.decode([130, 4, 0])
    XCTAssertEqual(2, decodedValue.stringValue?.characters.count)
    XCTAssertEqual(Array(decodedValue.stringValue!.utf8).hexString, "0400")
  }
  
  func test_encodeDecodeLongString_shouldMarkLengthHAveLengthBytesAndDataBytes() {
    //strings over 55 bytes long
    let testString = "This function takes in a data, convert it to buffer if not, and a length for recursion"
    let encoded = try! RLP.encode(testString)
    XCTAssertEqual(encoded[0], 184)
    XCTAssertEqual(encoded[1], 86)
    
    //Test decoding
    let decodedValue = try! RLP.decode(encoded)
    XCTAssertEqual(decodedValue.stringValue, testString)
  }
  
  func test_encodeDecodeLongList_shouldMarkLengthHAveLengthBytesAndDataBytes() {
    // list over 55 bytes long
    let testString = ["This", "function", "takes", "in", "a", "data", "convert", "it", "to", "buffer", "if", "not", "and", "a", "length", "for", "recursion", "a1", "a2", "a3", "ia4", "a5", "a6", "a7", "a8", "ba9"]
    let encoded = try! RLP.encode(testString)
    
    let decoded = try! RLP.decode(encoded)
    
    XCTAssertEqual(decoded.stringList!, testString)
  }
  
    func test_encodeDecodeNestedList_shouldPreserveListNesting() {
      let nestedList =
        [
          [],
          [
            []
          ],
          [
            [],
            [
              []
            ]
          ]
      ]
  
      let encodedValue = try! RLP.encode(nestedList)
      XCTAssertEqual(encodedValue, [0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0])
  
      let decodedValue = try! RLP.decode(encodedValue)
      let structure = decodedValue.rawBytes as! [Array<Array<Array<Any>>>]
      XCTAssertEqual(nestedList.count, structure.count)
      XCTAssertEqual(nestedList[0].count, structure[0].count)
      XCTAssertEqual(nestedList[1].count, structure[1].count)
      XCTAssertEqual(nestedList[1][0].count, structure[1][0].count)
      XCTAssertEqual(nestedList[2][1][0].count, structure[2][1][0].count)
    }
  
  
  func test_encodeDecodeEmptyList() {
    
    let emptyList: [Any] = []
    let encodedValue = try! RLP.encode(emptyList)
    XCTAssertEqual(encodedValue, [0xc0])
    let result = try! RLP.decode(encodedValue).listValue
    
    XCTAssertEqual(result?.count, 0)
  }
  
  func test_encodeDecodeZeroValues_() {
    //encode a zero
    let encodedValue = try! RLP.encode([0])
    XCTAssertEqual(encodedValue, [193, 0x80])
    
    //decode a zero
    let decodedValue = try! RLP.decode([193, 0x80])
    let ints = decodedValue.intList!
    XCTAssertEqual(ints, [0])
  }
  
  func test_decodeBadValues_wrongEncodedZero_throwsError() {
    //wrong encoded a zero
    let value = try! "f9005f030182520894b94f5374fce5edbc8e2a8697c15331677e6ebf0b0a801ca098ff921201554726367d2be8c804a7ff89ccf285ebc57dff8ae4c44b9c19ac4aa08887321be575c8095f789dd4c743dfe42c1820f9231f98a962b210e3ac2452a3".toHexBytes()
    
    XCTAssertThrowsError(try RLP.decode(value))
  }
  
  func test_decodeBadValues_invalidLength_throwsError() {
    
    let value = try! "f86081000182520894b94f5374fce5edbc8e2a8697c15331677e6ebf0b0a801ca098ff921201554726367d2be8c804a7ff89ccf285ebc57dff8ae4c44b9c19ac4aa08887321be575c8095f789dd4c743dfe42c1820f9231f98a962b210e3ac2452a3".toHexBytes()
    
    XCTAssertThrowsError(try RLP.decode(value))
  }
  
  func test_decodeBadValues_extraDataAtEnd_throwsError() {
    
    let value = try! "f90260f901f9a02a3c692012a15502ba9c39f3aebb36694eed978c74b52e6c0cf210d301dbf325a01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347948888f1f195afa192cfee860698584c030f4c9db1a0ef1552a40b7165c3cd773806b9e0c165b75356e0314bf0706f279c729f51e017a0b6c9fd1447d0b414a1f05957927746f58ef5a2ebde17db631d460eaf6a93b18da0bc37d79753ad738a6dac4921e57392f145d8887476de3f783dfa7edae9283e52b90100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008302000001832fefd8825208845509814280a00451dd53d9c09f3cfb627b51d9d80632ed801f6330ee584bffc26caac9b9249f88c7bffe5ebd94cc2ff861f85f800a82c35094095e7baea6a6c7c4c2dfeb977efac326af552d870a801ba098c3a099885a281885f487fd37550de16436e8c47874cd213531b10fe751617fa044b6b81011ce57bffcaf610bf728fb8a7237ad261ea2d937423d78eb9e137076c0ef".toHexBytes()
    XCTAssertThrowsError(try RLP.decode(value))
  }
  
  func test_decodeBadValues_extraDataAtEnd2_throwsError() {
    let value = try! "f9ffffffc260f901f9a02a3c692012a15502ba9c39f3aebb36694eed978c74b52e6c0cf210d301dbf325a01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347948888f1f195afa192cfee860698584c030f4c9db1a0ef1552a40b7165c3cd773806b9e0c165b75356e0314bf0706f279c729f51e017a0b6c9fd1447d0b414a1f05957927746f58ef5a2ebde17db631d460eaf6a93b18da0bc37d79753ad738a6dac4921e57392f145d8887476de3f783dfa7edae9283e52b90100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008302000001832fefd8825208845509814280a00451dd53d9c09f3cfb627b51d9d80632ed801f6330ee584bffc26caac9b9249f88c7bffe5ebd94cc2ff861f85f800a82c35094095e7baea6a6c7c4c2dfeb977efac326af552d870a801ba098c3a099885a281885f487fd37550de16436e8c47874cd213531b10fe751617fa044b6b81011ce57bffcaf610bf728fb8a7237ad261ea2d937423d78eb9e137076c0".toHexBytes()
    
    XCTAssertThrowsError(try RLP.decode(value))
  }
  
  func test_decodeBadData_lengthLongerThanData_throwsError() {
    //list length longer than data
    let value = try! "f9ffffffc260f901f9a02a3c692012a15502ba9c39f3aebb36694eed978c74b52e6c0cf210d301dbf325a01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347948888f1f195afa192cfee860698584c030f4c9db1a0ef1552a40b7165c3cd773806b9e0c165b75356e0314bf0706f279c729f51e017a0b6c9fd1447d0b414a1f05957927746f58ef5a2ebde17db631d460eaf6a93b18da0bc37d79753ad738a6dac4921e57392f145d8887476de3f783dfa7edae9283e52b90100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008302000001832fefd8825208845509814280a00451dd53d9c09f3cfb627b51d9d80632ed801f6330ee584bffc26caac9b9249f88c7bffe5ebd94cc2ff861f85f800a82c35094095e7baea6a6c7c4c2dfeb977efac326af552d870a801ba098c3a099885a281885f487fd37550de16436e8c47874cd213531b10fe751617fa044b6b81011ce57bffcaf610bf728fb8a7237ad261ea2d937423d78eb9e137076c0".toHexBytes()
    
    XCTAssertThrowsError(try RLP.decode(value))
  }
  
  func test_encode_dataWithHexPrefix_shouldNotHaveTheSameValue() {
    let a = try! RLP.encode("0x88f")
    let b = try! RLP.encode("88f")
    XCTAssertNotEqual(a.unicodeString, b.unicodeString)
  }
  
  func test_encode_128() {
    let a = try! RLP.encode(128)
    XCTAssertEqual(a, [0x81, 0x80])
  }
  
  func test_encodeDecode_BigUInt() {
    let largeNumber = try! RLP.encode(BigUInt(stringLiteral: "83729609699884896815286331701780722"))
    let regularNumber = try! RLP.encode(BigUInt(integerLiteral: 3510))
    
    let decodedRegularNumber = try! RLP.decode(regularNumber)
    let decodedLargeNumber = try! RLP.decode(largeNumber)
    XCTAssertEqual(decodedRegularNumber.intValue, 3510)
    XCTAssertEqual("\(decodedLargeNumber.bigUIntValue!)", "83729609699884896815286331701780722")
  }
  
  func test_officialTests_pass() {
    // You may want to disable these
    if let data = (try? Data(contentsOf: URL(string: "https://raw.githubusercontent.com/ethereum/tests/eb7cb8b97e05c2a799a457d3543a50ef1b1aa974/RLPTests/rlptest.json")!)) {
      let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
      let dict = json as! [String: [String: Any]]
      for testName in dict.keys {
        var input = dict[testName]!["in"]!
        if let string = input as? String {
          let chars = Array(string.characters)
          if chars.count > 0, chars[0] == "#" {
            input = BigUInt(stringLiteral: String(chars.dropFirst()))
          }
        }
        let expectation = (dict[testName]!["out"] as! String).lowercased()
        let output = try! RLP.encode(input)
        XCTAssertEqual(output.hexString, expectation, testName)
      }
    }
  }

  
   
   
   
   
   
   
   
 
  
  
  
  
  
}
