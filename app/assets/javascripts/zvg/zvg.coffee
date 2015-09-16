window.ZVG = {
  stylesheet: """
    .column-label, .series1label, .series2label, .legend_text {
      font-family: arial, sans-serif;
      font-weight: bold;
      text-anchor: middle;
      font-size: 10pt;
      alignment-baseline: central;
    }

    .column-label {
      color: white;
      fill: white;
    }

    .series2label {
      font-size: 9pt;
      fill: #888;
      font-weight: normal;
    }

    .legend_text {
      font-size: 9pt;
      text-anchor: start;
      alignment-baseline: baseline;
      font-weight: bold;
    }

    .zvg {
      display: table;
    }

    .zvg-container {
      display: table-row;
    }

    .zvg-chart {
      display: table-cell;
      margin: 10px;
      vertical-align: top;

    }

    .zvg-point-shape {
      stroke: white;
      stroke-width: 1pt;
    }

    .series2 text {
      font-size: 8pt;
    }

    .legend_item {
      padding-left: 10px;
      padding-bottom: 5px;
    }

    .legend_item, .vg {
      cursor: pointer;
    }

    .filter_legend_item > .legend_text {
      padding-left: 5px;
    }

    .scale_line {
      stroke-dasharray: 2 8;
    }

    .scale_label, .key_label {
      font-family: helvetica, arial, sans-serif;
      font-weight: bold;
    }

    text.zvg-point-label {
      font-size: 11pt;
      text-anchor: start;
      font-weight: bold;
    }

    text.zvg-point-label-small {
      text-anchor: start;
    }

    text.key_label {
      font-size: 10pt;
      alignment-baseline: middle;
    }
    """

  flatUIColors: {
    # from http://designmodo.github.io/Flat-UI/
    'TURQUOISE': '#1ABC9C'
    'GREEN SEA': '#16A085'
    'EMERALD': '#2ECC71'
    'NEPHRITIS': '#27AE60'
    'PETER RIVER': '#3498DB'
    'BELIZE HOLE': '#2980B9'
    'AMETHYST': '#9B59B6'
    'WISTERIA': '#8E44AD'
    'WET ASPHALT': '#34495E'
    'MIDNIGHT BLUE': '#2C3E50'
    'SUN FLOWER': '#F1C40F'
    'ORANGE': '#F39C12'
    'CARROT': '#E67E22'
    'PUMPKIN': '#D35400'
    'ALIZARIN': '#E74C3C'
    'POMEGRANATE': '#C0392B'
    'CLOUDS': '#ECF0F1'
    'SILVER': '#BDC3C7'
    'CONCRETE': '#95A5A6'
    'ASBESTOS': '#7F8C8D'
  }

  colorSchemes: {
    rainbow10: [
      '#cbb69d'
      '#7e654f'
      '#73446f'
      '#b897a6'
      '#53bedb'
      '#009d9d'
      '#a8cb17'
      '#fcda51'
      '#f38d05'
      '#dc001b'
    ]

    rainbow20: [
      '#b09778'
      '#7d664e'
      '#57422f'
      '#50353F'
      '#4A254D'
      '#694565'
      '#957084'
      '#748DA7'
      '#43A6CF'
      '#3392A2'
      '#1B807C'
      '#5B9A57'
      '#8DBA23'
      '#C1C31E'
      '#F8CB18'
      '#EB9415'
      '#E06314'
      '#CE3C1A'
      '#BD031D'
      '#CD3467'
    ]

    warmCool10: [
      '#fcd94f'
      '#f29738'
      '#ed782e'
      '#e85b27'
      '#e53a22'
      '#b63133'
      '#8e283e'
      '#6c2146'
      '#501b4d'
      '#361653'
    ]
  }
}



