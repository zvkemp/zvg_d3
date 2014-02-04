describe "point chart", ->
  afterEach ->
    d3.selectAll('svg').remove()
    d3.selectAll('div#testing').remove()
    d3.selectAll('div.zvg').remove()

  it 'should be defined', ->
    expect(ZVG.Point).toBeDefined()

  data = [
    # The order of this dataset tests specific features of the nest/sort functions.
    # Changing it may break expectations.
    { series_1: "A", series_2: "Z", series_3: 2, value: 150 }
    { series_1: "A", series_2: "X", series_3: 2, value: 151 }
    { series_1: "A", series_2: "Z", series_3: 3, value: 200 }
    { series_1: "C", series_2: "Z", series_3: 1, value: 650 }
    { series_1: "C", series_2: "X", series_3: 3, value: 351 }
    { series_1: "B", series_2: "Z", series_3: 3, value: 100 }
    { series_1: "B", series_2: "X", series_3: 2, value: 251 }
    { series_1: "B", series_2: "Y", series_3: 1, value: 150 }
    { series_1: "A", series_2: "X", series_3: 3, value: 251 }
    { series_1: "A", series_2: "X", series_3: 1, value: 100 }
    { series_1: "B", series_2: "Y", series_3: 2, value: 950 }
    { series_1: "C", series_2: "X", series_3: 1, value: 600 }
    { series_1: "A", series_2: "Y", series_3: 3, value: 200 }
    { series_1: "C", series_2: "Z", series_3: 2, value: 250 }
    { series_1: "C", series_2: "X", series_3: 2, value: 851 }
    { series_1: "C", series_2: "Y", series_3: 1, value: 150 }
    { series_1: "B", series_2: "X", series_3: 3, value: 751 }
    { series_1: "B", series_2: "Z", series_3: 1, value: 750 }
    { series_1: "B", series_2: "X", series_3: 1, value: 500 }
    { series_1: "A", series_2: "Y", series_3: 1, value: 450 }
    { series_1: "A", series_2: "Y", series_3: 2, value: 150 }
    { series_1: "C", series_2: "Z", series_3: 3, value: 200 }
    { series_1: "A", series_2: "Z", series_3: 1, value: 450 }
    { series_1: "B", series_2: "Y", series_3: 3, value: 20 }
    { series_1: "C", series_2: "Y", series_3: 2, value: 250 }
    { series_1: "B", series_2: "Z", series_3: 2, value: 350 }
    { series_1: "C", series_2: "Y", series_3: 3, value: 40 }
  ]

  point = null

  describe 'data handling', ->
    beforeEach -> point = new ZVG.Point

    it 'should have no data on init', ->
      expect(point.data()).not.toBeDefined()

    it 'should allow data to be set and retrieved from the same function', ->
      point.data(data)
      expect(point.data()).toBeDefined()

    it 'stores the original dataset', ->
      point.data(data)
      expect(point.raw_data).toBe(data)

    it 'sorts the nested dataset', ->
      point.series_1_domain(['A', 'B', 'C'])
      point.data(data)
      series_1_keys = (x.key for x in point.data())
      expect(series_1_keys).toEqual(['A', 'B', 'C'])

    it 'does not sort the nested dataset when no sort order is defined', ->
      point.data(data)
      series_1_keys = (x.key for x in point.data())
      expect(series_1_keys).toEqual(['A', 'C', 'B'])

    it 'sorts the question series (series_3 [invert order])', ->
      point.series_3_domain(['1', '2', '3'])
      point.data(data)
      for s1 in point.data()
        do (s1) ->
          series_2_keys = (x.key for x in s1.values)
          expect(series_2_keys).toEqual(['1', '2', '3'])


    it 'does not sort the question series when no sort order is defined', ->
      point.data(data)
      point.data().forEach (s1) ->
        series_2_keys = (x.key for x in s1.values)
        expect(series_2_keys.sort()).toEqual(['1', '2', '3'])

    it 'sorts the third series', ->
      point.series_2_domain(['X', 'Y', 'Z'])
      point.data(data)
      point.data().forEach (s1) ->
        s1.values.forEach (s2) ->
          series_3_keys = (x.key for x in s2.values)
          expect(series_3_keys).toEqual(['X','Y','Z'])

  describe 'initialization', ->
    testing = null
    beforeEach -> testing = d3.select('body').append('div').attr('id', 'testing')

    it 'should append an svg element to the body by default', ->
      point = new ZVG.Point
      body = d3.select('body')
      expect(body.select('svg')).not.toBeEmpty()
    it 'appends the svg element to the given selector', ->
      point = new ZVG.Point('#testing')
      expect(testing.select('svg')).not.toBeEmpty()
    it 'saves the element as an attribute', ->
      point = new ZVG.Point('#testing')
      expect(point.element).toBe('#testing')

  describe 'filtering data', ->
    beforeEach ->
      point = new ZVG.Point
      point.series_1_domain(['A', 'B', 'C'])
      point.series_2_domain(['X', 'Y', 'Z'])
      point.data(data)

    it 'displays all by default', ->
      point.filter_data()
      expect(point.raw_data).toBe(data)

    it 'displays a single series 2 range', ->
      point.filter_data('Y')
      point.data().forEach (s1) ->
        s1.values.forEach (q1) ->
          q1.values.forEach (f1) ->
            expect(f1.key).toEqual 'Y'

    it 'maintains the original raw data when filtering', ->
      point.filter_data('Z')
      expect(point.raw_data).toEqual(data)

    it 'returns to unfiltered data', ->
      point.filter_data('X')
      point.filter_data()
      point.data().forEach (s1) ->
        series_2_keys = (x.key for x in s1.values)
        expect(series_2_keys.sort()).toEqual ['1', '2', '3']
  
  # describe 'overlapping label detection', ->
  #   beforeEach ->
  #     point = new ZVG.Point

  #   it 'does not find overlaps in charts with few point (series 1)', ->
  #     point.randomizeData(3, 3, 5)
  #     labels = point.constructSeries1LabelMap()
  #     expect(point.detect_overlaps(labels)).toBe(false)

  #   it 'does not find overlaps in charts with few point (series 2)', ->
  #     point.randomizeData(3, 3, 5)
  #     labels = point.constructSeries2LabelMap()
  #     expect(point.detect_overlaps(labels)).toBe(false)

  #   it 'finds overlaps when many point are present (series 2)', ->
  #     point.randomizeData(30, 10, 5)
  #     labels = point.constructSeries2LabelMap()
  #     expect(point.detect_overlaps(labels)).toBe(true)

