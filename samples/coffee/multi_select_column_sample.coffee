buttons = d3.select('body').append('div')
  .attr('id', 'buttons')


data = [
  { series_1: "Survey A", series_2: "all", series_3: 1, value: 101 }
  { series_1: "Survey A", series_2: "all", series_3: 2, value: 50 }
  { series_1: "Survey A", series_2: "all", series_3: 3, value: 60 }
  { series_1: "Survey A", series_2: "all", series_3: 4, value: 180 }
  { series_1: "Survey A", series_2: "all", series_3: 5, value: 300 }
  { series_1: "Survey A", series_2: "all", series_3: 6, value: 105 }

  { series_1: "Survey B", series_2: "all", series_3: 1, value: 300 }
  { series_1: "Survey B", series_2: "all", series_3: 2, value: 190 }
  { series_1: "Survey B", series_2: "all", series_3: 3, value: 400 }
  { series_1: "Survey B", series_2: "all", series_3: 4, value: 90 }
  { series_1: "Survey B", series_2: "all", series_3: 5, value: 50 }
  { series_1: "Survey B", series_2: "all", series_3: 6, value: 100 }

  { series_1: "Survey C", series_2: "all", series_3: 1, value: 100 }
  { series_1: "Survey C", series_2: "all", series_3: 2, value: 100 }
  { series_1: "Survey C", series_2: "all", series_3: 3, value: 100 }
  { series_1: "Survey C", series_2: "all", series_3: 4, value: 100 }
  { series_1: "Survey C", series_2: "all", series_3: 5, value: 100 }
  { series_1: "Survey C", series_2: "all", series_3: 6, value: 100 }
]

#n_values = [
#  { series_1: "Survey A", series_2: "all", n: 450 }
#  { series_1: "Survey B", series_2: "all", n: 515 }
#  { series_1: "Survey C", series_2: "all", n: 250 }
#]
#

n_values = {
  "Survey A": { "all": 1050 }
  "Survey B": { "all": 515 }
  "Survey C": { "all": 250 }
}

chart = new ZVG.Column
chart.data(data)
chart.series_1_domain(["Survey A", "Survey B", "Survey C"])
chart.series_2_domain(["all"])
chart.series_3_domain("#{n}" for n in [1, 2, 3, 4, 5, 6])
chart.override_n_values(n_values)
chart.render()


buttons.append('button')
  .text('randomize')
  .on('click', => 
    chart.randomizeData())
buttons.append('button')
  .text('standard sample data')
  .on('click', =>
    chart.series_1_domain("Survey #{n}" for n in [3,2,1])
    chart.series_2_domain("Filter #{n}" for n in [1,2,3,4])
    chart.series_3_domain("#{n}" for n in [1,2])
    chart.data(chart.sample_data)
    chart.render(chart.renderMode)
  )
buttons.append('button')
  .text('show percentages')
  .on('click', => chart.render('percentage'))
buttons.append('button')
  .text('show counts')
  .on('click', => chart.render('count'))


window.chart = chart
