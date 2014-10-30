class ZVG.Point extends ZVG.ColumnarLayoutChart
  # ISSUES:
  # series_2 transitions sometimes behave strangely while filtering. (maybe not an issue, filtering not active)
  # add n-values in data stream
  # display n-values for individual filtered points
  # display n-values for series3 (question) columns
  # rewrite so data format matches column chart data format, i.e. series_3 is the response and value is the count
  # where do the additional questions come in? Multiple sets of data? 'question_id' attribute?

  # RAW DATA:
  # series_1: { survey }
  # series_2: { filter }
  # series_3: { answer 
  # question_id: (one chart will combine existing point/multipoint functions)
  # value: { count of respondents giving that answer }
  #
  # VARIABLES:
  # series_1_domain: survey
  # series_2_domain: filter
  # series_3_domain: question ids
  #
  randomizeData: (s1count, s2count, s3count, q_count) ->
    randomness = ->
      i = parseInt(Math.random() * 25)
      'Hello This is Extra Text'.substr(0, i)
    s1count or= parseInt(Math.random() * 10 + 1)
    s2count or= parseInt(Math.random() * 6 + 1)
    s3count or= parseInt(Math.random() * 4 + 3)
    q_count or= 1

    s1d = ("Survey#{randomness()}#{n}" for n in [1..s1count])
    @min_value(0)
    @max_value(s3count)

    sample_data_hash = (survey, filter, question, answer, value) ->
      {
        series_1: survey,
        series_2: filter,
        question_id: question,
        series_3: answer,
        value: value
      }

    raw = []

    ([1..s1count]).forEach (s) ->
      ([1..s2count]).forEach (f) ->
        ([1..q_count]).forEach (q) ->
          ([1..s3count]).forEach (a) ->
            raw.push(sample_data_hash("Survey #{s}", "Filter #{f}", 100 + q, a, parseInt(Math.random() * 100)))


    @series_1_domain("Survey#{randomness()}#{n}" for n in [1..s1count])
    @series_2_domain("Filter #{n}" for n in [1..s2count])
    @series_3_domain("#{n}" for n in [1..s3count])
    @data(raw)
    @render()

  

  min_value: (value) ->
    if value or value is 0
      @_min_value = parseInt(value)
      return @
    @_min_value
   
  max_value: (value) ->
    if value
      @_max_value = parseInt(value)
      return @
    @_max_value

  constructor: (element, options = {}) ->
    super(element, options)
    @initialize_y_scale()
    window.p = @

  nestData: (data) ->
    _max_value = 0
    # data is nested with series 2 and 3 reversed: filtering produces different point shapes/colors,
    # and additional questions increase the number of sub-columns.
    r = d3.nest()
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .key((z) -> z.question_id).sortKeys(@seriesSortFunction(@series_3_domain()))
      .key((z) -> z.series_2).sortKeys(@seriesSortFunction(@series_2_domain()))
      .rollup((z) ->
        n_values   = (x.value for x in z)
        values     = (x.value * x.series_3 for x in z)
        n          = d3.sum(n_values)
        value_sum  = d3.sum(values)
        average    = value_sum / n
        _max_value = average if average > _max_value
        {
          question_id: z[0].question_id
          series_1: z[0].series_1
          series_2: z[0].series_2
          average: average
          n: n
        }
      )
      .entries(data)

    @round_max_value(d3.round(_max_value, 0))
    return r

  round_max_value: (max) ->
    @_max_value = d3.round(max, 0)
    @

  render: ->
    @reset_width()
    @set_series_1_spacing()
    @render_series_1()
    @build_value_domain()
    @render_y_scale()
    @render_series_1_labels()
    @render_series_2_labels() # series 3 for this chart
    @render_series_3()
    @set_series_2_shapes_and_colors()
    @render_series_2()
    @render_legend()
    @bind_value_group_hover()
    @bind_value_group_click()

  minimum_column_width: 10
  x_offset: 30
  y_padding: 30

  build_value_domain: ->
    if @_strict_scale
      keys = (key for key, _ of @_strict_scale)
      @max_value(d3.max(keys))
      @min_value(d3.min(keys))

    @value_domain = d3.scale.linear()
      .domain([@min_value(), @max_value()]) # FIXME
      .range([@height - @y_padding, @y_padding])

  initialize_y_scale: ->
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
  
  strict_scale: (obj) ->
    if obj
      @_strict_scale = obj
      return @
    @_strict_scale

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

    if @_strict_scale
      data = (({ value: value, label: label }) for value, label of @_strict_scale when "#{value}" isnt label)
      keys = @y_scale.selectAll('text.key_label').data(data)
      keys.enter()
        .append('text').attr('class', 'key_label')
        .style('fill', ZVG.flatUIColors['CONCRETE'])
      keys.attr('x', @x_offset + 5)
        .attr('y', (d) => @value_domain(d.value))
        .text((d) -> d.label)
      keys.exit().remove()


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
      d3.select(this).selectAll('.zvg-point-shape, .zvg-point-label').remove()
      new (shapes[d.key])(this, colors[d.key], "#{d.key}:#{d.values.series_1}:#{d.values.series_3}")
      selection = d3.select(this)
      selection.append('text')
        .attr('class', 'zvg-point-label label-hover series2label')
        .text(d3.round(d.values.average, 1))
        .attr('transform', "translate(9,0)")
        .datum(d.key)
        .style('opacity', 0)

      selection.append('text')
        .attr('class', 'zvg-point-label-small label-hover series2label n-label')
        .text("n = #{d.values.n}")
        .attr('transform', "translate(9, 12)")
        .style('opacity', 0)
        .datum(d.key)

    )

    @series_2.transition().duration(700)
      .attr('transform', (d) => "translate(0, #{@value_domain(d.values.average)})")
    @series_2.exit().remove()

  legend_data: ->
    ({ key: x, text: "#{x}" } for x in @series_2_domain().slice(0).reverse())

  apply_legend_elements: (selection) ->
    colors = @series_2_colors
    shapes = @series_2_shapes
    svgs   = selection.append('svg').attr('width', 18).attr('height', 18)
    groups = svgs.append('g').attr('transform', "translate(8,10)")
      .attr('class', 'series2')
    groups.each((d) -> new (shapes[d.key])(this, colors[d.key]))
    selection.append('span').attr('class', 'legend_text')
      .text((d) -> d.text)

  value_group_selector: '.series2'

  renderFilterLegend: -> null


  series_2_label_sum: (d) ->
    d3.sum((value.values.n or 0) for value in d.values)

  series_2_label_visibility: (label) ->
    if @series_3_domain().length is 1
      ""
    else
      label

  dim_values_not_matching: (key) =>
    @container.selectAll(@value_group_selector).filter((e) -> e.key != key)
      .style('opacity', 0.1)
    @container.selectAll('.label-hover').filter((e) -> e is key).style('opacity', 1)

  undim_all_values: =>
    @container.selectAll(@value_group_selector).style('opacity', 1)
    @container.selectAll('.label-hover').style('opacity', 0)

  series_2_label_visibility: (args...) -> null