ZVG.Utilities = {
  splitString: (string, n_lines = 2) ->
    words = string.split(' ')
    length = words.length
    words_per_line = Math.ceil(length / n_lines)
    result = []

    for i in (x for x in [0..(length - 1)] by words_per_line)
      result.push(words.slice(i, i + words_per_line).join(' '))

    return result

  splitStringByMaxLineLength: (string, max_length = 30) ->
    d = d3.selectAll('#string_length_comparison').data([1])
    d.enter()
      .append('svg')
      .attr('id', 'string_length_comparison')
      .attr('opacity', 0)

    results = []
    for n in [1, 2, 3]
      do (n) ->
        s = d.selectAll('text').data(ZVG.Utilities.splitString(string, n))
        s.enter()
          .append('text')
          .attr('class', 'series1label')
        s.text((d) -> d)
        s.exit().remove()
        #s.each((d, i) -> console.log(n, { l: @getComputedTextLength(), s: d }))
    #console.log(results)
    [string]

}

class ZVG.BackgroundGradient
  constructor: (svg) ->
    @gradient = svg.append('defs')
      .append('linearGradient')
      .attr('x1', '0%').attr('y1', '0%')
      .attr('x2', '80%').attr('y2', '50%')
      .attr('spreadMethod', 'pad')
      .attr('id', 'standardBackgroundGradient')
    @gradient.append('stop')
      .attr('offset', '10%')
      .attr('stop-color', '#aaa')
      .attr('stop-opacity', 1)
    @gradient.append('stop')
      .attr('offset', '110%')
      .attr('stop-color', '#777')
      .attr('stop-opacity', 1)
#    @shadow = svg.select('defs')
#      .append('filter')
#      .attr('id', 'drop_shadow')
#      .attr('x', 0)
#      .attr('y', 0)
#      .attr('width', '200%')
#      .attr('height', '200%')
#    @shadow.append('feOffset')
#      .attr('result', 'offOut')
#      .attr('in', 'SourceAlpha')
#      .attr('dx', 2)
#      .attr('dy', 2)
#    @shadow.append('feGaussianBlur')
#      .attr('result', 'blurOut')
#      .attr('in', 'offOut')
#      .attr('stdDeviation', 20)
#    @shadow.append('feBlend')
#      .attr('in', 'SourceGraphic')
#      .attr('in2', 'blurOut')
#      .attr('mode', 'normal')
#

ZVG.backgroundColor = ZVG.flatUIColors['CLOUDS']

class ZVG.Background
  constructor: (svg, height, width, radius = 5) ->

    # ZVG.BackgroundGradient(svg)
    backgroundGroup = svg.append('g')
    @background = backgroundGroup.append('rect')
      .style('fill', ZVG.backgroundColor)
      #.style('fill', ZVG.flatUIColors['CLOUDS'])
      #.style('stroke', ZVG.flatUIColors['SILVER'])
      #.style('stroke-width', '1px')
      # .style('fill', 'url(#standardBackgroundGradient)')
      #.style('fill', ZVG.flatUIColors['MIDNIGHT BLUE'])
      .attr('height', height)
      .attr('width', width)
      .attr('rx', radius)
      .attr('ry', radius)




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

