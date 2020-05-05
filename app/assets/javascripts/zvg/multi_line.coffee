class ZVG.MultiLine extends ZVG.MultiPoint
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

  # Don't render lines if we have a filter active.
  _should_render_lines: ->
    if (@_series_1_domain.length is 1)
      return false
    @_series_3_domain.length is 1 and @_series_3_domain[0] is "all"


  render_series_2_lines: ->
    if not @_should_render_lines()
      return

    lineData = @_build_line_data()

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

  _shape_callback: (chart, shape) ->
    if chart._should_render_lines()
      shape.selection.style('opacity', 0)
        .classed('label-hover', true)
