class ZVG.Point extends ZVG.ColumnarLayoutChart
  # DATA:
  # series_1: { survey }
  # series_2: { filter }
  # series_3: { question (one chart will be combine existing point/multipoint functions }
  # value: { average }
  #
  #
  randomizeData: (s1count, s2count, s3count) ->
    randomness = ->
      i = parseInt(Math.random() * 25)
      'Hello This is Extra Text'.substr(0, i)
    s1count or= parseInt(Math.random() * 10 + 1)
    s2count or= parseInt(Math.random() * 6 + 1)
    s3count or= parseInt(Math.random() * 4 + 1)

    s1d = ("Survey#{randomness()}#{n}" for n in [1..s1count])
    @min_value(0)
    max = parseInt(Math.random() * 100)
    @max_value(max)

    raw = []
    for s in ([1..s1count])
      do (s) ->
        s2actual = parseInt(Math.random() * s2count) + 1
        for f in ([1..s2actual])
          do (f) ->
            for d in ([1..s3count])
              do (d) ->
                raw.push {
                  series_1: s1d[s-1]
                  series_2: "Filter #{f}"
                  series_3: d
                  value: (Math.random() * max)
                }
    @series_1_domain("Survey#{randomness()}#{n}" for n in [1..s1count])
    @series_2_domain("Filter #{n}" for n in [1..s2count])
    @series_3_domain("#{n}" for n in [1..s3count])
    @data(raw)
    @render()

  
  sample_data: [ # single question
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 100, value: 4.6 }
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 101, value: 1.6 }
    { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 100, value: 4.3 }
    { series_1: 'Survey 1', series_2: 'Filter 3', series_3: 100, value: 3.6 }
    { series_1: 'Survey 1', series_2: 'Filter 4', series_3: 100, value: 2.2 }
    { series_1: 'Survey 1', series_2: 'Filter 5', series_3: 100, value: 4.1 }
    { series_1: 'Survey 2', series_2: 'Filter 1', series_3: 100, value: 4.8 }
    { series_1: 'Survey 2', series_2: 'Filter 2', series_3: 100, value: 2.2 }
    { series_1: 'Survey 2', series_2: 'Filter 3', series_3: 100, value: 4.5 }
    { series_1: 'Survey 2', series_2: 'Filter 4', series_3: 100, value: 3.6 }
    { series_1: 'Survey 2', series_2: 'Filter 5', series_3: 100, value: 4.5 }
    { series_1: 'Survey 3', series_2: 'Filter 1', series_3: 100, value: 2.5 }
    { series_1: 'Survey 3', series_2: 'Filter 2', series_3: 100, value: 2.1 }
    { series_1: 'Survey 3', series_2: 'Filter 3', series_3: 100, value: 3.3 }
    { series_1: 'Survey 3', series_2: 'Filter 4', series_3: 100, value: 4.5 }
    { series_1: 'Survey 3', series_2: 'Filter 5', series_3: 100, value: 4.5 }
    { series_1: 'Survey 4', series_2: 'Filter 1', series_3: 100, value: 3.5 }
    { series_1: 'Survey 4', series_2: 'Filter 2', series_3: 100, value: 2.6 }
    { series_1: 'Survey 4', series_2: 'Filter 3', series_3: 100, value: 4.6 }
    { series_1: 'Survey 4', series_2: 'Filter 4', series_3: 100, value: 4.5 }
    { series_1: 'Survey 4', series_2: 'Filter 5', series_3: 100, value: 2.8 }
  ]

  sample_data2: [
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 101, value: 4.9 }
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 101, value: 1.6 }
    { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 101, value: 4.9 }
    { series_1: 'Survey 1', series_2: 'Filter 3', series_3: 100, value: 3.9 }
    { series_1: 'Survey 1', series_2: 'Filter 4', series_3: 100, value: 3.2 }
    { series_1: 'Survey 1', series_2: 'Filter 5', series_3: 100, value: 1.1 }
    { series_1: 'Survey 2', series_2: 'Filter 1', series_3: 100, value: 1.8 }
    { series_1: 'Survey 2', series_2: 'Filter 2', series_3: 100, value: 2.2 }
    { series_1: 'Survey 2', series_2: 'Filter 3', series_3: 100, value: 4.5 }
    { series_1: 'Survey 2', series_2: 'Filter 4', series_3: 100, value: 3.6 }
    { series_1: 'Survey 2', series_2: 'Filter 5', series_3: 100, value: 1.5 }
    { series_1: 'Survey 3', series_2: 'Filter 1', series_3: 100, value: 2.5 }
    { series_1: 'Survey 3', series_2: 'Filter 2', series_3: 100, value: 2.1 }
    { series_1: 'Survey 3', series_2: 'Filter 3', series_3: 101, value: 1.3 }
    { series_1: 'Survey 3', series_2: 'Filter 4', series_3: 101, value: 3.9 }
    { series_1: 'Survey 3', series_2: 'Filter 5', series_3: 100, value: 4.9 }
    { series_1: 'Survey 4', series_2: 'Filter 1', series_3: 100, value: 1.5 }
    { series_1: 'Survey 4', series_2: 'Filter 2', series_3: 100, value: 3.6 }
    { series_1: 'Survey 4', series_2: 'Filter 3', series_3: 101, value: 1.6 }
    { series_1: 'Survey 4', series_2: 'Filter 4', series_3: 100, value: 1.5 }
    { series_1: 'Survey 4', series_2: 'Filter 5', series_3: 100, value: 2.9 }
  ]

  min_value: (value) ->
    if value or value is 0
      @_min_value = value
      return @
    @_min_value
   
  max_value: (value) ->
    if value
      @_max_value = value
      return @
    @_max_value

  constructor: (element, options = {}) ->
    super(element, options)
    @initialize_y_scale()



  nestData: (data) ->
    # data is nested with series 2 and 3 reversed: filtering produces different point shapes/colors,
    # and additional questions increase the number of sub-columns.
    d3.nest()
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .key((z) -> z.series_3).sortKeys(@seriesSortFunction(@series_3_domain()))
      .key((z) -> z.series_2).sortKeys(@seriesSortFunction(@series_2_domain()))
      .entries(data)

  render: ->
    @reset_width()
    @set_series_1_spacing()
    @render_series_1()
    @build_value_domain()
    @render_y_scale()
    @render_series_3()
    @set_series_2_shapes_and_colors()
    @render_series_2()

  minimum_column_width: 10
  x_offset: 30
  y_padding: 30

  build_value_domain: ->
    @value_domain = d3.scale.linear()
      .domain([@min_value(), @max_value()]) # FIXME
      .range([@height - @y_padding, @y_padding])

  initialize_y_scale: ->
    console.log('initialize_y_scale')
    @y_scale = @svg.append('g').attr('class', 'y_scale')
    @y_scale.append('rect')
      .attr('rx', 0)
      .attr('ry', 0)
      .attr('width', @x_offset)
      .attr('height', @height)
      .style('stroke', 'none')
      .style('fill', ZVG.flatUIColors['CONCRETE'])

  # if the minimum value isn't shown on the scale, add a 0 at the bottom.
  ticks: ->
    t = @value_domain.ticks()
    t.unshift(0) unless @min_value() in t
    unless @max_value() in t
      new_max = t[t.length - 1] + (t[t.length - 1] - t[t.length - 2])
      t.push(new_max)
    return t


  render_y_scale: ->
    lines = @y_scale.selectAll('line.scale_line').data(@ticks())
    lines.enter()
      .append('line').attr('class', 'scale_line')
      .style('stroke', ZVG.flatUIColors['CONCRETE'])
      .attr('x1', 0)
      .attr('x2', 0)
    lines.attr('y1', @value_domain)
      .attr('y2', @value_domain)
      .transition().duration(1000).attr('x2', @width)
    lines.exit().remove()

    labels = @y_scale.selectAll('text.scale_label').data(@ticks())
    labels.enter()
      .append('text').attr('class', 'scale_label')
      .style('fill', ZVG.flatUIColors['CLOUDS'])
      .attr('alignment-baseline', 'middle')
      .attr('text-anchor', 'middle')
    labels.attr('x', @x_offset/2)
      .attr('y', @value_domain)
      .text((d) -> d)

    labels.exit().remove()


  render_series_3: ->
    @series_3 = @series_1.selectAll('.series3').data((d) -> d.values)
    @series_3.enter()
      .append('g')
      .attr('class', 'column series3')

    @series_3.transition().attr('transform', (d,i) => "translate(#{@column_band(i) + @column_band.rangeBand()/2},0)")
    @series_3.selectAll('line.scale_line').remove()
    @series_3.append('line')
      .attr('x1', 0)
      .attr('x2', 0)
      .attr('y1', 0)
      .attr('y2', @height)
      .style('stroke', ZVG.flatUIColors['CONCRETE'])
      .attr('class', 'scale_line')
    @series_3.exit().transition().attr('transform', "translate(0, #{@height})").remove()

  set_series_2_shapes_and_colors: ->
    @series_2_shapes = {}
    @series_2_colors = {}
    colorset = ZVG.colorSchemes.rainbow10
    colorset = (value for key,value of ZVG.flatUIColors)
    l = colorset.length

    for key,index in @series_2_domain()
      do (key, index) =>
        @series_2_colors[key] = colorset[(index*2)%colorset.length]
        @series_2_shapes[key] = ZVG.PointShapes[index%4]

        


  render_series_2: ->
    @series_2 = @series_3.selectAll('.series2').data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'series2')
      .attr('transform', "translate(0, #{@value_domain(@min_value())})")

    colors = @series_2_colors
    shapes = @series_2_shapes

    @series_2.each((d) ->
      new (shapes[d.key])(this, colors[d.key], "#{d.key}:#{d.values[0].series_1}:#{d.values[0].series_3}")
    )

    @series_2.transition().duration(700)
      .attr('transform', (d) => "translate(0, #{@value_domain(d.values[0].value)})")
    @series_2.exit().remove()




