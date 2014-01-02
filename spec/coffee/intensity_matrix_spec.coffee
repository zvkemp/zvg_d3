describe 'Charts::IntensityMatrix', ->
  afterEach ->
    d3.selectAll('svg').remove()
    d3.selectAll('div#testing').remove()
    d3.selectAll('div.zvg').remove()

  it 'should be defined', ->
    expect(ZVG.IntensityMatrix).toBeDefined()

  rdata = [
    { series_1: "B", series_2: "Y", value: 92 }
    { series_1: "A", series_2: "Y", value: 50 }
    { series_1: "A", series_2: "Z", value: 12 }
    { series_1: "B", series_2: "Z", value: 117 }
    { series_1: "C", series_2: "Y", value: 56 }
    { series_1: "D", series_2: "Z", value: 59 }
    { series_1: "A", series_2: "X", value: 100 }
    { series_1: "C", series_2: "Z", value: 109 }
    { series_1: "D", series_2: "X", value: 44 }
    { series_1: "B", series_2: "X", value: 57 }
    { series_1: "D", series_2: "Y", value: 32 }
    { series_1: "C", series_2: "X", value: 34 }
  ]


  matrix = null

  describe 'data handling', ->
    beforeEach -> matrix = new ZVG.IntensityMatrix

    it 'should have no data on init', ->
      expect(matrix.data()).not.toBeDefined()

    it 'should allow data to be set and retrieved', ->
      matrix.data(rdata)
      expect(matrix.data()).toBeDefined()

    it 'stores the original dataset', ->
      matrix.data(rdata)
      expect(matrix.raw_data).toBe(rdata)

    it 'sorts the nested dataset', ->
      matrix.series_1_domain(['A', 'B', 'C', 'D'])
      matrix.data(rdata)
      series_1_keys = (x.key for x in matrix.data())
      expect(series_1_keys).toEqual(['A', 'B', 'C', 'D'])

    it 'does not sort the nested dataset when no sort order is defined', ->
      matrix.data(rdata)
      series_1_keys = (x.key for x in matrix.data())
      expect(series_1_keys).toEqual(['B', 'A', 'C', 'D'])

    it 'sorts the second series', ->
      matrix.series_2_domain(['X', 'Y', 'Z'])
      matrix.data(rdata)
      for s1 in matrix.data()
        do (s1) ->
          series_2_keys = (x.key for x in s1.values)
          expect(series_2_keys).toEqual(['X', 'Y', 'Z'])

    it 'does not sort the second series when no sort order is defined', ->
      matrix.data(rdata)
      for s1 in matrix.data()
        do (s1) ->
          series_2_keys = (x.key for x in s1.values)
          expect(series_2_keys).not.toEqual(['X', 'Y', 'Z'])

  describe 'initialization', ->
    testing = null
    beforeEach -> testing = d3.select('body').append('div').attr('id', 'testing')

    it 'should append an svg element to the body by default', ->
      matrix = new ZVG.IntensityMatrix
      body = d3.select('body')
      expect(body.select('svg')).not.toBeEmpty()

    it 'appends the svg element to the given selector', ->
      matrix = new ZVG.IntensityMatrix('#testing')
      expect(testing.select('svg')).not.toBeEmpty()

    it 'saves the element as an attribute', ->
      matrix = new ZVG.IntensityMatrix('#testing')
      expect(matrix.element).toBe('#testing')

