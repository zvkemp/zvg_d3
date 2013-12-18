class ZVG.Radar extends ZVG.BasicChart
  # Data format should be as follows:
  # (scalar data only, categorical variables are not likely to work well)
  # {
  #   series_1: ... (survey or filter 1)
  #   series_2: ... (survey or filter 2)
  #   series_3: ... question id
  #   value: ... average of values
  # }
  constructor: ->
    @initializeSvg()

  render: ->
    @initializeCenterGroup()
    @establishRadialDomain()
    @establishAngularDomain()
    # @renderTestingMarks()
    @renderAxes()
    @renderSeries()

  initializeCenterGroup: ->
    @center = @svg.append('g').attr('label', 'center')
      .attr('transform', "translate(#{@width/2}, #{@height/2})")
    @axes = @center.append('g').attr('label', 'axes')
    @polygons = @center.append('g').attr('label', 'polygons')

  renderTestingMarks: ->
    # should point to upper-right corner
    @center.append('line')
      .attr('x1', 0)
      .attr('x2', @width/2)
      .attr('y1', 0)
      .attr('y2', -@height/2)
      .style('stroke', '#ddd')
    @center.selectAll('circle.testing')
      .data([1..@maxRadius()])
      .enter()
      .append('circle')
      .attr('class', 'testing')
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('r', (d) => @radialDomain(d))
      .style('fill', 'none')
      .style('stroke', '#ddd')
    pentagon = [(@convertToXY(5,index) for index in ([0..4]))]
    spokes = [0,1,2,3,4]
#    @center.selectAll('path.testing')
#      .data(pentagon)
#      .enter()
#      .append('path')
#      .attr('d', @polygon)
#      .style('fill', 'none')
#      .style('stroke', 'black')
#    @center.selectAll('line.spoke')
#      .data(spokes)
#      .enter()
#      .append('line')
#      .attr('x1', 0)
#      .attr('y1', 0)
#      .attr('x2', (d) => @convertToXY(5, d).x)
#      .attr('y2', (d) => @convertToXY(5, d).y)
#      .style('stroke', 'black')
#      .attr('label', (d) -> d)

  # not yet in use
  series_3_domain: (d) ->
    if d
      @_series_3_domain = d
      return @
    @_series_3_domain

  polygon: d3.svg.line()
    .x((d) -> d.x)
    .y((d) -> d.y)
    .interpolate('linear-closed')

  renderAxes: ->
    spokes = @axes.selectAll('line.spoke')
      .data(@convertToXY(@maxRadius(), i) for i in ([0...@series3Length()]))
    spokes.enter()
      .append('line')
      .attr('class', 'spoke')
      .attr('x1', 0)
      .attr('y1', 0)
    spokes.attr('x2', (d) -> d.x)
      .attr('y2', (d) -> d.y)

    webData = ((@convertToXY(radius, index) for index in ([0...@series3Length()])) for radius in ([1..@maxRadius()]))
    webs = @axes.selectAll('path.spoke')
      .data(webData)
    webs.enter()
      .append('path')
      .attr('class', 'spoke')
    webs.attr('d', @polygon)

  colors: d3.scale.ordinal().range(ZVG.colorSchemes.rainbow10)
  colors: d3.scale.category10()

  renderSeries: ->
    polygons = @polygons.selectAll('path.polygon')
      .data(@polygonData())

    polygons.enter()
      .append('path')
      .attr('class', 'polygon')
      .attr('d', (d) => @polygon({ x: 0, y: 0} for point in d.points))
      .style('fill-opacity', 0.5)
    polygons.attr('label', (d) -> d.key)
      .transition().duration(1000)
      .attr('d', (d) => @polygon(d.points))
      .style('fill', (d) => @colors(d.key))

  polygonData: ->
    (for d in @_data
      do (d) =>
        values = (x.value for x in d.values when x.series_2 is @currentFilter())
        {
          key: d.key
          points: (@convertToXY(v,index) for v,index in values)
          values: values
        }

    )


  currentFilter: ->
    @_currentFilter or= @series_2_domain()[0]



  maxRadius: (max) ->
    if max
      @_maxRadius = max
      @establishRadialDomain
      return @
    unless @_maxRadius
      @maxRadius(@getDefaultMaxRadius())
    @_maxRadius

  getDefaultMaxRadius: ->
    d3.max(d.value for d in @raw_data)

  establishRadialDomain: ->
    @radialDomain = d3.scale.linear()
      .domain([0, @maxRadius()])
      .nice()
      .range([0, 0.9 * @height/2])

  series3Length: ->
    @_series3Length or= (d3.scale.ordinal().domain(x.series_3 for x in @raw_data).domain().length)

  # the angle at which each question point is rendered around the center
  establishAngularDomain: ->
    @angularDomain = d3.scale.linear()
      .domain([0,@series3Length()]) # index includes an extra value to prevent overlapping of first and last real values. 
      .range([-2.5 * Math.PI, -0.5 * Math.PI]) # should start at 90 degrees and proceed clockwise for a full circle.
   
  convertToXY: (amplitude, domainIndex) ->
    angle = @angularDomain(domainIndex)
    radius = @radialDomain(amplitude)
    x = radius * Math.cos(angle)
    y = radius * Math.sin(angle)
    { x: x, y: y }

  nestData: (d) ->
    d3.nest()
      .key((z) -> z.series_1)
      .entries(d)







window.chart = new ZVG.Radar

window.simpleTestData = [
  # Single survey, single filter, 5 questions
  {
    series_1: 'Survey 1'
    series_2: 'all'
    series_3: 100
    value: 4.5
  }
  {
    series_1: 'Survey 1'
    series_2: 'all'
    series_3: 200
    value: 3.5
  }
  {
    series_1: 'Survey 1'
    series_2: 'all'
    series_3: 300
    value: 4.1
  }
  {
    series_1: 'Survey 1'
    series_2: 'all'
    series_3: 400
    value: 2.8
  }
  {
    series_1: 'Survey 1'
    series_2: 'all'
    series_3: 500
    value: 2.1
  }
  
  {
    series_1: 'Survey 2'
    series_2: 'all'
    series_3: 100
    value: 3.5
  }
  {
    series_1: 'Survey 2'
    series_2: 'all'
    series_3: 200
    value: 1.5
  }
  {
    series_1: 'Survey 2'
    series_2: 'all'
    series_3: 300
    value: 2.1
  }
  {
    series_1: 'Survey 2'
    series_2: 'all'
    series_3: 400
    value: 3.8
  }
  {
    series_1: 'Survey 2'
    series_2: 'all'
    series_3: 500
    value: 3.1
  }
]
chart.data(simpleTestData)
  .maxRadius(5)
  .series_2_domain(d3.scale.ordinal().domain(x.series_2 for x in simpleTestData).domain())
  .render()