class ZVG.PointShape
  constructor: (container, fill, label) ->
    @container = container
    @fill = fill
    @render()
    # d3.select(@container).append('text').text(label) if label

  render: ->
    @apply_standard_attributes(@render_object())

  apply_standard_attributes: (obj) ->
    obj.attr('class', 'zvg-point-shape')
      .style('fill', @fill)

  render_object: ->
    d3.select(@container).append('circle')
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('r', 8)

class ZVG.SquarePoint extends ZVG.PointShape
  render_object: ->
    d3.select(@container).append('rect')
        .attr('x', -7)
        .attr('y', -7)
        .attr('width', 14)
        .attr('height', 14)

class ZVG.DiamondPoint extends ZVG.PointShape
  render_object: ->
    d3.select(@container).append('rect')
      .attr('x', -6.5)
      .attr('y', -6.5)
      .attr('width', 13)
      .attr('height', 13)
      .attr('transform', 'rotate(45)')

class ZVG.CirclePoint extends ZVG.PointShape

class ZVG.TrianglePoint extends ZVG.PointShape
  render_object: ->
    d3.select(@container).append('path')
      .attr('d', "M 0 -7 L 8 7 L -8 7 z")

      # 0,-5 6,5 -6,5
ZVG.PointShapes = [ZVG.SquarePoint, ZVG.DiamondPoint, ZVG.CirclePoint, ZVG.TrianglePoint]
