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

  _render: ->
    @initializeCenterGroup() unless @center # prevent multiple base group appends when re-rendering
    @establishRadialDomain()
    @establishAngularDomain()
    @renderAxes()
    @renderSeries()
    @render_legend()
    @bind_value_group_hover()
    @bind_value_group_click()

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

  legend_data: ->
    ({ key: x, text: x } for x in @series_1_domain())

  value_group_selector: ".vg"

  legend_width: 400

  polygon: d3.svg.line()
    .x((d) -> d.x)
    .y((d) -> d.y)
    .interpolate('linear-closed')

  commonAxesStyles = (selection) ->
    selection.style('fill', 'none')
      .style('stroke', ZVG.flatUIColors['SILVER'])
      .style('stroke-dasharray', '2 2')
    selection

  renderAxes: ->
    spokes = @axes.selectAll('line.spoke')
      .data(@convertToXY(@maxRadius(), i) for i in ([0...@series3Length()]))
    spokes.enter()
      .append('line')
      .attr('class', 'spoke')
      .attr('x1', 0)
      .attr('y1', 0)
    spokes.attr('x2', (d) -> d.x).attr('y2', (d) -> d.y)
    commonAxesStyles(spokes)

    webData = ((@convertToXY(radius, index) for index in ([0...@series3Length()])) for radius in ([1..@maxRadius()]))
    webs = @axes.selectAll('path.spoke')
      .data(webData)
    webs.enter()
      .append('path')
      .attr('class', 'spoke')
    webs.attr('d', @polygon)
    commonAxesStyles(webs)

  colors: d3.scale.ordinal().range(ZVG.colorSchemes.rainbow10)
  colors: d3.scale.category10()

  sortByArea = (pg_data) ->
    pg_data.sort((pg) ->
      -(d3.geom.polygon(pg.points.map((f) -> [f.x, f.y])).area())
    )

  renderSeries: ->
    polygons = @polygons.selectAll('path.polygon')
      .data(sortByArea(@polygonData()))
    polygons.enter()
      .append('path')
      .attr('class', "polygon #{@value_group_selector.substr(1,100)}")
      .attr('d', (d) => @polygon({ x: 0, y: 0} for point in d.points))
      .style('fill-opacity', 0.4)

    polygons.attr('label', (d) -> d.key)
      .transition().duration(500)
      .attr('d', (d) => @polygon(d.points))
      .style('fill', (d) => @colors(d.key))
    polygons.exit().remove()

  polygonData: ->
    # Map data to objects:
    # 1. Nest and filter data based on current filter selections
    # 2. In case of NullFilter, all values are averaged together
    # 3. 0 is subbed in for missing values.
    # 4. Final object has original series 1 key, plus a set of XY coordinates and an array of means.
    self = @
    (for d in @_data
      do (d) =>
        valuesHash = {}

        (d.values or []).forEach((entry) ->
          valuesHash[entry.question_id] or= {}
          valuesHash[entry.question_id][entry.series_3] or= 0
          valuesHash[entry.question_id][entry.series_3] += entry.count
        )

        meanValue = (obj) ->
          value = 0
          count = 0
          bump = (v1, c1) ->
            v2 = parseFloat(v1)
            c2 = parseInt(c1)
            value += (c2 * v2)
            count += c2
          bump(v, c) for v, c of obj
          value / count

        means = (meanValue(valuesHash[s3]) for s3 in @series_3_domain())

        {
          key: d.key
          points: (@convertToXY(v,index) for v,index in means)
          values: means
        }

    )

  maxRadius: (max) ->
    if max
      @_maxRadius = max
      @establishRadialDomain
      if @center
        @center.remove()
        @center = null
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

  # randomizeData: (nSeries1, nSeries2, nSeries3, max) ->
  #   # NOTE: the domains shouldn't be pushed this often, but the mistaken result is very cool.
  #   data = []
  #   s1_domain = []
  #   s2_domain = []
  #   s3_domain = []
  #   for s1 in ([1..nSeries1])
  #     do (s1) ->
  #       s1_domain.push("Survey #{s1}")
  #       for s2 in ([1..nSeries2])
  #         do (s2) ->
  #           s2_domain.push("Filter #{s2}")
  #           for s3 in ([1..nSeries3])
  #             do (s3) ->
  #               s3_domain.push("#{100 * s3}")
  #               data.push({
  #                 series_1: "Survey #{s1}"
  #                 series_2: "Filter #{s2}"
  #                 question_id: 100 * s3
  #                 series_3: Math.random() * max
  #                 count: parseInt(Math.random() * 500)
  #               })
  #   console.log(s3_domain)
  #   console.log(s2_domain)
  #   console.log(s1_domain)
  #   @series_3_domain(s3_domain)
  #   @series_2_domain(s2_domain)
  #   @series_1_domain(s1_domain)
  #   @data(data)
  #   @setFilter()
  #   @maxRadius(max)
  #   @render()

  randomizeData: (nSeries1, nSeries2, nSeries3, max) ->
    rand_val = -> parseInt(Math.random() * 7)
    nSeries1 or= rand_val() + 2
    nSeries2 or= rand_val() + 1
    nSeries3 or= rand_val() + 3
    max or= 5
    data = []
    s1_domain = ("Survey #{s1}" for s1 in [1..nSeries1])
    s2_domain = ("Filter #{s2}" for s2 in [1..nSeries2])
    s3_domain = ("#{100 * n}" for n in [1..nSeries3])
    for s1 in ([1..nSeries1])
      do (s1) ->
        for s2 in ([1..nSeries2])
          do (s2) ->
            for s3 in ([1..nSeries3])
              do (s3) ->
                data.push({
                  series_1: "Survey #{s1}"
                  series_2: "Filter #{s2}"
                  question_id: 100 * s3
                  series_3: Math.random() * max
                  count: parseInt(Math.random() * 500)
                })
    @series_3_domain(s3_domain)
    @series_2_domain(s2_domain)
    @series_1_domain(s1_domain)
    @data(data)
    @maxRadius(max)
    @render()

