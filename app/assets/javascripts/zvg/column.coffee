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


  # the only one that matters.
  # Runs the necessary functions in order to render the chart.
  render: (renderMode = 'percentage') ->
    @renderMode = renderMode
    @reset_width()
    @set_series_1_spacing()
    @renderSeries1()
    @build_series_domains()
    @renderSeries2()
    @renderSeries1Labels()
    @renderSeries2Labels()
    @initializeY()
    @initializeLabels()
    @renderSeries3()
    @renderSeries3Labels()
    @render_legend()
    @bind_value_group_hover()
    @bind_value_group_click()

  minimum_column_width: 20
  
  # appends a <g> element and places it along the x axis for each member of series 1
  renderSeries1: ->
    @series_1 = @svg.selectAll('.series1').data(@_data)
    @series_1.enter().append('g').attr('class', 'series1')
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
    @series_2 = @series_1.selectAll('.series2').data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'column series2')
      .attr('transform', "translate(0,0)")
    @series_2.attr('label', (d) -> d.key).transition().duration(500)
      .attr('transform', (d,i) => "translate(#{@column_band(i)}, 0)")
    @series_2.exit()
      .transition().duration(500)
      .attr('transform', "translate(0,-1000)")
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
      .transition().delay(500).attr('opacity', 1)
    computeFontSize = @computeFontSize
    valueHeightFunction = @valueHeightFunction
    @series_3_labels.text(textFunction)
    @series_3_labels.style('font-size', (d) ->
      # is there a better way to do this? need class bindings as well as local `this`
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

  initializeLabels: ->
    @labels = d3.scale.linear().range([0, 1])
    @percent = d3.format('.0%')


  renderSeries1Labels: ->
    @series_1_labels = @series_1_label_container.selectAll('text.series1label')
      .data(@_data)
    @series_1_labels.enter()
      .append('text')
      .attr('class', 'series1label')
    @series_1_labels.attr('y', 0)
      .attr('transform', '')
      .text((d) -> d.key)
      .attr('x', (d,i) => @series_1_x[i] + @series_1_width[i]/2)
      .style('text-anchor', null)
    @series_1_labels.exit().remove()
    @constructSeries1LabelMap()
    # @adjustSeries1EndLabels()
    # @rotateSeries1Labels() if @detect_overlaps(@series1LabelMap)
    @addLineBreaksToSeries1Labels() if @detect_overlaps(@series1LabelMap)

  adjustSeries1EndLabels: ->
    # initial condition is horizontal labels with text-anchor: middle
    end_index = @series1LabelMap.length - 1
    start = @series1LabelMap[0]
    end   = @series1LabelMap[end_index]
    _start = d3.select(@series_1_labels[0][0])
    _end = d3.select(@series_1_labels[0][end_index])
    console.log('start', _start, 'end', _end)
    if start.start < 0
      console.log("START IS CUT OFF")
      difference = start.start
      new_center = start.x - difference # subtract the negative
      _start.attr('x', new_center)
    if end.end > @width
      console.log("END IS CUT OFF")
      difference = end.end - @width
      new_center = end.x - difference
      _end.attr('x', new_center)

  addLineBreaksToSeries1Labels: ->
    console.log("ADD LINE BREAKS")
    @series_1_labels.text(null)
    tspans = @series_1_labels.selectAll('tspan')
      .data((d) -> ZVG.Utilities.splitString(d.key))
    tspans.enter()
      .append('tspan')
    tspans.text((d) -> d)
      .attr('dy', (d, i) -> "#{i * 1.2}em")
      .attr('x', (d) -> d3.select(@parentNode).attr('x'))


    


  renderSeries2Labels: (rotate = 0) ->
    @svg.selectAll('.series2label').remove()
    @series_2_labels = @series_1.selectAll('text.series2label')
      .data((d) -> d.values)
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
        sum = d3.sum(value.values[0].value for value in d.values)
        "#{@series_2_label_visibility(d.key)} (#{sum})"
      )

    @series_2_labels.on('click', (d,i) =>
      @filter_data([d.key])
      @render()
    )
    @constructSeries2LabelMap()
    if @detect_overlaps(@series2LabelMap) and (rotate is 0)
      @rotateSeries2Labels()
    else
      @series_1_label_container.transition().attr('transform', "translate(0, #{@height + 30})")

  rotateSeries2Labels: ->
    max_length = d3.max(l.length for l in @series2LabelMap)
    @renderSeries2Labels(-90)
    @series_1_label_container.transition().attr('transform', "translate(0, #{@height + max_length + 25})")

  rotateSeries1Labels: ->
    @series_1_labels.attr('transform', (d) -> 
      s = d3.select(@)
      x = s.attr('x')
      y = s.attr('y')
      "rotate(-45, #{x}, #{y})"
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

  staggerSeries1Labels: ->
    for label, index in @series_1_labels[0]
      do (label, index) =>
        if (index % 2) is 1
          d3.select(label).attr('y', 15)



  # to be used to in the detection of overlapping labels (in detect_overlaps()
  constructSeries2LabelMap: ->
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
    @series2LabelMap = label_map

  constructSeries1LabelMap: ->
    label_map = []
    for label, index in @series_1_labels[0]
      do (label, index) =>
        ls = d3.select(label)
        x = parseFloat(ls.attr('x'))
        length = label.getComputedTextLength()
        label_map.push({
          label: ls.text()
          x: x
          length: length
          start: x - (length / 2.0)
          end: x + (length / 2.0)
        })
    @series1LabelMap = label_map

  detect_overlaps: (label_map) ->
    overlap = false
    for label, index in label_map
      do (label, index) =>
        prev = label_map[index - 1]
        if prev and (prev.end > label.start)
          overlap = true

    return overlap


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
