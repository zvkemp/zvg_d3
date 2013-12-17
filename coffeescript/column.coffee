class ZVG.Column extends ZVG.BasicChart
  constructor: ->
    d3.select('body').append('button')
      .text('randomize')
      .on('click', => @randomizeData())
    d3.select('body').append('br')
    @initializeSvg()

  randomizeData: (s1count, s2count, s3count) ->
    s1count or= parseInt(Math.random() * 15 + 1)
    s2count or= parseInt(Math.random() * 15 + 1)
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
    @data(raw)
    @render()
  
  nestData: (d) ->
    d3.nest()
      .key((z) -> z.series_1)
      .key((z) -> z.series_2)
      .key((z) -> z.series_3)
      .entries(d)

  color: d3.scale.ordinal().range(ZVG.colorSchemes.warmCool10)
  resetWidth: ->
    @widenChart ZVG.BasicChart.prototype.width

  render: ->
    @resetWidth()
    @setSeries1Spacing()
    @renderSeries1()
    @buildSeriesDomains()
    @renderSeries2()
    @appendSeries1Labels()
    @initializeY()
    @initializeLabels()
    @appendSeries2Borders()
    @renderSeries3()
    @renderSeries3Labels()
    @bindValueGroupHover()
    @renderLegend()

  setSeries1Spacing: ->
    @series1width      = []
    @series1x          = []
    scale              = d3.scale.ordinal().domain(@raw_data.map((d) -> d.series_1))
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
    @widenChart(@width + 100) if @columnBand.rangeBand() < 15

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
    @series_1.attr('transform', (d,i) => "translate(#{@series1x[i]}, 0)")
    @series_1.exit().remove()

  buildSeriesDomains: ->
    @series3Domains = {}
    for s1 in @_data
      do (s1) =>
        @series3Domains[s1.key] = {}
        for s2 in s1.values
          do (s2) =>
            s3 = s2.values.map((d) => d.values[0].value)
            @series3Domains[s1.key][s2.key] = d3.scale.linear()
              .domain([0, d3.sum(s3)])
              .range([0, @height])

  
  renderSeries2: ->
    @series_2 = @series_1.selectAll('.series2')
      .data((d) -> d.values)
    @series_2.enter()
      .append('g')
      .attr('class', 'column series2')
      .attr('transform', "translate(0,0)")
    @series_2.attr('label', (d) -> d.key).transition().duration(300)
      .attr('transform', (d,i) => "translate(#{@columnBand(i)}, 0)")
    @series_2.exit()
      .attr('transform', "translate(0,0)")
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
    vg = @svg.selectAll('.vg')
    vg.on('mouseover', (d) =>
      vg.filter((e) -> e.key != d.key)
        .attr('opacity', 0.2)
    ).on('mouseout', (d) =>
      @svg.selectAll('.vg').attr('opacity', 1)
    )
  
  valueHeightFunction: (d) =>
    dp = d.values[0]
    @series3Domains[dp.series_1][dp.series_2](dp.value)

  valuePercentFunction: (d) =>
    dp = d.values[0]
    n = @series3Domains[dp.series_1][dp.series_2].domain()[1]
    console.log dp, n
    @percentFormat dp.value/n

  renderSeries3Labels: ->
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
    @series_3_labels.text(@valuePercentFunction)


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
    @series_1_labels.attr('y', @height + 20)
      .text((d) -> d.key)
      .attr('x', (d,i) => @series1x[i])
      .style('fill', '#f00')
    @series_1_labels.exit().remove()



window.chart = new ZVG.Column
chart.randomizeData()
chart.render()

window.sample_data = [
  {
    series_1: 'Survey 1'
    series_2: 'Filter 1'
    series_3: 1
    value: 100
  }
  {
    series_1: 'Survey 1'
    series_2: 'Filter 1'
    series_3: 2
    value: 200
  }
  {
    series_1: 'Survey 1'
    series_2: 'Filter 2'
    series_3: 1
    value: 200
  }
  {
    series_1: 'Survey 1'
    series_2: 'Filter 2'
    series_3: 2
    value: 300
  }
  {
    series_1: 'Survey 1'
    series_2: 'Filter 4'
    series_3: 1
    value: 100
  }
  {
    series_1: 'Survey 1'
    series_2: 'Filter 4'
    series_3: 2
    value: 400
  }
  {
    series_1: 'Survey 2'
    series_2: 'Filter 1'
    series_3: 1
    value: 100
  }
  {
    series_1: 'Survey 2'
    series_2: 'Filter 1'
    series_3: 2
    value: 200
  }
  {
    series_1: 'Survey 2'
    series_2: 'Filter 3'
    series_3: 1
    value: 200
  }
  {
    series_1: 'Survey 2'
    series_2: 'Filter 3'
    series_3: 2
    value: 300
  }
  {
    series_1: 'Survey 3'
    series_2: 'Filter 3'
    series_3: 1
    value: 100
  }
  {
    series_1: 'Survey 3'
    series_2: 'Filter 3'
    series_3: 2
    value: 200
  }
  {
    series_1: 'Survey 3'
    series_2: 'Filter 2'
    series_3: 1
    value: 200
  }
  {
    series_1: 'Survey 3'
    series_2: 'Filter 2'
    series_3: 2
    value: 300
  }
]
