describe 'ZVG', ->
  describe 'Utility Functions', ->

    describe 'string splitting', ->

      it 'splits a string roughly in half', ->
        string = "Hello, World"
        result = ZVG.Utilities.splitString(string)
        expect(result.length).toEqual(2)
        expect(result[0]).toEqual('Hello,')
        expect(result[1]).toEqual("World")

     it 'splits a three word string', ->
       string = "Hello, Beautiful World"
       result = ZVG.Utilities.splitString(string)
       expect(result.length).toEqual(2)
       expect(result[0]).toEqual('Hello, Beautiful')
       expect(result[1]).toEqual('World')

    it 'splits on an arbitrary number of lines', ->
      string = "Hello, Beautiful World"
      result = ZVG.Utilities.splitString(string, 3)
      expect(result.length).toEqual(3)
      expect(result[0]).toEqual('Hello,')
      expect(result[2]).toEqual('World')

    it 'does not split strings with no spaces', ->
      string = "HelloWorld"
      result = ZVG.Utilities.splitString(string, 2)
      expect(result.length).toEqual(1)
