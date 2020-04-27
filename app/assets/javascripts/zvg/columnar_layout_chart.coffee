class ZVG.ColumnarLayoutChart extends ZVG.BasicChart
  constructor: (element, options = {}) ->
    super(element)
    @_options = options
    @initialize_series_1_label_container()
    @_legend_labels = {}

  initialize_series_1_label_container: -> @series_1_label_container = @svg.append('g')

  # used to re-narrow chart in case new data is smaller than current
  reset_width: ->
    @widen_chart ZVG.BasicChart.prototype.width

  # ensure a minimum viable width of individual columns
  widen_chart: (width) ->
    super(width)
    @set_series_1_spacing()

  legend_width: 0

  # x offset for point chart scale on left
  x_offset: 0

  _hide_columns_below_n: (n) ->
    columns_are_hidden = false
    host = @
    select_columns_above = (n, data) ->
      values = data.values.filter((v) -> host.series_2_label_sum(v, data.key) >= n)
      columns_are_hidden = true if values.length < data.values.length
      { key: data.key, values: values }
    @_data = (d for d in (select_columns_above(n, d) for d in @_data) when d.values.length > 0)
    @_columns_are_hidden = columns_are_hidden
    @_show_unstable_legend = @_show_unstable_legend or columns_are_hidden # set once

  # pre-establishes indexes for the spacing and grouping of series 1 data
  # based on its contents (necessary because of the variable length of data within
  # the series, otherwise simple rangebands could be used)
  #
  set_series_1_spacing: ->
    @series_1_width      = []
    @series_1_x          = []
    @series_1_x_by_key   = {}
    scale                = d3.scale.ordinal().domain(@series_1_domain())
    ranges               = {}
    total_column_count   = 0
    total_column_count  += d.values.length for d in @_data
    @column_spacing      = (@width - @x_offset)/(total_column_count + @_data.length)
    @column_padding      = 0.1 * @column_spacing
    @series_padding      = @column_spacing / 2
    current_x            = @x_offset # allow for scale on left
    maxCount             = d3.max(@_data, (d) -> d.values.length)
    for d,i in @_data
      do (d,i) =>
        w = @column_spacing * (d.values.length + 1)
        @series_1_width[i] = w - @series_padding * 2
        @series_1_x[i] = current_x + @series_padding
        @series_1_x_by_key[d.key] = current_x + @series_padding
        current_x += w
    @column_band = d3.scale.ordinal()
      .domain([0...maxCount])
      .rangeRoundBands([0, @column_spacing * maxCount], 0.1)
    @widen_chart((@width - @x_offset) + 100) if @column_band.rangeBand() < @minimum_column_width

  render_series_1: ->
    @series_1 = @svg.selectAll('.series1').data(@_data, (d) -> d.key)
    @series_1.enter().append('g').attr('class', 'series1')
    @series_1.attr('transform', (d,i) => "translate(#{@series_1_x[i]}, 0)")
    @series_1.exit().remove()

  sortedS3Domain: ->
    @series_3_domain().sort((x, y) -> x > y)

  legend_data: ->
    try
      #This version pulls the present values out
      ({ key: x, text: (@legend_labels()[x] or "_value_#{x}")} for x in @series_3_domain()).reverse()

      # This one uses all legend labels, whether they are represented by the data or not.
      # ({ key: key, text: text } for key, text of @legend_labels()).reverse()
    catch e
      console.info(e)
      []

  renderUnstableLegend: =>
    return unless @_show_unstable_legend
    @_checked or= {}
    h = @legend_item_height
    d = ['unstable']
    @legend.selectAll('g.unstable').remove()
    offset = (@legend.selectAll('.legend-icon')[0].length + 1.5) * @legend_item_height
    offset = (@legend.selectAll('text.legend_text')[0].length + 1.5) * @legend_item_height

    items = @legend.selectAll('g.unstable')
      .data(d)
    items.enter()
      .append('g')
      .attr('class', 'filter_legend_item legend_item')
      .attr('label', (d) -> d)
      .attr('transform', (d, i) -> "translate(10, #{offset + (i * h)})")

    filter_checkboxes = items.append('rect')
      .attr('height', 8).attr('width', 8)
      .style('fill', (d) => if @_show_unstable_data then ZVG.flatUIColors["CARROT"] else ZVG.flatUIColors["CLOUDS"])
      .attr('checked',(d) => @_show_unstable_data)

    items.on('click', (d,i) =>
      @show_unstable_data(!@_show_unstable_data)
      @render()
    )

    items.append('text').attr('class', 'legend_text')
      .text((d) => "Show unstable data (n < #{@_n_threshold})")
      # .style('alignment-baseline', 'middle')
      .attr('transform', "translate(12, 5)")

  render_series_1_labels: ->
    @series_1_labels = @series_1_label_container.selectAll('text.series1label')
      .data(@_data, @key_function)
    @series_1_labels.enter()
      .append('text')
      .attr('class', 'series1label')

    @series_1_labels.text((d) -> d.key)
    @series_1_labels #.transition()
      .attr('transform', (d,i) => "translate(#{@series_1_x[i] + @series_1_width[i]/2}, 0)")
      .style('text-anchor', null)
    @series_1_labels.exit().remove()
    @construct_series_1_label_map()
    @addLineBreaksToSeries1Labels() if @detect_overlaps(@series1LabelMap)

  initialize_labels: ->
    @labels = d3.scale.linear().range([0, 1])
    @percent = d3.format('.0%')

  key_function: (data) -> data.key
  values_function: (data) -> data.values

  adjustSeries1EndLabels: ->
    # initial condition is horizontal labels with text-anchor: middle
    end_index = @series1LabelMap.length - 1
    start = @series1LabelMap[0]
    end   = @series1LabelMap[end_index]
    _start = d3.select(@series_1_labels[0][0])
    _end = d3.select(@series_1_labels[0][end_index])
    if start.start < 0
      difference = start.start
      new_center = start.x - difference # subtract the negative
      _start.attr('x', new_center)
    if end.end > @width
      difference = end.end - @width
      new_center = end.x - difference
      _end.attr('x', new_center)

  addLineBreaksToSeries1Labels: ->
    @series_1_labels.text(null)
    label_map = @series1LabelMap
    rb        = @column_band.rangeBand()
    tspans = @series_1_labels.selectAll('tspan')
      .data((d, i) -> ZVG.Utilities.splitString(d.key, Math.ceil(label_map[i].length / rb)))
    tspans.enter()
      .append('tspan')
    tspans.text((d) -> d)
      .attr('dy', (d, i) -> "#{if i == 0 then 0 else 1.1}em")
      .attr('x', 0)#(d) ->

  render_series_2_labels: (rotate = 0) ->
    @svg.selectAll('.series2label').remove()
    @series_2_labels = @series_1.selectAll('text.series2label')
      .data((d) ->
        (({ key: v.key, values: v.values, series_1: d.key }) for v in d.values)
      )
    @series_2_labels.enter()
      .append('text')
      .attr('class', 'series2label')
    @series_2_labels.attr('y', @height + 10)
      .attr('x', (d,i) => @column_band(i) + @column_band.rangeBand()/2)
      .attr('transform', (d,i) =>
        x = @column_band(i) + @column_band.rangeBand()/2
        y = @height + 10
        "rotate(#{rotate}, #{x}, #{y})"
      ).style("text-anchor", if rotate is 0 then 'middle' else 'end')
      .text((d) =>
        sum = @series_2_label_sum(d)
        d.n = sum
        (x for x in [@series_2_label_visibility(d.key), @nValueFormatter(sum)] when x).join(" ")
      ).attr('fill', @n_threshold_color('gray'))


    @series_2_labels.on('click', (d,i) =>
      (@_checked[k] = false) for k, _ of @_checked when k isnt d.key
      @filter_data([d.key])
      @render()
    )
    @construct_series_2_label_map()
    if @detect_overlaps(@series_2_label_map) and (rotate is 0)
      @rotateSeries2Labels()
    else
      @series_1_label_container.attr('transform', "translate(0, #{@height + 30})")

  series_2_label_sum: (d) ->
    d3.sum(value.values[0].value for value in d.values)

  rotateSeries2Labels: ->
    max_length = d3.max(l.length for l in @series_2_label_map)
    @render_series_2_labels(-90)
    @series_1_label_container.attr('transform', "translate(0, #{@height + max_length + 25})")

  rotateSeries1Labels: ->
    @series_1_labels.attr('transform', (d) ->
      s = d3.select(@)
      x = s.attr('x')
      y = s.attr('y')
      r = "rotate(-45, #{x}, #{y})"
      r
    ).style('text-anchor', 'end')

  series_2_label_visibility: (label) ->
    if @series_2_domain()[0] is 'all' and @series_2_domain().length is 1
      ""
    else
      label

  staggerSeries2Labels: ->
    @series_1_label_container.transition().attr('transform', "translate(0, #{@height + 45})")
    for label, index in @container.selectAll('text.series2label')[0]
      do (label, index) ->
        if (index % 2) is 1
          current_y = parseFloat(d3.select(label).attr('y'))
          d3.select(label).attr('y', 15 + current_y)

  stagger_series_1_labels: ->
    for label, index in @series_1_labels[0]
      do (label, index) =>
        if (index % 2) is 1
          d3.select(label).attr('y', 15)

  # to be used to in the detection of overlapping labels (in detect_overlaps()
  construct_series_2_label_map: ->
    label_map = []
    for g1, g1i in @series_1[0]
      do (g1, g1i) =>
        g1_x = @series_1_x[g1i] # correctly correctington
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

  _transform = (node) ->
    d3.transform( d3.select(node).attr('transform'))

  _translate = (node) ->
    _transform(node).translate

  construct_series_1_label_map: ->
    label_map = []

    @series_1_labels.each((datum, index) ->
      node   = this
      x      = _translate(node)[0]
      length = node.getComputedTextLength()
      ls     = d3.select(node)
      label_map.push({
        label: ls.text()
        x: x
        length: length
        start: x - (length / 2.0)
        end: x + (length / 2.0)
      })
    )

    @series1LabelMap = label_map

  detect_overlaps: (label_map) ->
    overlap = false
    for label, index in label_map
      do (label, index) =>
        prev = label_map[index - 1]
        if prev and (prev.end > label.start)
          overlap = true
    return overlap
