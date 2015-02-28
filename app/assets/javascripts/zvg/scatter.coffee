class ZVG.Scatter extends ZVG.BasicChart

  min_value_x: (value) ->
    if value or value is 0
      @_min_value_x = value
      return @
    @_min_value_x

  max_value_x: (value) ->
    if value or value is 0
      @_max_value_x = value
      return @
    @_max_value_x

  max_value_y: (value) ->
    if value or value is 0
      @_max_value_y = value
      return @
    @_max_value_y

  min_value_y: (value) ->
    if value or value is 0
      @_min_value_y = value
      return @
    @_min_value_y

  _render: ->
    @build_value_domains()
    @render_y_scale()
    @render_x_scale()
    @render_data_points()

  ticks: (domain) ->
    t = domain.ticks()

  render_y_scale: ->
    @y_scale or= @svg.append('g')
    lines = @y_scale.selectAll('line.scale_line').data(@ticks(@y_domain))
    lines.enter()
      .append('line').attr('class', 'scale_line')
      .style('stroke', ZVG.flatUIColors["CONCRETE"])
      .attr('x1', 0)
      .attr('x2', 0)
    lines.attr('y1', @y_domain)
      .attr('y2', @y_domain)
      .transition().duration(1000).attr('x2', @width)
    lines.exit().remove()

    labels = @y_scale.selectAll('text.scale_label').data(@ticks(@y_domain))
    labels.enter()
      .append('text').attr('class', 'scale_label')
      .style('fill', ZVG.flatUIColors['CONCRETE'])
      .attr('alignment-baseline', 'middle')
      .attr('text-anchor', 'start')
    labels.attr('x', @x_padding / 2)
      .attr('y', @y_domain)
      .text((d) -> d)
    labels.exit().remove()

  render_x_scale: ->
    @x_scale or= @svg.append('g')
    lines = @x_scale.selectAll('line.scale_line').data(@ticks(@x_domain))
    lines.enter()
      .append('line').attr('class', 'scale_line')
      .style('stroke', ZVG.flatUIColors["CONCRETE"])
      .attr('y1', 0)
      .attr('y2', 0)
    lines.attr('x1', @x_domain)
      .attr('x2', @x_domain)
      .transition().duration(1000).attr('y2', @height)
    lines.exit().remove()

    labels = @x_scale.selectAll('text.scale_label').data(@ticks(@x_domain))
    labels.enter()
      .append('text').attr('class', 'scale_label')
      .style('fill', ZVG.flatUIColors['CONCRETE'])
      .attr('alignment-baseline', 'middle')
      .attr('text-anchor', 'start')
    labels.attr('y', @height - @y_padding)
      .attr('x', @x_domain)
      .text((d) -> d)
    labels.exit().remove()

  filtered_data: ->
    fd = []
    for s in @data()
      do (s) ->
        for f in s.values
          do (f) ->
            fd.push(f.values)
    fd


  render_data_points: ->
    @points or= @svg.append('g').attr('id', 'points')
    points = @points.selectAll('g.point').data(@filtered_data())
    points.enter()
      .append('g')
      .attr('transform', (d) => "translate(#{@x_domain(d.x_average)},#{@y_domain(d.y_average)})")
      .append('circle')
      .attr('class', 'point')
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('r', 5)
      .style('fill', 'red')

    points.append('text')
      .attr('x', 5)
      .text((d) -> "#{d.series_1} #{d.series_2}")
      .style('font-weight', 'bold')
      .style('opacity', 0)

    points.on('mouseover', ->
      d3.select(this).select('text').style('opacity', 1)
    ).on('mouseout', ->
      d3.select(this).select('text').style('opacity', 0)
    )
    


  build_value_domains: ->
    @x_domain = d3.scale.linear()
      .domain([@max_value_x(), @min_value_x()])
      .range([@width - @x_padding, @x_padding])
    @y_domain = d3.scale.linear()
      .domain([@min_value_y(), @max_value_y()])
      .range([@height - @y_padding, @y_padding])

  x_padding: 20
  y_padding: 20

  x_question_id: (x) ->
    if x
      @_x_question_id = x
      return @
    @_x_question_id
    
  y_question_id: (y) ->
    if y
      @_y_question_id = y
      return @
    @_y_question_id

  nestData: (data) ->
    # { survey_1 => 
    #    filter_1 =>
    #      {
    #        survey_1
    #        filter_1
    #        x: average value
    #        y: average value
    #        x_n: sum
    #        y_n: sum
    #      }
    #
    d3.nest()
      .key((z) -> z.series_1).sortKeys(@seriesSortFunction(@series_1_domain()))
      .key((z) -> z.series_2).sortKeys(@seriesSortFunction(@series_2_domain()))
      .rollup((z) =>
        x_values = (x for x in z when x.question_id is @_x_question_id)
        y_values = (y for y in z when y.question_id is @_y_question_id)
        x_n = d3.sum(x.value for x in x_values)
        y_n = d3.sum(y.value for y in y_values)
        x_sum = d3.sum(x.value * x.series_3 for x in x_values)
        y_sum = d3.sum(y.value * y.series_3 for y in y_values)

        {
          series_1: z[0].series_1
          series_2: z[0].series_2
          x_n: x_n
          y_n: y_n
          x_average: x_sum / x_n
          y_average: y_sum / y_n
        }
      ).entries(data)


