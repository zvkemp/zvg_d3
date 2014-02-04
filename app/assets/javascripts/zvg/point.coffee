class ZVG.Point extends ZVG.ColumnarLayoutChart
  # DATA:
  # series_1: { survey }
  # series_2: { filter }
  # series_3: { question (one chart will be combine existing point/multipoint functions }
  # value: { average }
  #
  
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
    if value
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

  render_series_2: ->
    @series_2 = @series_3.selectAll('.series2').data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'series2')
      .attr('transform', "translate(0, #{@value_domain(@min_value())})")

    @series_2.transition().duration(700)
      .attr('transform', (d) => "translate(0, #{@value_domain(d.values[0].value)})")
    @series_2.append('circle').attr('cx', 0).attr('cy', 0).attr('r', 10)
    @series_2.exit().remove()





