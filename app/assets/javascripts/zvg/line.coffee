class ZVG.Line extends ZVG.Point
  _build_line_data: ->
    lineData = {}
    for s1 in @data()
      do (s1) =>
        s1_key = s1.key
        for s2 in s1.values[0].values
          do (s2) =>
            s2_key = s2.key
            lineData[s2.key] or= []
            lineData[s2.key].push(s2.values)
    lineData

  _should_render_lines: ->
    if (@_data.length is 1)
      return false
    true

  render_series_2_lines: ->
    lineData = if @_should_render_lines() then @_build_line_data() else []

    chart = @
    x_offset = @column_band() + (@column_band.rangeBand() / 2)
    mapper = (v) ->
      [ chart.series_1_x_by_key[v.series_1] + x_offset,
        chart.value_domain(v.average)
      ]

    data = ({key: k, values: v.map(mapper)} for k, v of lineData)

    paths = @svg.selectAll('path.line').data(data)
    paths.enter()
      .append('path')
      .attr('class', 'line series2')

    paths.attr('d', (d) -> d3.svg.line()(d.values))
      .attr('fill', 'none')
      .attr('stroke', (d) -> chart.series_2_colors[d.key])
      .attr('stroke-width', '3px')

    paths.exit().remove()

  # FIXME: this should check if it is the only point that would be in a line
  _shape_callback: (chart, shape) ->
    if chart._should_render_lines()
      shape.selection.style('opacity', 0)
        .classed('label-hover', true)
