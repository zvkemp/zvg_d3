class Dashboard.IntensityMatrix
  data: (d) ->
    @raw_data or= d
    @_data or= @setData(d) 
    
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
    @appendSeries1()
    @appendSeries2(@)

  appendSeries1: ->
    console.log 'appendSeries1'
    @series_1_groups or= @svg.selectAll('g.series_1')
      .data(@data())
      .enter()
      .append('g')
      .attr('class', 'series_1')
      .attr('transform', (d) => "translate(#{@x(d.key)}, 0)")

  appendSeries2: (chart) ->
    console.log 'appendSeries2'
    @series_2_groups = @series_1_groups.selectAll('rect.series_2')
      .data((d) -> d.values)
    @series_2_groups.enter()
      .append('rect')
      .attr('class', 'series_2')
    @series_2_groups.attr('y', (d) => @y(d.key))
      .attr('x', 0)
      .attr('title', (d) -> d.key)
      .attr('width', => @x.rangeBand())
      .attr('height', => @y.rangeBand())
      .style('fill', (d) => console.log(d.values[0].value); @colors()(d.values[0].value))

  colors: ->
    @_colors or= d3.scale.linear()
      .domain([0,100])
      .range(['white', '#a8cb17'])
      # .domain([0, d3.max(@raw_data.map (d) -> d.value)])



rawData = []
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
  'Under 45'
  '45 to 65'
  '65 and over'
]

randomData = -> Math.random() * 100

for s1 in s1domain
  do (s1) ->
    for s2 in s2domain
      do (s2) ->
        rawData.push({ series_1: s1, series_2: s2, value: randomData()})


window.rawData = rawData
window.chart = new Dashboard.IntensityMatrix()

chart.data(rawData)
chart.series_1_domain(s1domain)
chart.series_2_domain(s2domain)
chart.render()
