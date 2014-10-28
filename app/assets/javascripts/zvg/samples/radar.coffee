window.chart = new ZVG.Radar('body')

window.simpleTestData = [
  # Single survey, single filter, 5 questions
  { series_1: 'Survey 1', series_2: 'all', series_3: 100, value: 4.5 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 200, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 300, value: 4.1 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 400, value: 2.8 }
  { series_1: 'Survey 1', series_2: 'all', series_3: 500, value: 2.1 }
  
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 100, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 200, value: 1.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 300, value: 2.1 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 400, value: 3.8 }
  { series_1: 'Survey 1', series_2: 'Filter 2', series_3: 500, value: 3.1 }
]

window.moreComplexData = [
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:100, value: 3.4941219999454916},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:200, value: 1.9292143830098212},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:300, value: 2.713041902985424},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:400, value: 1.5061968080699444},
  {series_1: 'Survey 1',series_2: "Filter 1", series_3:500, value: 5.406578453723341},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:100, value: 4.2298069428652525},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:200, value: 5.5519170253537595},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:300, value: 0.2769786645658314},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:400, value: 1.6917675621807575},
  {series_1: 'Survey 1',series_2: "Filter 2", series_3:500, value: 0.619645903352648},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:100, value: 4.02297692745924},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:200, value: 2.8029478769749403},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:300, value: 0.9199619614519179},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:400, value: 2.8409991916269064},
  {series_1: 'Survey 1',series_2: "Filter 3", series_3:500, value: 4.59977040393278}
]

chart
  .series_1_domain(['Survey 1'])
  .series_2_domain("Filter #{n}" for n in [1..3])
  .series_3_domain("#{n}" for n in [100, 200, 300, 400, 500])
  .data(moreComplexData)
  .maxRadius(6)
  .setFilter('Filter 1')
  .render()
