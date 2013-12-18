describe 'Charts::Column', ->
  afterEach ->
    d3.selectAll('svg').remove()
    d3.selectAll('div#testing').remove()

  it 'should be defined', ->
    expect(ZVG.Column).toBeDefined()

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

  column = null

  describe 'data handling', ->
    beforeEach -> column = new ZVG.Column

    it 'should have no data on init', ->
      expect(column.data()).not.toBeDefined()

    it 'should allow data to be set and retrieved from the same function', ->
      column.data(data)
      expect(column.data()).toBeDefined()
    
    it 'stores the original dataset', ->
      column.data(data)
      expect(column.raw_data).toBe(data)

    it 'sorts the nested dataset', ->
      column.series_1_domain(['A', 'B', 'C'])
      column.data(data)
      series_1_keys = (x.key for x in column.data())
      expect(series_1_keys).toEqual(['A', 'B', 'C'])

    it 'does not sort the nested dataset when no sort order is defined', ->
      column.data(data)
      series_1_keys = (x.key for x in column.data())
      expect(series_1_keys).toEqual(['A', 'C', 'B'])
  
    it 'sorts the second series', ->
      column.series_2_domain(['X', 'Y', 'Z'])
      column.data(data)
      for s1 in column.data()
        do (s1) ->
          series_2_keys = (x.key for x in s1.values)
          expect(series_2_keys).toEqual(['X', 'Y', 'Z'])

    it 'does not sort the second series when no sort order is defined', ->
      column.data(data)
      column.data().forEach (s1) ->
        series_2_keys = (x.key for x in s1.values)
        expect(series_2_keys).toEqual(['Z', 'X', 'Y'])

    it 'sorts the third series', ->
      column.series_3_domain(['1', '2', '3'])
      column.data(data)
      column.data().forEach (s1) ->
        s1.values.forEach (s2) ->
          series_3_keys = (x.key for x in s2.values)
          expect(series_3_keys).toEqual(['1','2','3'])

    # it 'does not sort the third series when no sort order is defined', ->
    # it makes little sense to test this, as the data should always be sorted 
    # (ie, columns boxes should be in the correct order).
    # Should this raise an error when series_3_domain is undefined?

  describe 'initialization', ->
    testing = null
    beforeEach -> testing = d3.select('body').append('div').attr('id', 'testing')

    it 'should append an svg element to the body by default', ->
      column = new ZVG.Column
      body = d3.select('body')
      expect(body.select('svg')).not.toBeEmpty()
    it 'appends the svg element to the given selector', ->
      column = new ZVG.Column('#testing')
      expect(testing.select('svg')).not.toBeEmpty()
    it 'saves the element as an attribute', ->
      column = new ZVG.Column('#testing')
      expect(column.element).toBe('#testing')


