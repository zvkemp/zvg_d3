describe "Charts::Radar", ->
  afterEach ->
    d3.selectAll('svg').remove()
    d3.selectAll('div#testing').remove()
    d3.selectAll('div.zvg').remove()

  it 'should be defined', ->
    expect(ZVG.Column).toBeDefined()

  # series 3 is `question id`
  data = [
    { series_1: 'C', series_2: 'Z', series_3: 102, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Y', series_3: 100, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'Z', series_3: 101, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'X', series_3: 101, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'X', series_3: 101, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'X', series_3: 100, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Y', series_3: 102, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'X', series_3: 102, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'X', series_3: 100, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Y', series_3: 100, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Z', series_3: 100, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Z', series_3: 101, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Y', series_3: 102, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'Y', series_3: 100, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'X', series_3: 102, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'X', series_3: 102, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Z', series_3: 102, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Z', series_3: 100, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'X', series_3: 101, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Y', series_3: 101, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Y', series_3: 101, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'Z', series_3: 102, value: Math.random() * 5 }
    { series_1: 'A', series_2: 'X', series_3: 100, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'Z', series_3: 100, value: Math.random() * 5 }
    { series_1: 'B', series_2: 'Z', series_3: 101, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'Y', series_3: 101, value: Math.random() * 5 }
    { series_1: 'C', series_2: 'Y', series_3: 102, value: Math.random() * 5 }
  ]

  radar = null


  describe 'data handling', ->
    beforeEach -> radar = new ZVG.Radar

    it 'should have no data on init', ->
      expect(radar.data()).not.toBeDefined()

    it 'stores the original dataset', ->
      radar.data(data)
      expect(radar.raw_data).toBe(data)

    it 'stores the nested dataset', ->
      radar.series_1_domain(['A', 'B', 'C'])
      radar.data(data)
      series_1_keys = (x.key for x in radar.data())
      expect(series_1_keys).toEqual(['A', 'B', 'C'])

  describe 'polygon rendering', ->
    beforeEach ->
      radar = new ZVG.Radar
      radar.series_1_domain(['A','B','C'])
      radar.series_2_domain(['X','Y','Z'])
      radar.series_3_domain("#{n}" for n in [100..102])
      radar.data(data)
      radar.establishRadialDomain()
      radar.establishAngularDomain()

    it 'constructs an array of objects', ->
      pd = radar.polygonData()
      ['A', 'B', 'C'].forEach (s1) ->
        [100, 101, 102].forEach (s3,index) ->
          series_data = data.filter (d) -> d.series_1 is s1 and d.series_3 is s3
          mean = d3.mean(d.value for d in series_data)
          pdata = pd.filter (d) -> d.key is s1
          expect(pdata.length).toBe(1) # should be single result
          expect(pdata[0].values[index]).toBeCloseTo(mean, 5)
          
    it 'defaults to 0 for missing values', ->
      # add an extra question id; each means array should end in 0
      radar.series_3_domain("#{n}" for n in [100..103])
      radar.data(data)
      radar.establishRadialDomain()
      radar.establishAngularDomain()
      pd = radar.polygonData()
      pd.forEach (d) ->
        expect(d.values[d.values.length - 1]).toBe(0)

    it 'counts the series 3 data as number of vertices', ->
      expect(radar.series3Length()).toBe(3)
      expect(radar.numberOfVertices()).toBe(3)

    it 'renders the first point at 90 degrees (x = 0)', ->
      expect(radar.convertToXY(5, 0).x).toBeCloseTo(0, 1)

    it 'renders the first point at 90 degrees (y = 90% of chart height/2)', ->
      expect(radar.convertToXY(5,0).y).toBeCloseTo(-radar.height * 0.45, 1)

    it 'sets a custom max radius', ->
      radar.maxRadius(10)
      radar.establishRadialDomain()
      expect(radar.convertToXY(5,0).y).toBeCloseTo(-radar.height * 0.45/2, 1)
