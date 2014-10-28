buttons = d3.select('body').append('div')
  .attr('id', 'buttons')

chart = new ZVG.Point('body')
window.chart = chart


sample_data = [ # single question
  {series_1: "Survey 1",series_2: "Filter 1",question_id: 100,series_3: 1,value: 660},
  {series_1: "Survey 1",series_2: "Filter 1",question_id: 100,series_3: 2,value: 20},
  {series_1: "Survey 1",series_2: "Filter 1",question_id: 100,series_3: 3,value: 97},
  {series_1: "Survey 1",series_2: "Filter 1",question_id: 100,series_3: 4,value: 66},
  {series_1: "Survey 1",series_2: "Filter 1",question_id: 100,series_3: 5,value: 48},

  {series_1: "Survey 1",series_2: "Filter 2",question_id: 100,series_3: 1,value: 17},
  {series_1: "Survey 1",series_2: "Filter 2",question_id: 100,series_3: 2,value: 730},
  {series_1: "Survey 1",series_2: "Filter 2",question_id: 100,series_3: 3,value: 360},
  {series_1: "Survey 1",series_2: "Filter 2",question_id: 100,series_3: 4,value: 62},
  {series_1: "Survey 1",series_2: "Filter 2",question_id: 100,series_3: 5,value: 51},

  {series_1: "Survey 1",series_2: "Filter 3",question_id: 100,series_3: 1,value: 17},
  {series_1: "Survey 1",series_2: "Filter 3",question_id: 100,series_3: 2,value: 55},
  {series_1: "Survey 1",series_2: "Filter 3",question_id: 100,series_3: 3,value: 30},
  {series_1: "Survey 1",series_2: "Filter 3",question_id: 100,series_3: 4,value: 690},
  {series_1: "Survey 1",series_2: "Filter 3",question_id: 100,series_3: 5,value: 55},


  {series_1: "Survey 2",series_2: "Filter 1",question_id: 100,series_3: 1,value: 840},
  {series_1: "Survey 2",series_2: "Filter 1",question_id: 100,series_3: 2,value: 69},
  {series_1: "Survey 2",series_2: "Filter 1",question_id: 100,series_3: 3,value: 93},
  {series_1: "Survey 2",series_2: "Filter 1",question_id: 100,series_3: 4,value: 62},
  {series_1: "Survey 2",series_2: "Filter 1",question_id: 100,series_3: 5,value: 81},
  
  {series_1: "Survey 2",series_2: "Filter 2",question_id: 100,series_3: 1,value: 47},
  {series_1: "Survey 2",series_2: "Filter 2",question_id: 100,series_3: 2,value: 17},
  {series_1: "Survey 2",series_2: "Filter 2",question_id: 100,series_3: 3,value: 420},
  {series_1: "Survey 2",series_2: "Filter 2",question_id: 100,series_3: 4,value: 98},
  {series_1: "Survey 2",series_2: "Filter 2",question_id: 100,series_3: 5,value: 36},

  {series_1: "Survey 2",series_2: "Filter 3",question_id: 100,series_3: 1,value: 42},
  {series_1: "Survey 2",series_2: "Filter 3",question_id: 100,series_3: 2,value: 19},
  {series_1: "Survey 2",series_2: "Filter 3",question_id: 100,series_3: 3,value: 23},
  {series_1: "Survey 2",series_2: "Filter 3",question_id: 100,series_3: 4,value: 580},
  {series_1: "Survey 2",series_2: "Filter 3",question_id: 100,series_3: 5,value: 320},


  {series_1: "Survey 3",series_2: "Filter 1",question_id: 100,series_3: 1,value: 65},
  {series_1: "Survey 3",series_2: "Filter 1",question_id: 100,series_3: 2,value: 790},
  {series_1: "Survey 3",series_2: "Filter 1",question_id: 100,series_3: 3,value: 8},
  {series_1: "Survey 3",series_2: "Filter 1",question_id: 100,series_3: 4,value: 87},
  {series_1: "Survey 3",series_2: "Filter 1",question_id: 100,series_3: 5,value: 81},

  {series_1: "Survey 3",series_2: "Filter 2",question_id: 100,series_3: 1,value: 61},
  {series_1: "Survey 3",series_2: "Filter 2",question_id: 100,series_3: 2,value: 61},
  {series_1: "Survey 3",series_2: "Filter 2",question_id: 100,series_3: 3,value: 1800},
  {series_1: "Survey 3",series_2: "Filter 2",question_id: 100,series_3: 4,value: 72},
  {series_1: "Survey 3",series_2: "Filter 2",question_id: 100,series_3: 5,value: 82},
  
  {series_1: "Survey 3",series_2: "Filter 3",question_id: 100,series_3: 1,value: 80},
  {series_1: "Survey 3",series_2: "Filter 3",question_id: 100,series_3: 2,value: 57},
  {series_1: "Survey 3",series_2: "Filter 3",question_id: 100,series_3: 3,value: 29},
  {series_1: "Survey 3",series_2: "Filter 3",question_id: 100,series_3: 4,value: 510},
  {series_1: "Survey 3",series_2: "Filter 3",question_id: 100,series_3: 5,value: 180},

  
  {series_1: "Survey 4",series_2: "Filter 1",question_id: 100,series_3: 1,value: 270},
  {series_1: "Survey 4",series_2: "Filter 1",question_id: 100,series_3: 2,value: 920},
  {series_1: "Survey 4",series_2: "Filter 1",question_id: 100,series_3: 3,value: 15},
  {series_1: "Survey 4",series_2: "Filter 1",question_id: 100,series_3: 4,value: 22},
  {series_1: "Survey 4",series_2: "Filter 1",question_id: 100,series_3: 5,value: 63},

  {series_1: "Survey 4",series_2: "Filter 2",question_id: 100,series_3: 1,value: 49},
  {series_1: "Survey 4",series_2: "Filter 2",question_id: 100,series_3: 2,value: 67},
  {series_1: "Survey 4",series_2: "Filter 2",question_id: 100,series_3: 3,value: 990},
  {series_1: "Survey 4",series_2: "Filter 2",question_id: 100,series_3: 4,value: 88},
  {series_1: "Survey 4",series_2: "Filter 2",question_id: 100,series_3: 5,value: 94},

  {series_1: "Survey 4",series_2: "Filter 3",question_id: 100,series_3: 1,value: 49},
  {series_1: "Survey 4",series_2: "Filter 3",question_id: 100,series_3: 2,value: 27},
  {series_1: "Survey 4",series_2: "Filter 3",question_id: 100,series_3: 3,value: 12},
  {series_1: "Survey 4",series_2: "Filter 3",question_id: 100,series_3: 4,value: 89},
  {series_1: "Survey 4",series_2: "Filter 3",question_id: 100,series_3: 5,value: 870},


  {series_1: "Survey 5",series_2: "Filter 1",question_id: 100,series_3: 1,value: 520},
  {series_1: "Survey 5",series_2: "Filter 1",question_id: 100,series_3: 2,value: 5},
  {series_1: "Survey 5",series_2: "Filter 1",question_id: 100,series_3: 3,value: 94},
  {series_1: "Survey 5",series_2: "Filter 1",question_id: 100,series_3: 4,value: 91},
  {series_1: "Survey 5",series_2: "Filter 1",question_id: 100,series_3: 5,value: 82},

  {series_1: "Survey 5",series_2: "Filter 2",question_id: 100,series_3: 1,value: 70},
  {series_1: "Survey 5",series_2: "Filter 2",question_id: 100,series_3: 2,value: 39},
  {series_1: "Survey 5",series_2: "Filter 2",question_id: 100,series_3: 3,value: 260},
  {series_1: "Survey 5",series_2: "Filter 2",question_id: 100,series_3: 4,value: 81},
  {series_1: "Survey 5",series_2: "Filter 2",question_id: 100,series_3: 5,value: 53},

  {series_1: "Survey 5",series_2: "Filter 3",question_id: 100,series_3: 1,value: 23},
  {series_1: "Survey 5",series_2: "Filter 3",question_id: 100,series_3: 2,value: 99},
  {series_1: "Survey 5",series_2: "Filter 3",question_id: 100,series_3: 3,value: 21},
  {series_1: "Survey 5",series_2: "Filter 3",question_id: 100,series_3: 4,value: 51},
  {series_1: "Survey 5",series_2: "Filter 3",question_id: 100,series_3: 5,value: 790}
]

apply_sample_data = ->
  chart.data(sample_data)
    .series_1_domain("Survey #{n}" for n in [1,2,3,4,5])
    .series_2_domain("Filter #{n}" for n in [1,2,3])
    .series_3_domain("#{n}" for n in [100])
    .min_value(1)
    .max_value(6)
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


