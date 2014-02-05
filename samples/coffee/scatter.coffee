buttons = d3.select('body').append('div')
  .attr('id', 'buttons')

chart = new ZVG.Scatter('body')
window.chart = chart

sample_data = [
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 101, series_3: 1, value: "5" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 101, series_3: 2, value: "25" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 101, series_3: 3, value: "75" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 101, series_3: 4, value: "26" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 101, series_3: 5, value: "35" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 102, series_3: 1, value: "2" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 102, series_3: 2, value: "94" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 102, series_3: 3, value: "3" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 102, series_3: 4, value: "72" }
  { series_1: "Survey 1", series_2: "Filter 1", question_id: 102, series_3: 5, value: "62" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 101, series_3: 1, value: "93" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 101, series_3: 2, value: "60" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 101, series_3: 3, value: "55" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 101, series_3: 4, value: "24" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 101, series_3: 5, value: "92" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 102, series_3: 1, value: "38" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 102, series_3: 2, value: "1" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 102, series_3: 3, value: "71" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 102, series_3: 4, value: "21" }
  { series_1: "Survey 1", series_2: "Filter 2", question_id: 102, series_3: 5, value: "24" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 101, series_3: 1, value: "44" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 101, series_3: 2, value: "93" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 101, series_3: 3, value: "32" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 101, series_3: 4, value: "37" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 101, series_3: 5, value: "34" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 102, series_3: 1, value: "74" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 102, series_3: 2, value: "23" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 102, series_3: 3, value: "29" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 102, series_3: 4, value: "71" }
  { series_1: "Survey 1", series_2: "Filter 3", question_id: 102, series_3: 5, value: "15" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 101, series_3: 1, value: "44" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 101, series_3: 2, value: "88" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 101, series_3: 3, value: "48" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 101, series_3: 4, value: "51" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 101, series_3: 5, value: "58" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 102, series_3: 1, value: "97" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 102, series_3: 2, value: "35" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 102, series_3: 3, value: "31" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 102, series_3: 4, value: "46" }
  { series_1: "Survey 2", series_2: "Filter 1", question_id: 102, series_3: 5, value: "41" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 101, series_3: 1, value: "43" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 101, series_3: 2, value: "40" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 101, series_3: 3, value: "4" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 101, series_3: 4, value: "43" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 101, series_3: 5, value: "99" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 102, series_3: 1, value: "58" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 102, series_3: 2, value: "100" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 102, series_3: 3, value: "61" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 102, series_3: 4, value: "43" }
  { series_1: "Survey 2", series_2: "Filter 2", question_id: 102, series_3: 5, value: "43" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 101, series_3: 1, value: "82" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 101, series_3: 2, value: "83" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 101, series_3: 3, value: "29" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 101, series_3: 4, value: "9" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 101, series_3: 5, value: "27" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 102, series_3: 1, value: "33" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 102, series_3: 2, value: "4" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 102, series_3: 3, value: "36" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 102, series_3: 4, value: "97" }
  { series_1: "Survey 2", series_2: "Filter 3", question_id: 102, series_3: 5, value: "83" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 101, series_3: 1, value: "4" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 101, series_3: 2, value: "80" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 101, series_3: 3, value: "93" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 101, series_3: 4, value: "43" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 101, series_3: 5, value: "28" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 102, series_3: 1, value: "86" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 102, series_3: 2, value: "25" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 102, series_3: 3, value: "41" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 102, series_3: 4, value: "2" }
  { series_1: "Survey 3", series_2: "Filter 1", question_id: 102, series_3: 5, value: "45" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 101, series_3: 1, value: "16" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 101, series_3: 2, value: "4" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 101, series_3: 3, value: "2" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 101, series_3: 4, value: "60" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 101, series_3: 5, value: "61" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 102, series_3: 1, value: "7" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 102, series_3: 2, value: "9" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 102, series_3: 3, value: "66" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 102, series_3: 4, value: "61" }
  { series_1: "Survey 3", series_2: "Filter 2", question_id: 102, series_3: 5, value: "81" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 101, series_3: 1, value: "1" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 101, series_3: 2, value: "29" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 101, series_3: 3, value: "7" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 101, series_3: 4, value: "82" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 101, series_3: 5, value: "4" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 102, series_3: 1, value: "99" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 102, series_3: 2, value: "50" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 102, series_3: 3, value: "23" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 102, series_3: 4, value: "62" }
  { series_1: "Survey 3", series_2: "Filter 3", question_id: 102, series_3: 5, value: "27" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 101, series_3: 1, value: "64" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 101, series_3: 2, value: "25" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 101, series_3: 3, value: "1" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 101, series_3: 4, value: "63" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 101, series_3: 5, value: "35" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 102, series_3: 1, value: "72" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 102, series_3: 2, value: "25" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 102, series_3: 3, value: "38" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 102, series_3: 4, value: "83" }
  { series_1: "Survey 4", series_2: "Filter 1", question_id: 102, series_3: 5, value: "67" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 101, series_3: 1, value: "33" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 101, series_3: 2, value: "8" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 101, series_3: 3, value: "19" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 101, series_3: 4, value: "62" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 101, series_3: 5, value: "89" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 102, series_3: 1, value: "29" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 102, series_3: 2, value: "98" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 102, series_3: 3, value: "98" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 102, series_3: 4, value: "22" }
  { series_1: "Survey 4", series_2: "Filter 2", question_id: 102, series_3: 5, value: "67" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 101, series_3: 1, value: "30" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 101, series_3: 2, value: "100" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 101, series_3: 3, value: "71" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 101, series_3: 4, value: "68" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 101, series_3: 5, value: "72" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 102, series_3: 1, value: "85" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 102, series_3: 2, value: "3" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 102, series_3: 3, value: "25" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 102, series_3: 4, value: "53" }
  { series_1: "Survey 4", series_2: "Filter 3", question_id: 102, series_3: 5, value: "34" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 101, series_3: 1, value: "88" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 101, series_3: 2, value: "11" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 101, series_3: 3, value: "75" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 101, series_3: 4, value: "59" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 101, series_3: 5, value: "66" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 102, series_3: 1, value: "67" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 102, series_3: 2, value: "67" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 102, series_3: 3, value: "23" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 102, series_3: 4, value: "88" }
  { series_1: "Survey 5", series_2: "Filter 1", question_id: 102, series_3: 5, value: "29" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 101, series_3: 1, value: "35" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 101, series_3: 2, value: "2" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 101, series_3: 3, value: "20" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 101, series_3: 4, value: "1" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 101, series_3: 5, value: "83" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 102, series_3: 1, value: "54" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 102, series_3: 2, value: "50" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 102, series_3: 3, value: "42" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 102, series_3: 4, value: "3" }
  { series_1: "Survey 5", series_2: "Filter 2", question_id: 102, series_3: 5, value: "93" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 101, series_3: 1, value: "65" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 101, series_3: 2, value: "58" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 101, series_3: 3, value: "28" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 101, series_3: 4, value: "70" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 101, series_3: 5, value: "4" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 102, series_3: 1, value: "35" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 102, series_3: 2, value: "63" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 102, series_3: 3, value: "77" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 102, series_3: 4, value: "14" }
  { series_1: "Survey 5", series_2: "Filter 3", question_id: 102, series_3: 5, value: "3" }
]


apply_sample_data = ->
  chart.x_question_id(101)
    .y_question_id(102)
    .data(sample_data)
    .series_1_domain("Survey #{n}" for n in [1,2,3,4,5])
    .series_2_domain("Filter #{n}" for n in [1,2,3])
    .series_3_domain("#{n}" for n in [100])
    .min_value_x(1)
    .min_value_y(1)
    .max_value_x(6)
    .max_value_y(6)
    .render()

apply_sample_data()

buttons.append('button')
  .text('randomize')
  .on('click', =>
    chart.randomizeData())
buttons.append('button')
  .text('standard sample data')
  .on('click', apply_sample_data)
buttons.append('button')
  .text('show percentages')
  .on('click', => chart.render('percentage'))
buttons.append('button')
  .text('show counts')
  .on('click', => chart.render('count'))


