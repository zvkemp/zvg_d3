window.ZVG = {
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

ZVG.backgroundColor = ZVG.flatUIColors['CLOUDS']

class ZVG.Background
  constructor: (svg, height, width, radius = 5) ->

    # ZVG.BackgroundGradient(svg)
    backgroundGroup = svg.append('g')
    @background = backgroundGroup.append('rect')
      .style('fill', ZVG.backgroundColor)
      .attr('height', height)
      .attr('width', width)
      .attr('rx', radius)
      .attr('ry', radius)




class ZVG.PointShape
  constructor: (container, fill, attrs, scale = 1) ->
    @scale       = scale
    @container   = container
    @fill        = fill
    @attrs       = @defaults()
    attrs or= {}
    @attrs[key] = value for key, value of attrs
    @render()

  defaults: -> { x: 0, y: 0, r: 8 }

  render: ->
    @apply_standard_attributes(@render_object())

  apply_standard_attributes: (obj) ->
    obj.attr('class', 'zvg-point-shape')
      .style('fill', @fill)

  render_object: ->
    d3.select(@container).append('circle')
      .attr('cx', @attrs.x * 2)
      .attr('cy', @attrs.y * 2)
      .attr('r', @attrs.r * @scale)

class ZVG.SquarePoint extends ZVG.PointShape
  defaults: -> { x: -7, y: -7, width: 14, height: 14 }

  render_object: ->
    d3.select(@container).append('rect')
        .attr('x', @attrs.x * @scale)
        .attr('y', @attrs.y * @scale)
        .attr('width', @attrs.width * @scale)
        .attr('height', @attrs.height * @scale)

class ZVG.DiamondPoint extends ZVG.SquarePoint
  defaults: -> { x: -6.5, y: -6.5, width: 13, height: 13 }

  render_object: ->
    super().attr('transform', "rotate(45, #{@attrs.width / 2 + @attrs.x}, #{@attrs.height / 2 + @attrs.y})")

class ZVG.CirclePoint extends ZVG.PointShape

class ZVG.TrianglePoint extends ZVG.PointShape
  defaults: -> { center: true, size: 15 }

  m: -> @attrs.size / 2

  path: ->
    m = @m() * @scale
    if @attrs.center
      "M 0 #{-m} L #{m} #{m} L #{-m} #{m} z"
    else
      # This is still slightly off (for legends), but is OK.
      "M #{2*m} 0 L #{3 * m} #{2 * m} L #{m} #{2 * m} z"

  render_object: ->
    m = @m() * @scale
    s = @scale
    d3.select(@container).append('path')
      .attr('d', @path())

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
    @_n_threshold = 0

  default_warning_color: ZVG.flatUIColors['ALIZARIN']

  n_threshold_color: (normal, warning) =>
    (value) =>
      if value.n >= @_n_threshold
        normal
      else
        warning or @default_warning_color

  data: (d) ->
    if d
      @raw_data or= d
      unless @_series_2_raw_domain
        _series_2_raw_domain = {}
        (_series_2_raw_domain[e.series_2] = 1) for e in d
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

  legend_width: 0

  initializeSvg: (element = 'body') ->
    @outer = d3.select(@element).append('div').attr('class', 'zvg')
    @container = @outer.append('div').attr('class', 'zvg-container')
    @chart     = @container.append('div').attr('class', 'zvg-chart')
    @svg = @chart.append('svg')
      .attr('height', @height).attr('width', @width)
    @renderBackgroundRectangle()
    @background = (new ZVG.Background(@svg, @height, @width, 0)).background

  # a white cover that backgrounds everything (distinct from gray background rectangle)
  renderBackgroundRectangle: ->
    @_background_rectangle or= @svg.append('rect').style('fill', 'white').style('stroke','none')
    @_background_rectangle.attr('width', @width + @legend_width).attr('height', @height)

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

  initialize_legend: ->
    @legend or= @svg.append('g')
    @set_legend_x()

  set_legend_x: ->
    if @legend
      @legend.attr('transform', "translate(#{@width},0)")

  legend_item_height: 21

  apply_legend_elements: (selection) ->
    height = @legend_item_height
    c      = @color or @colors
    color  = (d) -> c(d.key)

    @_apply_legend_elements(selection, height, (d) ->
      new ZVG.SquarePoint(@, color, { x: 7, y: 5 })

      d3.select(@).append('text').attr('class', 'legend_text')
        .text((d) -> d.text)
        .attr('x', 25)
        .attr('y', (height / 2) + 5)
    )

  # The generic function. Feed chart-specific args in the main @apply_legend_elements function above.
  _apply_legend_elements: (selection, height, each_function) ->
    selection.attr('transform', (_, i) -> "translate(0, #{i * height})")
    backgroundRects = selection
      .append('rect')
      .attr('width', 0)
      .attr('height', height)
      .style('fill', 'white')
      .style('stroke', 'none')
    selection.each(each_function) # apply the square thingy
    maxLegendItemWidth = @legend_width

    for e in selection[0]
      do (e) ->
        maxLegendItemWidth = Math.max(maxLegendItemWidth, e.getBBox().width)

    legend_width_was = @legend_width
    @legend_width = maxLegendItemWidth
    backgroundRects.attr('width', @legend_width)
    @widen_chart() if legend_width_was < @legend_width

  widen_chart: (width) ->
    @width = width or @width
    @svg.attr('width', @width + @legend_width)
    @background.attr('width', @width)
    @renderBackgroundRectangle()
    @set_legend_x()

  render: (args...) ->
    @beforeRender()
    @_render(args...)
    @afterRender()

  beforeRender: ->
    @_hide_columns_below_n(@_n_threshold) unless @_show_unstable_data

  show_unstable_data: (b) ->
    @_show_unstable_data = b
    @filter_data(@_filters)
    @render()

  _render: -> null
  afterRender: ->
    @renderUnstableLegend()
    @_adjust_svg_dimensions()

  _adjust_svg_dimensions: ->
    bbox = @svg[0][0].getBBox()
    @svg.attr('width', bbox.width)
    @svg.attr('height', bbox.height)

  legend_width: 0

  _hide_columns_below_n: () ->
  renderUnstableLegend: () ->

  _nValueFloatFormatter = d3.format('.1f')

  nValueFormatter: (val) ->
    if Number.isInteger(val)
      "(n = #{val})"
    else
      "(n = #{_nValueFloatFormatter(val)})"

  bind_value_group_click: ->
    vg = @container.selectAll(@value_group_selector)
    vg.on('click', @_value_group_click)

  _value_group_click: (d) =>
    if @freeze && @freeze == d.key
      @freeze = null
      @undim_all_values()
    else
      @freeze = d.key
      @undim_all_values()
      @dim_values_not_matching(d.key)


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

  # FIXME
  renderFilterLegend: =>
    @_checked or= {}
    h = @legend_item_height
    d = (e for e in @series_2_domain() when e in (@_series_2_raw_domain or [])).reverse()
    ((@_checked[e] or= true) unless @_checked[e] is false) for e in d
    return if d.length is 1
    @legend.selectAll('g.filter_legend_item').remove()
    offset = (@legend.selectAll('text')[0].length + 3) * @legend_item_height

    items = @legend.selectAll('g.filter_legend_item').data(d)
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

    # Select ONLY this filter when the little orange square is clicked
    filter_checkboxes.on('click', (f) =>
      if @_onlyChecked is f
        @_onlyChecked = null
        @_filters = null
        (@_checked[e] = true) for e in d
        @filter_data()
      else
        (@_checked[e] = false) for e in d
        @_checked[f] = true
        @_onlyChecked = f
        @filter_data([f])
      @render())

    text = items.append('text').attr('class', 'filter_legend_text')
      .text((d) -> d)
      # .style('alignment-baseline', 'middle')
      .attr('transform', "translate(12, 7)")

     # Toggle the filter when the text is clicked
    text.on('click', (d,i) =>
      @_onlyChecked = null
      if @_checked[d]
        @_checked[d] = false
      else
        @_checked[d] = true
      @filter_data((key for key, condition of @_checked when condition))
      @render()
    )

  filter_data: (filters) ->
    if filters
      @_filters = filters
      # prevent @raw_data from being overwritten
      @_data = @nestData(x for x in @raw_data when x.series_2 in filters)
    else
      @data(@raw_data)