class ZVG.PointShape
  constructor: (container, fill, label, scale = 1) ->
    @scale       = scale
    @container   = container
    @fill        = fill
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
      .attr('r', 8 * @scale)

class ZVG.SquarePoint extends ZVG.PointShape
  render_object: ->
    d3.select(@container).append('rect')
        .attr('x', -7 * @scale)
        .attr('y', -7 * @scale)
        .attr('width', 14 * @scale)
        .attr('height', 14 * @scale)

class ZVG.DiamondPoint extends ZVG.PointShape
  render_object: ->
    d3.select(@container).append('rect')
      .attr('x', -6.5 * @scale)
      .attr('y', -6.5 * @scale)
      .attr('width', 13 * @scale)
      .attr('height', 13 * @scale)
      .attr('transform', 'rotate(45)')

class ZVG.CirclePoint extends ZVG.PointShape

class ZVG.TrianglePoint extends ZVG.PointShape
  render_object: ->
    s = @scale
    d3.select(@container).append('path')
      .attr('d', "M 0 #{-7 * s} L #{8 * s} #{7 * s} L #{-8 * s} #{7 * s} z")

      # 0,-5 6,5 -6,5
ZVG.PointShapes = [ZVG.SquarePoint, ZVG.DiamondPoint, ZVG.CirclePoint, ZVG.TrianglePoint]
