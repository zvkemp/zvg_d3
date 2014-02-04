describe "point chart", ->
  afterEach ->
    d3.selectAll('svg').remove()
    d3.selectAll('div#testing').remove()
    d3.selectAll('div.zvg').remove()

  it 'should be defined', ->
    expect(ZVG.Column).toBeDefined()

  data = [
    { series_1: "A", series_2: "Z", series_3: 100, value: 4.6 }
  ]
