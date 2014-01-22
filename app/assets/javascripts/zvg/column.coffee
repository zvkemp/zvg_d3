class ZVG.Column extends ZVG.BasicChart
  # Data structure:
  # Raw dataset is array of series_1,series_2,series_3 key pairs:
  # {
  #   series_1: ... (survey or filter 1)
  #   series_2: ... (filter 1 or filter 2)
  #   series_3: ... (numeric value of datapoint)
  #   value: ...    (raw value, percentage not precalculated).
  # }
  # Auxilliary data (not yet implemented): 
  # n-values
  # defined order to series_1, series_2, series_3 domains
  # legend labels for series_3
  #

  randomizeData: (s1count, s2count, s3count) ->
    @undimAllValues()
    s1count or= parseInt(Math.random() * 10 + 1)
    s2count or= parseInt(Math.random() * 6 + 1)
    s3count or= parseInt(Math.random() * 8 + 2)

    raw = []
    for s in ([1..s1count])
      do (s) ->
        s2actual = parseInt(Math.random() * s2count) + 1
        for f in ([1..s2actual])
          do (f) ->
            for d in ([1..s3count])
              do (d) ->
                raw.push {
                  series_1: "Survey #{s}"
                  series_2: "Filter #{f}"
                  series_3: d
                  value: parseInt(Math.random() * 150)
                }
    @series_1_domain("Survey #{n}" for n in [1..s1count])
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

  # used to re-narrow the chart in case new data is smaller than current data.
  resetWidth: ->
    @widenChart ZVG.BasicChart.prototype.width

  render: (renderMode = 'percentage') ->
    @renderMode = renderMode
    @resetWidth()
    @setSeries1Spacing()
    @renderSeries1()
    @buildSeriesDomains()
    @renderSeries2()
    @appendSeries1Labels()
    @appendSeries2Labels()
    @initializeY()
    @initializeLabels()
    #@appendSeries2Borders()
    @renderSeries3()
    @renderSeries3Labels()
    @renderLegend()
    @bindValueGroupHover()
    @bindValueGroupClick()

  # pre-establishes indexes for the spacing and grouping of series 1 data
  # based on its contents (necessary because of the variable length of data within
  # the series, otherwise simple rangebands could be used)
  setSeries1Spacing: ->
    @series1width      = []
    @series1x          = []
    scale              = d3.scale.ordinal().domain(d.series_1 for d in @raw_data)
    ranges             = {}
    totalColumnCount   = 0
    totalColumnCount  += d.values.length for d in @_data
    @columnSpacing     = @width/(totalColumnCount + @_data.length)
    @columnPadding     = 0.1 * @columnSpacing
    @seriesPadding     = @columnSpacing / 2
    current_x          = 0
    maxCount           = d3.max(@_data, (d) -> d.values.length)
    for d,i in @_data
      do (d,i) =>
        w = @columnSpacing * (d.values.length + 1)
        @series1width[i] = w - @seriesPadding * 2
        @series1x[i] = current_x + @seriesPadding
        current_x += w
    @columnBand = d3.scale.ordinal()
      .domain([0...maxCount])
      .rangeRoundBands([0, @columnSpacing * maxCount], 0.1)
    @widenChart(@width + 100) if @columnBand.rangeBand() < 20
  
  # used to ensure a minimum viable width of individual columns.
  widenChart: (width) ->
    @width = width
    @svg.attr('width', @width)
    @background.attr('width', @width)
    @setSeries1Spacing()

  series1TotalWidth: -> @width / @_data.length

  renderSeries1: ->
    @series_1 = @svg.selectAll('.series1')
      .data(@_data)
    @series_1.enter()
      .append('g')
      .attr('class', 'series1')
    @series_1.transition().duration(500).attr('transform', (d,i) => "translate(#{@series1x[i]}, 0)")
    @series_1.exit().remove()

  buildSeriesDomains: ->
    @["buildSeriesDomains_#{@renderMode}"]()

  buildSeriesDomains_percentage: =>
    return @buildSeriesDomains_percentage_with_n_overrides() if @_custom_n_values
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

  buildSeriesDomains_percentage_with_n_overrides: =>
    maxSum = 0
    for s1 in @_data
      do (s1) =>
        for s2 in s1.values
          do (s2) =>
            n = @n_values[s1.key][s2.key]
            s3 = d3.sum(d.values[0].value/n for d in s2.values)
            maxSum = s3 if s3 > maxSum
    console.log(maxSum)
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



  buildSeriesDomains_count: =>
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
  
  renderSeries2: ->
    @series_2 = @series_1.selectAll('.series2')
      .data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'column series2')
      .attr('transform', "translate(0,0)")
    @series_2.attr('label', (d) -> d.key).transition().duration(500)
      .attr('transform', (d,i) => "translate(#{@columnBand(i)}, 0)")
    @series_2.exit()
      .transition().duration(500)
      .attr('transform', "translate(0,-1000)")
      .remove()


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
      .attr('width', @columnBand.rangeBand())
      .transition().delay(200).duration(500)
      .attr('y', (d,i) =>
        current_y = @height if i is 0
        h = @valueHeightFunction(d)
        current_y -= h
        current_y
      ).attr('class', (d,i) => "vg")
      .attr('height', @valueHeightFunction)
    @series_3.exit().remove()

  bindValueGroupHover: ->
    vg = @container.selectAll('.vg')
    vg.on('mouseover', (d) =>
      @dimValuesNotMatching(d.key) unless @freeze
    ).on('mouseout', => @undimAllValues() unless @freeze)

  bindValueGroupClick: ->
    vg = @container.selectAll('.vg')
    vg.on('click', (d) =>
      if @freeze && @freeze == d.key
        @freeze = null # unfreeze if clicked again
        @undimAllValues()
      else
        @freeze = d.key
        @undimAllValues()
        @dimValuesNotMatching(d.key)
    )

  # set opacity to 10% unless key property matches arg.
  # Used for hover and click events.
  dimValuesNotMatching: (key) =>
    @container.selectAll('.vg').filter((e) -> e.key != key)
      .style('opacity', 0.1)

  undimAllValues: =>
    @container.selectAll('.vg').style('opacity', 1)

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
      .attr('x', @columnBand.rangeBand()/2)
      .attr('y', (d,i) =>
        current_y = @height if i is 0
        h = @valueHeightFunction(d)
        current_y -= h
        current_y + h/2
      ).attr('opacity', 0)
      .transition().delay(500).attr('opacity', 1)
    computeFontSize = @computeFontSize
    valueHeightFunction = @valueHeightFunction
    @series_3_labels.text(textFunction)
    @series_3_labels.style('font-size', (d) ->
      # is there a better way to do this? need class bindings as well as local `this`
      computeFontSize(this, valueHeightFunction(d))
    )

  computeFontSize: (node, maxHeight) =>
    "#{d3.min([10, @columnBand.rangeBand()/3, maxHeight])}pt"

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
      .attr('width', @columnBand.rangeBand())
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

  initializeLabels: ->
    @labels = d3.scale.linear().range([0, 1])
    @percent = d3.format('.0%')

  appendSeries1Labels: ->
    @series_1_labels = @svg.selectAll('text.series1label')
      .data(@_data)
    @series_1_labels.enter()
      .append('text')
      .attr('class', 'series1label')
    @series_1_labels.attr('y', @height + 30)
      .text((d) -> d.key)
      .attr('x', (d,i) => @series1x[i] + @series1width[i]/2)
    @series_1_labels.exit().remove()

  appendSeries2Labels: ->
    @svg.selectAll('.series2label').remove()
    series_2_labels = @series_1.selectAll('text.series2label')
      .data((d) -> d.values)
    series_2_labels.enter()
      .append('text')
      .attr('class', 'series2label')
    series_2_labels.attr('y', @height + 10)
      .attr('x', (d,i) => @columnBand(i) + @columnBand.rangeBand()/2)
      .text((d) -> d.key)

    series_2_labels.on('click', (d,i) =>
      @filterData(d.key)
      @render()
    )

  filterData: (filter) ->
    if filter
      # prevent @raw_data from being overwritten
      @_data = @nestData(x for x in @raw_data when x.series_2 == filter)
    else
      @data(@raw_data)

  renderLegend: ->
    @initializeLegend()
    @legend.selectAll('div.legend_item').remove()
    items = @legend.selectAll('div.legend_item')
      .data({ key: x, text: "Label for #{x}" } for x in @series_3_domain().slice(0).reverse())
    items.enter()
      .append('div')
      .attr('class', 'legend_item vg')
      .attr('label', (d) -> d.key)
    items.append('div')
      .attr('class', 'legend-icon')
      .style('background-color', (d) => @color(d.key))
      .style('width', '15px')
      .style('height', '15px')
      .style('padding', '1px')
      .style('float', 'left')
      .style('margin-right', '5px')
    items.append('span').attr('class','legend_text')
      .text((d) -> d.text)

  initializeLegend: ->
    @legend or= @container.append('div').attr('class', 'legend zvg-chart')
      .style('width', '200px')

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
