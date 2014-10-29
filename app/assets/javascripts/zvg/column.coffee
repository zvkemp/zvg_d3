class ZVG.Column extends ZVG.ColumnarLayoutChart
  # Data structure:
  # Raw dataset is array of series_1,series_2,series_3 key pairs:
  # {
  #   series_1: ... (survey or filter 1)
  #   series_2: ... (filter 1 or filter 2)
  #   series_3: ... (numeric value of datapoint)
  #   value: ...    (raw value, percentage not precalculated).
  # }
  # Auxilliary data (not yet implemented): 
  # defined order to series_1, series_2, series_3 domains
  #
  #


  # rotate labels, or stagger?
  # line breaks in s1 labels?
  #

  randomizeData: (s1count, s2count, s3count) ->
    @_filters = null
    @undim_all_values()
    randomness = ->
      i = parseInt(Math.random() * 25)
      'Hello This is Extra Text'.substr(0, i)
    s1count or= parseInt(Math.random() * 10 + 1)
    s2count or= parseInt(Math.random() * 6 + 1)
    s3count or= parseInt(Math.random() * 8 + 2)

    s1d = ("Survey#{randomness()}#{n}" for n in [1..s1count])

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
                  value: parseInt(Math.random() * 150)
                }
    @series_1_domain("Survey#{randomness()}#{n}" for n in [1..s1count])
    @series_2_domain("Filter #{n}" for n in [1..s2count])
    @series_3_domain("#{n}" for n in [1..s3count])
    @data(raw)
    @render(@renderMode)
  
  nestData: (d) ->
    d3.nest()
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .key((z) -> z.series_2).sortKeys(@seriesSortFunction(@series_2_domain()))
      .key((z) -> z.series_3).sortKeys(@seriesSortFunction(@series_3_domain()))
      .entries(d)

  color: d3.scale.ordinal().range(ZVG.colorSchemes.warmCool10)
  setColor: (array) ->
    @color = d3.scale.ordinal().range(array)


  # the only one that matters.
  # Runs the necessary functions in order to render the chart.
  render: (renderMode = 'percentage') ->
    @renderMode = renderMode
    @reset_width()
    @set_series_1_spacing()
    @renderSeries1()
    @build_series_domains()
    @renderSeries2()
    @render_series_1_labels()
    @render_series_2_labels()
    @initializeY()
    @initialize_labels()
    @renderSeries3()
    @renderSeries3Labels()
    @render_legend()
    @bind_value_group_hover()
    @bind_value_group_click()

  minimum_column_width: 20
  
  # appends a <g> element and places it along the x axis for each member of series 1
  renderSeries1: ->
    @series_1 = @svg.selectAll('.series1').data(@_data, @key_function)
    @series_1.enter().append('g').attr('class', 'series1').attr('transform', 'translate(0,0)')
    @series_1.transition().duration(500).attr('transform', (d,i) => "translate(#{@series_1_x[i]}, 0)")
    @series_1.exit().remove()


  # builds domains for individual columns (series_1/series_2 pairs).
  # @renderMode must be set.
  build_series_domains: -> @["build_series_domains_#{@renderMode}"]()
  #
  # To render as a 100% stacked column chart
  build_series_domains_percentage: =>
    return @build_series_domains_percentage_with_n_overrides() if @_custom_n_values
    @series3Domains = {}
    for s1 in @_data
      do (s1) =>
        @series3Domains[s1.key] = {}
        for s2 in s1.values
          do (s2) =>
            s3 = (d.values[0].value for d in s2.values)
            @series3Domains[s1.key][s2.key] = d3.scale.linear()
              .domain([0, d3.sum(s3)])
              .range([0, @height])
  #
  # Finds the maximum n value of all columns in series 2.
  # Scales on sum of percentages of given n value.
  # Used for 'select all that apply' type data.
  build_series_domains_percentage_with_n_overrides: =>
    maxSum = 0
    for s1 in @_data
      do (s1) =>
        for s2 in s1.values
          do (s2) =>
            n = @n_values[s1.key][s2.key]
            s3 = d3.sum(d.values[0].value/n for d in s2.values)
            maxSum = s3 if s3 > maxSum
    maxScale = d3.scale.linear()
      .range([0, @height])
      .domain([0, maxSum])
    @series3Domains = {}
    for s1 in @_data
      do (s1) =>
        @series3Domains[s1.key] = {}
        for s2 in s1.values
          do (s2) =>
            @series3Domains[s1.key][s2.key] = maxScale
  #
  # Finds the maximum sum of all columns in series 2
  # and scales it to the maximum height. All other columns
  # are scaled relatively.
  build_series_domains_count: =>
    maxSum = 0
    for s1 in @_data
      do (s1) =>
        for s2 in s1.values
          do (s2) =>
            s3 = d3.sum(d.values[0].value for d in s2.values)
            maxSum = s3 if s3 > maxSum
    maxScale = d3.scale.linear()
      .range([0, @height])
      .domain([0, maxSum])
    @series3Domains = {}
    for s1 in @_data
      do (s1) =>
        @series3Domains[s1.key] = {}
        for s2 in s1.values
          do (s2) =>
            @series3Domains[s1.key][s2.key] = maxScale


  # Sets up <g> elements for each series_2 group within
  # each series_1 group. Places along x axis (relative to
  # parent series_1 group).
  renderSeries2: ->
    # key function ensures proper transitions - data bound to specific series 2 groups
    @series_2 = @series_1.selectAll('.series2').data(@values_function, @key_function)
    @series_2.enter()
      .append('g')
      .attr('class', 'column series2')
      .attr('transform', "translate(0,0)")
    @series_2.attr('label', (d) -> d.key).transition().duration(500)
      .attr('transform', (d,i) => "translate(#{@column_band(i)}, 0)")
      .attr('opacity', (d) =>
        if @series_2_label_sum(d) < @_n_threshold then 0.3 else 1.0
      )
    @series_2.exit()
      .transition().duration(500)
      .attr('transform',(d,i) => "translate(#{@column_band(1)},-1000)")
      .remove()

  # 
  renderSeries3: ->
    @series_3 = @series_2.selectAll('rect.vg')
      .data((d) -> d.values)
    @series_3.enter()
      .append("rect")
      .attr("class", 'vg')
      .attr('x', 0)
      .attr('y', @height)
      .attr('height', 0)
    current_y = @height
    @series_3.style('fill', (d) => @color(d.key))
      .attr('width', @column_band.rangeBand())
      .transition().delay(200).duration(500)
      .attr('y', (d,i) =>
        current_y = @height if i is 0
        h = @valueHeightFunction(d)
        current_y -= h
        current_y
      ).attr('class', (d,i) => "vg")
      .attr('height', @valueHeightFunction)
    @series_3.exit().remove()

  value_group_selector: ".vg" # for hovers

  valueHeightFunction: (d) =>
    dp = d.values[0]
    if @_custom_n_values and @renderMode is "percentage"
      n = @n_values[dp.series_1][dp.series_2]
      v = dp.value/n
    else
      v = dp.value
    @series3Domains[dp.series_1][dp.series_2](v)

  valueFunction_percentage: (d) =>
    dp = d.values[0]
    if @_custom_n_values
      n = @n_values[dp.series_1][dp.series_2]
    else
      n = @series3Domains[dp.series_1][dp.series_2].domain()[1]
    @percentFormat dp.value/n

  valueFunction_count: (d) =>
    d.values[0].value

  valueFunction_percentage_with_n_overrides: (d) =>
    dp = d.values[0]
    n = @n_values[dp.series_1][dp.series_2]
    @percentFormat dp.value/n

  valueFunction: ->
    @["valueFunction_#{@renderMode}"]

  renderSeries3Labels: (textFunction = @valueFunction()) ->
    @series_2.selectAll('text.vg').remove()
    @series_3_labels = @series_2.selectAll('text.vg')
      .data((d) -> d.values)
    current_y = @height
    @series_3_labels.enter()
      .append('text')
      .attr('class', 'vg column-label')
      .attr('x', @column_band.rangeBand()/2)
      .attr('y', (d,i) =>
        current_y = @height if i is 0
        h = @valueHeightFunction(d)
        current_y -= h
        current_y + h/2
      ).attr('opacity', 0)
      .transition().delay(300).attr('opacity', 1)
    computeFontSize = @computeFontSize
    valueHeightFunction = @valueHeightFunction
    @series_3_labels.text(textFunction)
    @series_3_labels.style('font-size', (d) ->
      computeFontSize(this, valueHeightFunction(d))
    )

  computeFontSize: (node, maxHeight) =>
    "#{d3.min([10, @column_band.rangeBand()/3, maxHeight])}pt"

  appendSeries2Borders: ->
    @borders = @series_2.selectAll('.border')
      .data((d) -> d.key)
    @borders.enter()
      .append('rect')
      .attr('class', 'border')
    @borders.style('stroke', 'white')
      .style('stroke-width', '1pt')
      .style('fill', 'none')
      .attr('x', 0)
      .attr('y', @height)
      .attr('height', 0)
      .attr('width', @column_band.rangeBand())
      .attr('opacity', 0)
      .transition().delay(300).duration(700)
      .attr('y', 0)
      .attr('height', @height)
      .attr('opacity', 1)

  percentScale: d3.scale.linear().range([0,1])
  percentFormat: d3.format('.0%')
  countFormat: d3.format('.0')

  initializeY: ->
    @y = d3.scale.linear().range([0, @height])
    @current_y = 0

  sample_data: [
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 2, value: 100 }
    { series_1: 'Survey 1', series_2: 'Filter 1', series_3: 1, value: 200 }
    { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 1, value: 200 }
    { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 2, value: 300 }
    { series_1: 'Survey 1', series_2: 'Filter 4', series_3: 1, value: 100 }
    { series_1: 'Survey 1', series_2: 'Filter 4', series_3: 2, value: 400 }
    { series_1: 'Survey 2', series_2: 'Filter 1', series_3: 1, value: 100 }
    { series_1: 'Survey 2', series_2: 'Filter 1', series_3: 2, value: 200 }
    { series_1: 'Survey 2', series_2: 'Filter 3', series_3: 1, value: 200 }
    { series_1: 'Survey 2', series_2: 'Filter 3', series_3: 2, value: 300 }
    { series_1: 'Survey 3', series_2: 'Filter 3', series_3: 1, value: 100 }
    { series_1: 'Survey 3', series_2: 'Filter 3', series_3: 2, value: 200 }
    { series_1: 'Survey 3', series_2: 'Filter 2', series_3: 1, value: 200 }
    { series_1: 'Survey 3', series_2: 'Filter 2', series_3: 2, value: 300 }
  ]

  override_n_values: (values) ->
    @_custom_n_values = true
    @n_values = values
