ZVG.column = ->

  _chart        = { chart_type: 'column' }
  _width        = 1200
  _chartWidth   = 300
  _height       = 650
  _chartHeight  = 500
  _data         = []
  _raw_data     = []
  color         = d3.scale.category20()
  columnSpacing = null
  columnPadding = null
  seriesPadding = null
  series1x      = []
  series1width  = []
  columnBand    = null
  series_1      = null
  series_2      = null
  y             = null
  labels        = null
  percent       = null

  _svg = d3.select('body').append('svg')
    .attr('width', _width).attr('height', _height)

  _chart.svg = -> _svg

  _chart.data = (data) ->
    return _data unless arguments.length
    _raw_data = data
    _data = d3.nest()
      .key((d) -> d.series_1)
      .key((d) -> d.series_2)
      .entries(data)
    setSeries1Spacing()
    renderData()
    _chart

  _chart.raw_data = -> _raw_data

  _chart.percentage = d3.scale.linear().domain([0,1]).range(['0%', '100%'])
  
  setSeries1Spacing = ->
    scale = d3.scale.ordinal()
      .domain( _raw_data.map((d) -> d.series_1))

    ranges = {}
    totalColumnCount = 0
    _data.forEach((d) -> totalColumnCount += d.values.length)
    columnSpacing = _chartWidth/(totalColumnCount + _data.length)
    columnPadding = 0.1 * columnSpacing
    seriesPadding = columnSpacing / 2
    currentX = 0
    maxCount = d3.max(_data, (d) -> d.values.length)
    _data.forEach((d,i) ->
      w = columnSpacing * (d.values.length + 1)
      series1width[i] = w - seriesPadding * 2
      series1x[i] = currentX + seriesPadding
      currentX += w
    )

    columnBand = d3.scale.ordinal()
      .domain([0...maxCount])
      .rangeRoundBands([0, columnSpacing * maxCount], 0.1)


  setSeries1Spacing()
  # ZVG.applyBackground(_svg, _chartWidth, _chartHeight)
  ZVG.Background(_svg, _chartHeight, _chartWidth, 0) 

  series1padding = -> 0.1 * series1Totalwidth()

  series1Totalwidth = ->  _chartWidth / _data.length



  initializeSeries1 = ->
    series_1 = _svg.selectAll('.series1')
      .data(_data)
      .enter()
      .append('g')
      .attr('class', 'series1')
      .attr('transform', (d,i) -> "translate(#{series1x[i]},0)")

  appendSeries1Labels = ->
    # series label (to remove)
    series_1.append('text')
      .text((d) -> d.key)
      .attr('y', _chartHeight + 20)
      .attr('x', 20)
      .style('fill', '#f00')


  initializeSeries2 = ->
    # column group
    series_2 = series_1.selectAll('.series2')
      .data((d) -> d.values)
      .enter()
      .append('g')
      .attr('class', 'column series2')
      .attr('label', (d) -> d.key)
      .attr('transform', (d,i) -> "translate(#{columnBand(i)},0)")

  appendSeries2Shadows = ->
    series_2.append('rect')
      .style('stroke', 'none')
      .style('fill', '#444')
      .attr('x', -3)
      .attr('y',0)
      .attr('width', columnBand.rangeBand() + 6)
      .attr('height', _chartHeight)
      .attr('opacity', 0)
      .transition().delay(600).duration(1000)
      .attr('opacity', 0.5)

  appendSeries2Borders = ->
    series_2.append('rect')
      .style('stroke', 'white')
      .style('fill', 'none')
      .style('stroke-width', '1.5pt')
      .attr('x', 0)
      .attr('y', _chartHeight)
      .attr('height', 0)
      .attr('width', columnBand.rangeBand())
      .attr('opacity', 0)
      .transition().delay(300).duration(700)
      .attr('y', 0)
      .attr('height', _chartHeight)
      .attr('opacity', 0.5)

  initializeY = ->
    # no domain declared; for 100% columns, should be set
    # for each column individually (see below)
    y = d3.scale.linear()
      .range([0, _chartHeight])

  initializeLabels = ->
    labels = d3.scale.linear()
      .range([0, 1]) # percentage
    percent = d3.format('.0%')

  renderData = ->
    initializeSeries1()
    appendSeries1Labels()
    initializeSeries2()
    # appendSeries2Shadows()
    # appendSeries2Borders()
    initializeY()
    initializeLabels()

    current_y = 0
    series_2.selectAll('rect.vg')
      .data((d) -> d.values[0].data)
      .enter()
      .append('rect').style('fill', (d,i) -> color(i))
      .attr('x', 0)
      .attr('y', _chartHeight)
      .attr('height', 0)
      .transition().duration(700)
      .attr('y', (d,i) -> 
        current_y = 0 if i == 0
        dp = this.parentNode.__data__.values[0].data
        h = y.domain([0, d3.sum dp])(d)
        current_y += h
        current_y - h
      ).attr('class', (d,i) -> "vg vg_#{i}")
      .attr('width', columnBand.rangeBand())
      .attr('height', (d) ->
        dp = this.parentNode.__data__.values[0].data
        y.domain([0, d3.sum dp])(d)
      )

    # column labels
    series_2.selectAll('text.column')
      .data((d) -> d.values[0].data)
      .enter()
      .append('text')
      .text((d) -> 
        dp = this.parentNode.__data__.values[0].data
        percent labels.domain([0, d3.sum dp])(d)
      ).attr('x', columnBand.rangeBand()/2)
      .attr('y', (d, i) -> 
        current_y = 0 if i == 0
        dp = this.parentNode.__data__.values[0].data
        h = y.domain([0, d3.sum dp])(d)
        current_y += h
        current_y - (0.5 * h)
      ).attr('class', 'column-label')
      .attr('opacity', 0)
      .transition().delay(300).duration(700)
      .attr('opacity', 1)

  _chart



column = ZVG.column()
raw_data = [
  {
    series_1: "Survey A"
    series_2: "male"
    n: 400
    data:  [300, 100, 50, 25]
  }
  {
    series_1: "Survey A"
    series_2: "female"
    n: 700
    data:  [300, 250, 9, 150]
  } 
  {
    series_1: "Survey A"
    series_2: "other"
    n: 700
    data:  [340, 50,89, 150]
  } 
  {
    series_1: "Survey B"
    series_2: "all"
    n: 650
    data: [500, 150, 15,  0]
  }
  {
    series_1: "Survey C"
    series_2: "male"
    n: 200
    data: [100, 25, 75]
  }
  {
    series_1: "Survey C"
    series_2: "female"
    n: 400
    data: [100, 16, 250, 50]
  }
  {
    series_1: "Survey D"
    series_2: "male"
    n: 900
    data: [19, 500, 300, 100]
  }
  {
    series_1: "Survey D"
    series_2: "female"
    n: 800
    data: [500, 200, 100]
  }
  {
    series_1: "Survey D"
    series_2: "other"
    n: 900
    data: [500, 300, 100]
  }
]

data = d3.nest()
  .key((d) -> d.series_1)
  .key((d) -> d.series_2)
  .entries(raw_data)
window.raw_data = raw_data
window.data = data
column.data(raw_data)
window.column = column