class ZVG.BasicChart
  width: 900
  height: 500

  accessor: (name, d) ->
    if d
      @["_#{name}"] = d
      return @
    @["_#{name}"]

  constructor: (element = 'body') ->
    @element = element
    @initializeSvg(element)
    @initializeStylesheet()
    @_n_threshold = 0

  data: (d) ->
    if d
      @raw_data = d
      _series_2_raw_domain = {}
      (_series_2_raw_domain[e.series_2] = 1) for e in @raw_data
      @_series_2_raw_domain = (key for key, _ of _series_2_raw_domain)
      @_data = @nestData(d)
      return @
    @_data

  nestData: (d) ->
    d3.nest()
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .key((z) -> z.series_2).sortKeys(@seriesSortFunction(@series_2_domain()))
      .entries(d)

  seriesSortFunction: (priority_seed) ->
    priority_seed or= []
    (a,b) ->
      priority_seed.indexOf(a) - priority_seed.indexOf(b)

  series_1_domain: (d) ->
    @accessor('series_1_domain', d)

  series_2_domain: (d) ->
    @accessor('series_2_domain', d)

  series_3_domain: (d) ->
    @accessor('series_3_domain', d)

  legend_labels: (d) ->
    @accessor('legend_labels', d)

  initializeSvg: (element = 'body') ->
    @outer = d3.select(@element).append('div').attr('class', 'zvg')
    @container = @outer.append('div').attr('class', 'zvg-container')
    @chart     = @container.append('div').attr('class', 'zvg-chart')
    @svg = @chart.append('svg')
      .attr('height', @height + 200).attr('width', @width + 200)
    @renderBackgroundRectangle()
    @background = (new ZVG.Background(@svg, @height, @width, 0)).background

  initializeStylesheet: ->
    @svg.append('style').text(ZVG.stylesheet)

  # a white cover that backgrounds everything (distinct from gray background rectangle)
  renderBackgroundRectangle: ->
    @_background_rectangle or= @svg.append('rect').style('fill', 'white').style('stroke','none')
    @_background_rectangle.attr('width', @width + 200 + @legend_width).attr('height', @height + 200)

  render_legend: ->
    null

  render: (args...) ->
    @beforeRender()
    @_render(args...)
    @afterRender()

  beforeRender: ->
    @_hide_columns_below_n(@_n_threshold)

  _render: -> null
  afterRender: ->
    @_adjust_svg_dimensions()

  _adjust_svg_dimensions: ->
    bbox = @svg[0][0].getBBox()
    @svg.attr('width', bbox.width)
    @svg.attr('height', bbox.height)

  legend_width: 0

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
    @width = width
    @svg.attr('width', @width + @legend_width)
    @background.attr('width', @width)
    @renderBackgroundRectangle()
    @set_legend_x()
    @set_series_1_spacing()

  legend_width: 400

  # x offset for point chart scale on left
  x_offset: 0

  filter_data: (filters) ->
    if filters
      @_filters = filters
      # prevent @raw_data from being overwritten
      @_data = @nestData(x for x in @raw_data when x.series_2 in filters)
    else
      @data(@raw_data)

  _hide_columns_below_n: (n) ->
    n_value = @series_2_label_sum
    select_columns_above = (n, data) ->
      { key: data.key, values: data.values.filter((v) -> n_value(v) >= n) }
    @_data = (d for d in (select_columns_above(n, d) for d in @_data) when d.values.length > 0)

  # pre-establishes indexes for the spacing and grouping of series 1 data
  # based on its contents (necessary because of the variable length of data within
  # the series, otherwise simple rangebands could be used)
  #
  set_series_1_spacing: ->
    @series_1_width      = []
    @series_1_x          = []
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
        current_x += w
    @column_band = d3.scale.ordinal()
      .domain([0...maxCount])
      .rangeRoundBands([0, @column_spacing * maxCount], 0.1)
    @widen_chart((@width - @x_offset) + 100) if @column_band.rangeBand() < @minimum_column_width

  render_series_1: ->
    @series_1 = @svg.selectAll('.series1').data(@_data)
    @series_1.enter().append('g').attr('class', 'series1')
    @series_1.attr('transform', (d,i) => "translate(#{@series_1_x[i]}, 0)")
    @series_1.exit().remove()

  sortedS3Domain: ->
    @series_3_domain().sort((x, y) -> x > y)

  legend_data: ->
    # TODO: FIXME
    try
      #This version pulls the present values out
      ({ key: x, text: (@legend_labels()[x] or "_value_#{x}")} for x in @sortedS3Domain()).reverse()

      # This one uses all legend labels, whether they are represented by the data or not.
      # ({ key: key, text: text } for key, text of @legend_labels()).reverse()
    catch e
      console.info(e)
      []


  render_legend: ->
    @initialize_legend()
    @legend.selectAll('g.legend_item').remove()
    items = @legend.selectAll('g.legend_item')
      .data(@legend_data())
    items.enter()
      .append('g')
      .attr('class', "legend_item #{@value_group_selector.substr(1,100)}")
      .attr('label', (d) -> d.key)

    @apply_legend_elements(items)
    @renderFilterLegend()

  legend_item_height: 21

  apply_legend_elements: (selection) ->
    height = @legend_item_height
    c      = @color
    color  = (d) -> c(d.key)

    @_apply_legend_elements(selection, height, (d) -> new ZVG.SquarePoint(this, color))

  # The generic function. Feed chart-specific args in the main @apply_legend_elements function above.
  _apply_legend_elements: (selection, height, each_function) ->
    selection.attr('transform', (_, i) -> "translate(0, #{i * height})")
      .append('rect').attr('width', @legend_width).attr('height', height).style('fill', 'white').style('stroke', 'none')
    selection.append('g')
      .attr('class', 'legend-icon')
      .attr("transform", "translate(10, #{height/2})")
      .each(each_function)
      .append('text').attr('class', 'legend_text')
      .text((d) -> d.text)
      .attr('transform', "translate(10, 3)")
      .attr('alignment-baseline', 'middle')

  # FIXME
  renderFilterLegend: =>
    @_checked or= {}
    h = @legend_item_height
    d = (e for e in @series_2_domain() when e in (@_series_2_raw_domain or [])).reverse()
    ((@_checked[e] or= true) unless @_checked[e] is false) for e in d
    return if d.length is 1
    @legend.selectAll('g.filter_legend_item').remove()
    offset = (@legend.selectAll('.legend-icon')[0].length + 2) * @legend_item_height

    items = @legend.selectAll('g.filter_legend_item')
      .data(d)
    items.enter()
      .append('g')
      .attr('class', 'filter_legend_item legend_item')
      .attr('label', (d) -> d)
      .attr('transform', (d, i) -> "translate(10, #{offset + (i * h)})")

    filter_checkboxes = items.append('rect')
      .attr('height', 8).attr('width', 8)
      .style('fill', (d) => if @_checked[d] then ZVG.flatUIColors["CARROT"] else ZVG.flatUIColors["CLOUDS"])
      .attr('checked',(d) =>
        if @_filters
          d in @_filters or null
        else
          true
      )

    items.on('click', (d,i) =>
      if @_checked[d]
        @_checked[d] = false
      else
        @_checked[d] = true
      @filter_data((key for key, condition of @_checked when condition))
      @render()
    )

    items.append('text').attr('class', 'legend_text')
      .text((d) -> d)
      .style('alignment-baseline', 'middle')
      .attr('transform', "translate(12, 5)")


  #initialize_legend: ->
  #@legend or= @container.append('div').attr('class', 'legend zvg-chart')
  #.style('width', '200px')
  #
  initialize_legend: ->
    @legend or= @svg.append('g')

    # TEMP
    @legend.selectAll('rect.test').data([1]).enter()
      .append('rect')
      .attr('width', @legend_width)
      .attr('height', @height)
      .style('stroke', 'none')
      .style('fill', 'none')
    #

    @set_legend_x()

  set_legend_x: ->
    if @legend
      @legend.attr('transform', "translate(#{@width},0)")




  bind_value_group_click: ->
    vg = @container.selectAll(@value_group_selector)
    vg.on('click', (d) =>
      if @freeze && @freeze == d.key
        @freeze = null
        @undim_all_values()
      else
        @freeze = d.key
        @undim_all_values()
        @dim_values_not_matching(d.key)
    )

  bind_value_group_hover: ->
    vg = @container.selectAll(@value_group_selector)
    vg.on('mouseover', (d) =>
      @dim_values_not_matching(d.key) unless @freeze
    ).on('mouseout', => @undim_all_values() unless @freeze)

  undim_all_values: =>
    @container.selectAll(@value_group_selector).style('opacity', 1)

  dim_values_not_matching: (key) =>
    @container.selectAll(@value_group_selector).filter((e) -> "#{e.key}" isnt "#{key}")
      .style('opacity', 0.1)

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
        #"#{@series_2_label_visibility(d.key)} (n = #{sum})"
        (x for x in [@series_2_label_visibility(d.key), "(n = #{sum})"] when x).join(" ")
      )

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

