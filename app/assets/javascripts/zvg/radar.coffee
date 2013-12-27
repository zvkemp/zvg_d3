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
    @_currentFilter = @nullFilter

  render: ->
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








window.chart = new ZVG.Radar

window.simpleTestData = [
  # Single survey, single filter, 5 questions
  { series_1: 'Survey 1', series_2: 'all', series_3: 100, value: 4.5 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 200, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 300, value: 4.1 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 400, value: 2.8 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 500, value: 2.1 }
  
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 100, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 200, value: 1.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 300, value: 2.1 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 400, value: 3.8 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 500, value: 3.1 }
]

window.moreComplexData = [
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:100, value: 3.4941219999454916},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:200, value: 1.9292143830098212},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:300, value: 2.713041902985424},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:400, value: 1.5061968080699444},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:500, value: 5.406578453723341},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:100, value: 4.2298069428652525},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:200, value: 5.5519170253537595},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:300, value: 0.2769786645658314},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:400, value: 1.6917675621807575},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:500, value: 0.619645903352648},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:100, value: 4.02297692745924},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:200, value: 2.8029478769749403},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:300, value: 0.9199619614519179},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:400, value: 2.8409991916269064},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:500, value: 4.59977040393278}
]

chart
  .series_1_domain(['Survey 1'])
  .series_2_domain("Filter #{n}" for n in [1..3])
  .series_3_domain("#{n}" for n in [100, 200, 300, 400, 500])
  .data(moreComplexData)
  .maxRadius(6)
  .setFilter('Filter 1')
  .render()
