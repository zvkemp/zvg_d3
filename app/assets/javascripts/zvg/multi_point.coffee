class ZVG.MultiPoint extends ZVG.Point
  # multiple questions rendered onto the same scale (same as radar data)
  # series 2 and question_id should be reversed
  data: (d) ->
    @raw_data or= d
    if d
      super(d.map((entry) ->
        {
          series_1: entry.series_1
          series_3: entry.series_3
          series_2: entry.question_id
          value: entry.value
          question_id: entry.series_2
        }
      ))
    else
      @_data

  series_2_label_visibility: (label) ->
    if @series_2_domain().length is 1
      ""
    else
      label
