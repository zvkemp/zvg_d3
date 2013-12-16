class ZVG.IntensityMatrix
  constructor: ->
    d3.select('body').append('button')
      .text('randomize')
      .on('click', => @randomizeData())
    d3.select('body').append('br')
    @initializeSvg()

  data: (d) ->
    if d
      @raw_data = d
      @_data = @setData(d) 
    @_data
    
  setData: (d) ->
    d3.nest()
      .key((z) -> z.series_1)
      .key((z) -> z.series_2)
      .entries(d)

  width: 900
  height: 500

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

  initializeSvg: ->
    @svg = d3.select('body').append('svg')
      .attr('height', @height + 200).attr('width', @width + 200)
    @background = ZVG.Background(@svg, @height, @width, 0)

  render: ->
    @y = d3.scale.ordinal()
      .domain(@series_2_domain())
      .rangeRoundBands([0, @height])
    @x = d3.scale.ordinal()
      .domain(@series_1_domain())
      .rangeRoundBands([0, @width])
    # find smallest side:
    @range_band = if (@y.rangeBand() < @x.rangeBand()) then @y.rangeBand() else @x.rangeBand()
    @x.rangePoints([0, @width], 1.0)


    @radius = d3.scale.linear()
      .domain([0,100]).range([0, @range_band * 0.45])
    @appendSeries2Labels()
    @appendSeries1Labels()
    @appendSeries1()
    @appendSeries2()

  appendSeries1: ->
    @series_1_groups = @svg.selectAll('g.series_1')
      .data(@data())
    @series_1_groups.enter()
      .append('g')
      .attr('class', 'series_1')
    @series_1_groups.attr('title', (d) -> d.key)
      .attr('transform', (d) => "translate(#{@x(d.key)}, 0)")
    @series_1_groups.exit().remove()

  appendSeries2: (chart) ->
    @series_2_groups = @series_1_groups.selectAll('circle.series_2')
      .data((d) -> d.values)

    @series_2_groups.enter()
      .append('circle')
      .attr('class', 'series_2')
      .attr('stroke', 'white')
      .attr('stroke-width', '1pt')
      .attr('r', 0)
    @series_2_groups.attr('cy', (d) => @y(d.key) + @range_band / 2)
      .attr('cx', 0)
      .transition().duration(1000)
      .attr('r', (d) => @radius(d.values[0].value))
      .attr('title', (d) -> d.key)
      .attr('width', => @range_band)
      .attr('height', => @range_band)
      .style('fill', (d) => @colors()(d.values[0].value))

    @series_2_groups.exit().remove()

  appendSeries2Labels: ->
    series_2_labels = @svg.selectAll('.label.series_2')
      .data(@series_2_domain())
    series_2_labels.enter()
      .append('text')
      .attr('class', 'label series_2')
      .attr('x', @width + 15)
      .attr('y', 0)
    series_2_labels.text((d) -> d)
      .transition()
      .attr('y', (d) => @y(d) + @range_band/2)
    series_2_labels.exit().remove()

    series_2_lines = @svg.selectAll('.line.series_2')
      .data(@series_2_domain())
    series_2_lines.enter()
      .append('line')
      .style('stroke', ZVG.flatUIColors['CONCRETE'])
      .attr('class', 'line series_2')
    series_2_lines.attr('x1', 0).attr('x2', @width + 15)
      .attr('y2', (d) => @y(d) + @range_band/2)
      .attr('y1', (d) => @y(d) + @range_band/2)

    series_2_lines.exit().remove()

  appendSeries1Labels: ->
    series_1_labels = @svg.selectAll('.label.series_1')
      .data(@series_1_domain())
    series_1_labels.enter()
      .append('text')
      .attr('class', 'label series_1')
    series_1_labels.attr('x', (d) => @x(d))
      .attr('y', @height + 15)
      .text((d) -> d)
      .attr('text-anchor','end')
      .attr('transform', (d) => "rotate(-90, #{@x(d)}, #{@height + 15})")
    series_1_labels.exit().transition()
      .attr('x', 0).remove()

    series_1_lines = @svg.selectAll('.line.series_1')
      .data(@series_1_domain())
    series_1_lines.enter()
      .append('line')
      .attr('class', 'line series_1')
      .style('stroke', ZVG.flatUIColors['CONCRETE'])
      .attr('y1', 0)
      .attr('y2', @height + 15)
      .attr('x1', 0)
      .attr('x2', 0)
    series_1_lines.transition()
      .attr('x1', (d) => @x(d))
      .attr('x2', (d) => @x(d))
    series_1_lines.exit()
      .transition()
      .attr('y1', @height)
      .remove()

  
  colors: ->
    @_colors or= d3.scale.linear()
      .domain([0,80,100])
      .range([
        ZVG.flatUIColors['PETER RIVER']
        '#a8cb17'
        ZVG.flatUIColors['SUN FLOWER']
      ])

  randomizeData: (s1Count, s2Count) ->
    s1Count or= parseInt(Math.random() * 9 + 1)
    s2Count or= parseInt(Math.random() * 9 + 1)
    data = []
    for s1 in ([1..s1Count])
      do (s1) =>
        for s2 in ([1..s2Count])
          do (s2) =>
            data.push({ series_1: "Survey #{s1}", series_2: "Filter #{s2}", value: Math.random()*100 })
    @data(data)

    @series_1_domain("Survey #{s}" for s in ([1..s1Count]))
    @series_2_domain("Filter #{s}" for s in ([1..s2Count]))
    @render()
      # .domain([0, d3.max(@raw_data.map (d) -> d.value)])



window.chart = new ZVG.IntensityMatrix()

chart.randomizeData()

