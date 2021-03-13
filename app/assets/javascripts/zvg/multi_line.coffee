class ZVG.MultiLine extends ZVG.MultiPoint
  # Don't render lines if we have a filter active.
  _should_render_lines: ->
    if (@_data.length is 1) # FIXME for series
      return false
    @_series_3_domain.length is 1 and @_series_3_domain[0] is "all"

  _shape_callback: (chart, shape) ->
    if chart._should_render_lines()
      shape.selection.style('opacity', 0)
        .classed('label-hover', true)
