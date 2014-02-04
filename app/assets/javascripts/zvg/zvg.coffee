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
class ZVG.Background
  constructor: (svg, height, width, radius = 5) ->

    # ZVG.BackgroundGradient(svg)
    backgroundGroup = svg.append('g')
    @background = backgroundGroup.append('rect')
      .style('fill', ZVG.flatUIColors['CLOUDS'])
      #.style('stroke', ZVG.flatUIColors['SILVER'])
      #.style('stroke-width', '1px')
      # .style('fill', 'url(#standardBackgroundGradient)')
      #.style('fill', ZVG.flatUIColors['MIDNIGHT BLUE'])
      .attr('height', height)
      .attr('width', width)
      .attr('rx', radius)
      .attr('ry', radius)


class ZVG.BasicChart
  width: 900
  height: 500

  constructor: (element) ->
    @element = element
    @initializeSvg(element)

  data: (d) ->
    if d
      @raw_data = d
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
    if d
      @_series_1_domain = d
      return @
    @_series_1_domain

  series_2_domain: (d) ->
    if d
      @_series_2_domain = d
      return @
    @_series_2_domain

  series_3_domain: (d) ->
    if d
      @_series_3_domain = d
      return @
    @_series_3_domain


  initializeSvg: (element = 'body') ->
    @outer = d3.select(element).append('div').attr('class', 'zvg')
    @container = @outer.append('div').attr('class', 'zvg-container')
    @chart     = @container.append('div').attr('class', 'zvg-chart')
    @svg = @chart.append('svg')
      .attr('height', @height + 200).attr('width', @width + 200)
    @background = (new ZVG.Background(@svg, @height, @width, 0)).background

  render_legend: ->
    null

class ZVG.ColumnarLayoutChart extends ZVG.BasicChart
  constructor: (element, options = {}) ->
    super(element)
    @_options = options
    @initialize_series_1_label_container()

  initialize_series_1_label_container: -> @series_1_label_container = @svg.append('g')

  # used to re-narrow chart in case new data is smaller than current
  reset_width: ->
    @widen_chart ZVG.BasicChart.prototype.width

  # ensure a minimum viable width of individual columns
  widen_chart: (width) ->
    @width = width
    @svg.attr('width', @width)
    @background.attr('width', @width)
    @set_series_1_spacing()

  # x offset for point chart scale on left
  x_offset: 0

   
  filter_data: (filters) ->
    if filters
      @_filters = filters
      # prevent @raw_data from being overwritten
      @_data = @nestData(x for x in @raw_data when x.series_2 in filters)
    else
      @data(@raw_data)


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

  legend_data: ->
    ({ key: x, text: "Label for #{x}" } for x in @series_3_domain().slice(0).reverse())


  render_legend: ->
    @initializeLegend()
    @legend.selectAll('div.legend_item').remove()
    items = @legend.selectAll('div.legend_item')
      .data(@legend_data())
    items.enter()
      .append('div')
      .attr('class', "legend_item #{@value_group_selector.substr(1,100)}")
      .attr('label', (d) -> d.key)

    @apply_legend_elements(items)
    @renderFilterLegend()

  apply_legend_elements: (selection) ->
    selection.append('div')
      .attr('class', 'legend-icon')
      .style('background-color', (d) => @color(d.key))
      .style('width', '15px')
      .style('height', '15px')
      .style('padding', '1px')
      .style('float', 'left')
      .style('margin-right', '5px')
    selection.append('span').attr('class','legend_text')
      .text((d) -> d.text)


  renderFilterLegend: =>
    @legend.selectAll('div.filter_legend_item').remove()

    items = @legend.selectAll('div.filter_legend_item')
      .data(@series_2_domain().slice(0).reverse())
    items.enter()
      .append('div')
      .attr('class', 'filter_legend_item')
      .attr('label', (d) -> d)

    filter_checkboxes = items.append('input')
      .attr('type', 'checkbox')
      .attr('checked',(d) =>
        if @_filters
          d in @_filters or null
        else
          true
      )

    filter_checkboxes.on('change', (d,i) =>
      @filter_data(@container.selectAll('input:checked').data())
      @render()

    )
    items.append('span').attr('class', 'legend_text')
      .text((d) -> d)


  initializeLegend: ->
    @legend or= @container.append('div').attr('class', 'legend zvg-chart')
      .style('width', '200px')

  
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
    @container.selectAll(@value_group_selector).filter((e) -> e.key != key)
      .style('opacity', 0.1)
