class ZVG.MultiLine extends ZVG.MultiPoint
  # Don't render lines if we have a filter active.
  _should_render_lines: ->
    @_series_3_domain.length is 1 and @_series_3_domain[0] is "all"

  debug: true

  _shape_callback: (chart, shape, d) ->
    if chart._should_render_lines()
      series_name = chart.survey_title_to_series_name[d.values.series_1] || d.values.series_1
      if chart.singletons[series_name] and chart.singletons[series_name][d.key]
        shape.selection.style('opacity', 1)
          .classed('label-hover', true)
          .classed('singleton', true)
      else
        shape.selection.style('opacity', 0)
          .classed('label-hover', true)

