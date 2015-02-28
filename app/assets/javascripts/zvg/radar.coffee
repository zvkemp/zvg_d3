class ZVG.Radar extends ZVG.BasicChart
  # Data format should be as follows:
  # (scalar data only, categorical variables are not likely to work well)
  # {
  #   series_1: ... (survey or filter 1)
  #   series_2: ... (survey or filter 2)
  #   series_3: ... question id
  #   value: ... average of values
  # }
  constructor: (args...) ->
    super(args...)
    @_currentFilter = @nullFilter

  _render: ->
    @initializeCenterGroup() unless @center # prevent multiple base group appends when re-rendering
    @establishRadialDomain()
    @establishAngularDomain()
    @renderAxes()
    @renderSeries()

  initializeCenterGroup: ->
    @center = @svg.append('g').attr('label', 'center')
      .attr('transform', "translate(#{@width/2}, #{@height/2})")
    @axes = @center.append('g').attr('label', 'axes')
    @polygons = @center.append('g').attr('label', 'polygons')

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
      .style('fill', 'none')
      .style('stroke', 'blue')

    webData = ((@convertToXY(radius, index) for index in ([0...@series3Length()])) for radius in ([1..@maxRadius()]))
    webs = @axes.selectAll('path.spoke')
      .data(webData)
    webs.enter()
      .append('path')
      .attr('class', 'spoke')
    webs.attr('d', @polygon)
      .style('fill', 'none')
      .style('stroke', 'red')

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
    polygons.exit().remove()

  polygonData: ->
    # Map data to objects:
    # 1. Nest and filter data based on current filter selections
    # 2. In case of NullFilter, all values are averaged together
    # 3. 0 is subbed in for missing values.
    # 4. Final object has original series 1 key, plus a set of XY coordinates and an array of means.
    (for d in @_data
      do (d) =>
        valuesHash = {}
        values = d3.nest()
          .key((x) -> x.series_3)
          .entries((z for z in d.values when @currentFilter(z)))
        (valuesHash[v.key] = v.values) for v in values
        means = ((d3.mean(z.value for z in (valuesHash[s3] or [{ value: 0 }]))) for s3 in @series_3_domain())
        {
          key: d.key
          points: (@convertToXY(v,index) for v,index in means)
          values: means
        }

    )


  currentFilter: (obj) ->
    @_currentFilter(obj)

  setFilter: (filter) ->
    if filter
      @_currentFilter = (x) -> x.series_2 is filter
    else
      @_currentFilter = @nullFilter
    @

  nullFilter: (x) -> true



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
    @series_3_domain().length

  numberOfVertices: ->
    @series3Length()

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
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .entries(d)

  randomizeData: (nSeries1, nSeries2, nSeries3, max) ->
    data = []
    for s1 in ([1..nSeries1])
      do (s1) ->
        for s2 in ([1..nSeries2])
          do (s2) ->
            for s3 in ([1..nSeries3])
              do (s3) ->
                data.push({
                  series_1: "Survey #{s1}"
                  series_2: "Filter #{s2}"
                  series_3: 100 * s3
                  value: Math.random() * max
                })
    @data(data)
    @render()

