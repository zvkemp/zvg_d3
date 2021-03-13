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
  # series_3: { answer }
  # question_id: (one chart will combine existing point/multipoint functions)
  # value: { count of respondents giving that answer }
  #
  # VARIABLES:
  # series_1_domain: survey
  # series_2_domain: filter
  # series_3_domain: question ids
  #
  #
  #
  # FIXME:
  # if the series name is present, AND we are filtered by survey, split
  # use the series name groups. It's possible we already do this by coincidence.
  #
  # FIXME: if two filters are present, render as point chart.
  # FIXME: group point chart by series name
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

  min_value: (value, force = false) ->
    if value or value is 0
      v = parseInt(value)
      @_min_value = (if force then v else d3.min([(@_min_value or 0), v]))
      return @
    @_min_value

  max_value: (value, force = false) ->
    if value
      v = parseInt(value)
      @_max_value = (if force then v else d3.max([@_max_value or 1, v]))
      return @
    @_max_value

  constructor: (element, options = {}) ->
    super(element, options)
    @initialize_y_scale()
    @disable_series_2_label_click = true
    @survey_title_to_series_name = {}

  nestData: (data) ->
    _max_value = 0
    # data is nested with series 2 and 3 reversed: filtering produces different point shapes/colors,
    series_names = @survey_title_to_series_name
    # and additional questions increase the number of sub-columns.
    r = d3.nest()
      # FIXME: series_1 may not be a survey title, and might get false positives
      .key((z) -> series_names[z.series_1]).sortKeys(@seriesSortFunction(@_series_domain))
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

    @round_max_value(_max_value)
    return r

  round_max_value: (max) ->
    rounded = d3.round(max, 0)
    rounded += 1 if max > rounded
    @max_value(rounded)
    @

  _render: ->
    @reset_width()
    @set_series_1_spacing()
    @set_series_2_shapes_and_colors()
    @build_value_domain()
    @render_series_2_lines() if @render_series_2_lines
    @render_series_groups()
    @render_series_1()
    @render_y_scale()
    @render_series_1_labels()
    @render_series_2_labels() # series 3 for this chart
    @render_series_3()
    @render_series_2()
    @render_legend()
    @bind_value_group_hover()
    @bind_value_group_click()
    @widenAxis()

  # @override
  render_series_1: ->
    @series_1 = @series_groups.selectAll('.series1').data(((d) -> d.values), (d) -> d.key)
    @series_1.enter().append('g').attr('class', 'series1')
    @series_1.attr('transform',
      (d,i) =>
        "translate(#{@series_1_x_by_key[d.key]}, 0)"
    )
    @series_1.exit().remove()

  render_series_groups: ->
    @series_groups = @svg.selectAll('.series_group').data(@_data, (d) -> d.key)
    @series_groups.enter()
      .append('g')
      .attr('class', 'series_group')
    @series_groups.exit()
      .remove()

  _build_line_data: ->
    lineData = {}
    for series_group in @data()
      do (series_group) =>
        series_name = series_group.key
        for s1 in series_group.values
          do (s1) =>
            s1_key = s1.key
            for s2 in s1.values[0].values ## FIXME: what is this 0
              do (s2) =>
                s2_key = s2.key
                lineData[series_name] or= {}
                lineData[series_name][s2_key] or= []
                lineData[series_name][s2_key].push(s2.values)
    lineData


  _should_render_lines: () ->
    false

  render_series_2_lines: ->
    lineData = if @_should_render_lines() then @_build_line_data() else []

    chart = @
    x_offset = @column_band() + (@column_band.rangeBand() / 2)
    mapper = (v) ->
      [ chart.series_1_x_by_key[v.series_1] + x_offset,
        chart.value_domain(v.average)
      ]

    data = []
    for series_name, v of lineData
      do (series_name, v) =>
        for k, v2 of v
          do (k, v2) =>
            data.push({ key: k, values: v2.map(mapper), series_name: series_name })

    # data = ({key: k, values: v.map(mapper)} for k, v of lineData)

    paths = @svg.selectAll('path.line').data(data)
    paths.enter()
      .append('path')
      .attr('class', 'line series2')

    paths.attr('d',
      (d) ->
        if d.values.length is 1
          chart._register_singleton(d)
          []
        else
          d3.svg.line()(d.values)
    )
      .attr('fill', 'none')
      .attr('stroke', (d) -> chart.series_2_colors[d.key])
      .attr('stroke-width', '3px')

    paths.exit().remove()


  render_series_1_labels: ->
    # FIXME:
    # - flatten @_data into values
    #
    label_data = @_data.reduce(
      ((acc, v) -> acc.concat(v.values)),
      []
    )

    @series_1_labels = @series_1_label_container.selectAll('text.series1label')
      .data(label_data, @key_function)
    @series_1_labels.enter()
      .append('text')
      .attr('class', 'series1label')

    @series_1_labels.text((d) -> d.key)
    @series_1_labels #.transition()
      .attr('transform', (d,i) => "translate(#{@series_1_x_by_key[d.key] + @series_1_width_by_key[d.key]/2}, 0)")
      .style('text-anchor', null)
    @series_1_labels.exit().remove()
    @construct_series_1_label_map()
    @addLineBreaksToSeries1Labels() if @detect_overlaps(@series1LabelMap)

  # to be used in the detection of overlapping labels (in detect_overlaps())
  construct_series_2_label_map: ->
    label_map = []

    for g1, g1i in @series_groups[0]
      do (g1, g1i) =>
        g1_x = @series_1_x[g1i]
        for label in (d3.select(g1).selectAll('text.series2label')[0])
          do (label) ->
            ls     = d3.select(label)
            x      = g1_x + parseFloat(ls.attr('x'))
            length = label.getComputedTextLength()
            label_map.push({
              label: ls.text()
              x: x
              length: length
              start: x - (length / 2.0)
              end: x + (length / 2.0)
            })
    @series_2_label_map = label_map


  _hide_columns_below_n: () ->
    # FIXME need to hide one level in, not just the series names
    # temporarily disabled.

  # pre-establishes indexes for the spacing and grouping of series 1 data
  # based on its contents (necessary because of the variable length of data within
  # the series, otherwise simple rangebands could be used)
  #
  set_series_1_spacing: ->
    # FIXME: remove series_1_width and series_1_x entirely?
    @series_1_width      = []
    @series_1_width_by_key = {}
    @series_1_x          = []
    @series_1_x_by_key   = {}
    scale                = d3.scale.ordinal().domain(@series_1_domain())
    ranges               = {}
    total_column_count   = 0
    total_column_count  += d.values.length for d in @_data

    # FIXME: is this the exact same thing as total_column_count?
    total_length         = d3.sum(@_data.map((e) -> e.values.length))
    series_count         = @_data.length
    @column_spacing      = (@width - @x_offset)/(total_column_count + total_length + (series_count - 1))
    @column_padding      = 0.1 * @column_spacing
    @series_padding      = @column_spacing / 2
    current_x            = @x_offset # allow for scale on left
    maxCount             = 0
    real_i               = 0

    for series_data,series_index in @_data
      do (series_data,series_index) =>
        for d,i in series_data.values
          do (d,i) =>
            maxCount = d3.max([maxCount, d.values.length])
            w = @column_spacing * (d.values.length + 1)
            @series_1_width[real_i] = w - @series_padding * 2
            @series_1_width_by_key[d.key] = w - @series_padding * 2
            @series_1_x[real_i] = current_x + @series_padding
            @series_1_x_by_key[d.key] = current_x + @series_padding
            current_x += w
            real_i += 1

        # console.log("setting current_x after series #{series_data.key}", current_x, current_x + @series_padding)
        current_x += @series_padding # add additional space between series groupings

    @column_band = d3.scale.ordinal()
      .domain([0...maxCount])
      .rangeRoundBands([0, @column_spacing * maxCount], 0.1)
    @widen_chart((@width - @x_offset) + 100) if @column_band.rangeBand() < @minimum_column_width

  minimum_column_width: 32
  x_offset: 30
  y_padding: 30

  build_value_domain: ->
    keys = (key for key, _ of (@_strict_scale or @_key_scale or {}))
    min = d3.min(keys) or 0
    max = d3.max(keys) or 1

    @max_value(max, @_strict_scale) # force if strict_scale is defined
    @min_value(min, @_strict_scale) # force if strict_scale is defined

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
    @y_scale_labels = @y_scale.append('g').attr('class', 'labelGroup')

  widenAxis: () ->
    try
      target_width = d3.max(@y_scale_labels.selectAll('text')[0].map((e) => e.getBBox().width)) + 1
      # target_width = d3.round(@y_scale_labels[0][0].getBBox().width)
      if target_width <= @x_offset
        return
      @x_offset = target_width
      @y_scale.select('rect').attr('width', @x_offset)
      @_render()
    catch e
      console.error(e)

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

  key_scale: (obj) ->
    if obj
      @_key_scale = obj
      return @
    @_key_scale

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

    labels = @y_scale_labels.selectAll('text.scale_label').data(@ticks())
    labels.enter()
      .append('text').attr('class', 'scale_label')
      .style('fill', ZVG.flatUIColors['CLOUDS'])
      .style('font-size', '11pt')
      .attr('alignment-baseline', 'middle')
      .attr('text-anchor', 'middle')
    labels.attr('x', @x_offset/2)
      .attr('y', @value_domain)
      .text(@_labelFormatter)
    labels.exit().remove()

    scale_obj = @_strict_scale or @_key_scale or {}
    data = (({ value: value, label: label }) for value, label of scale_obj when "#{value}" isnt label)
    keys = @y_scale.selectAll('text.key_label').data(data)
    keys.enter()
      .append('text').attr('class', 'key_label')
      .style('fill', ZVG.flatUIColors['CONCRETE'])
      .style('font-size', '11pt')
      .attr('alignment-baseline', 'middle')
    keys.attr('x', @x_offset + 5)
      .attr('y', (d) => @value_domain(d.value))
      .text((d) -> d.label)
    keys.exit().remove()


  # in this chart, series 3 represents a column (x)
  render_series_3: ->
    @series_3 = @series_1.selectAll('.series3').data(
      (d) ->
        d.values
    )
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
    colorset = (value for key,value of ZVG.flatUIColorsOnly)
    l = colorset.length

    for key,index in @series_2_domain()
      do (key, index) =>
        @series_2_colors[key] = colorset[(index*2)%colorset.length]
        @series_2_shapes[key] = ZVG.PointShapes[index%4]



  _shape_callback: () ->

  # in this chart, series_2 is a point in the column (y)
  render_series_2: ->
    @series_2 = @series_3.selectAll('.series2').data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'series2 vg')
      .attr('transform', "translate(0, #{@value_domain(@min_value())})")

    colors = @series_2_colors
    shapes = @series_2_shapes
    host   = @
    shape_callback = @_shape_callback
    @series_2.each((d) ->
      d3.select(this).selectAll('.zvg-point-shape, .zvg-point-label').remove()
      shape_callback(host, new (shapes[d.key])(this, colors[d.key], {}), d)
      selection = d3.select(this)
      selection.append('text')
        .attr('class', 'zvg-point-label label-hover series2label')
        .text(host.labelFormatter(d3.round(d.values.average, 3)))
        .attr('fill', (d) -> host.n_threshold_color('gray')(d.values))
        .attr('transform', "translate(9,0)")
        .datum(d.key)
        .style('opacity', 0)

      selection.append('text')
        .attr('class', 'zvg-point-label-small label-hover series2label n-label')
        .text("n = #{d.values.n}")
        .attr('fill', (d) -> host.n_threshold_color('gray')(d.values))
        .attr('transform', "translate(9, 12)")
        .style('opacity', 0)
        .datum(d.key)

    )

    @series_2.transition().duration(700)
      .attr('transform', (d) => "translate(0, #{@value_domain(d.values.average)})")
    @series_2.exit().remove()

  legend_data: ->
    s2d = (e for e in @series_2_domain() when e in (@_series_2_raw_domain or []))
    return [] if s2d.length is 1 and s2d[0] is "all"
    ({ key: x, text: @legend_labels()[x] or "#{x}" } for x in s2d.slice(0).reverse())

  apply_legend_elements: (selection) ->
    height        = @legend_item_height
    colors        = @series_2_colors
    shapes        = @series_2_shapes
    each_function = (d) ->
      new (shapes[d.key])(this, colors[d.key], { x: 7, y: 5, center: false })
      d3.select(@).append('text').attr('class', 'legend_text')
        .text((d) -> d.text)
        .attr('x', 25)
        .attr('y', height / 2 + 2)

    @_apply_legend_elements(selection, height, each_function)

  value_group_selector: '.series2'

  renderFilterLegend: -> null

  series_2_label_sum: (d) ->
    d3.sum((value.values.n or 0) for value in d.values)

  dim_values_not_matching: (key) =>
    @container.selectAll(@value_group_selector)
      .filter((e) -> e.key != key)
      .style('opacity', 0.1)

    @container.selectAll('.label-hover')
      .filter((e) -> e is key or e.key is key)
      .style('opacity', 1)

  undim_all_values: =>
    @container.selectAll(@value_group_selector).style('opacity', 1)
    @container.selectAll('.label-hover:not(.singleton)').style('opacity', 0)

  # for line charts wherein some data is just a single point
  _register_singleton: (d) ->
    @singletons or= {}
    @singletons[d.series_name] or= {}
    @singletons[d.series_name][d.key] = true
