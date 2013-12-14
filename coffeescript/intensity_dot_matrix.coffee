class Dashboard.IntensityMatrix
  constructor: ->
    d3.select('body').append('button')
      .text('randomize')
      .on('click', => @randomizeData())
    d3.select('body').append('br')
  data: (d) ->
    if d
      @raw_data = d
      @_data = @setData(d) 
    @_data
    
  setData: (d) ->
    d3.nest()
      .key((z) -> z.series_1)
      .key((z) -> z.series_2)
      .entries(d)

  width: 900
  height: 500

  series_1_domain: (d) ->
    @_series_1_domain or= d

  series_2_domain: (d) ->
    @_series_2_domain or= d

  render: ->
    @svg or= d3.select('body').append('svg')
      .attr('height', @height).attr('width', @width)
    @y or= d3.scale.ordinal()
      .domain(@series_2_domain())
      .rangeRoundBands([0, @height])
    @x or= d3.scale.ordinal()
      .domain(@series_1_domain())
      .rangeRoundBands([0, @width])
    # find smallest side:
    @range_band = if (@y.rangeBand() < @x.rangeBand()) then @y.rangeBand() else @x.rangeBand()
    @radius = d3.scale.linear()
      .domain([0,100]).range([0, @range_band * 0.45])
    @appendSeries1()
    @appendSeries2()

  appendSeries1: ->
    console.log 'appendSeries1'
    @series_1_groups = @svg.selectAll('g.series_1')
      .data(@data())
    @series_1_groups.enter()
      .append('g')
      .attr('class', 'series_1')
    @series_1_groups.attr('title', (d) -> d.key)
      .attr('transform', (d) => "translate(#{@x(d.key)}, 0)")
    @series_1_groups.exit().remove()

  appendSeries2: (chart) ->
    console.log 'appendSeries2'
    @series_2_groups = @series_1_groups.selectAll('circle.series_2')
      .data((d) -> d.values)
    @series_2_groups.enter()
      .append('circle')
      .attr('class', 'series_2')
      .attr('r', 0)

    @series_2_groups.attr('cy', (d) => @y(d.key) + @range_band / 2)
      .attr('cx', @range_band / 2)
      .transition().duration(1000)
      .attr('r', (d) => @radius(d.values[0].value))
      .attr('title', (d) -> d.key)
      .attr('width', => @range_band)
      .attr('height', => @range_band)
      .style('fill', (d) => @colors()(d.values[0].value))

    @series_2_groups.exit().remove()

  colors: ->
    @_colors or= d3.scale.linear()
      .domain([0,100])
      .range(['blue', '#a8cb17'])

  randomizeData: ->
    @_data.forEach((s1) ->
      s1.values.forEach((s2) ->
        s2.values.forEach((s3) ->
          s3.value = Math.random() * 100
        )
      )
    )
    @render()
      # .domain([0, d3.max(@raw_data.map (d) -> d.value)])



s1domain = [
  'Survey A'
  'Survey B'
  'Survey C'
  'Survey D'
  'Survey E'
  'Survey F'
  'Survey G'
  'Survey H'
]

s2domain = [
  'Under 25'
  '25 to 35'
  '35 to 45'
  '45 to 55'
  '55 to 65'
  '65 and over'
]
id = 0
randomData = -> Math.random() * 100
window.randomDataset = ->
  raw = []
  for s1 in s1domain
    do (s1) ->
      for s2 in s2domain
        do (s2) ->
          raw.push({ id: id++, series_1: s1, series_2: s2, value: randomData()})
  raw


window.rawData = randomDataset()
window.chart = new Dashboard.IntensityMatrix()

chart.data(randomDataset())
chart.series_1_domain(s1domain)
chart.series_2_domain(s2domain)
chart.render()

