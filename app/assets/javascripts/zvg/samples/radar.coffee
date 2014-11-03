window.radar = new ZVG.Radar('body')

### Data format has changed!
window.simpleTestData = [
  # Single survey, single filter, 5 questions
  { series_1: 'Survey 1', series_2: 'all', question_id: 100, value: 4.5 }
  { series_1: 'Survey 1', series_2: 'all', question_id: 200, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'all', question_id: 300, value: 4.1 }
  { series_1: 'Survey 1', series_2: 'all', question_id: 400, value: 2.8 }
  { series_1: 'Survey 1', series_2: 'all', question_id: 500, value: 2.1 }
  
  { series_1: 'Survey 1', series_2: 'Filter 2', question_id: 100, value: 3.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', question_id: 200, value: 1.5 }
  { series_1: 'Survey 1', series_2: 'Filter 2', question_id: 300, value: 2.1 }
  { series_1: 'Survey 1', series_2: 'Filter 2', question_id: 400, value: 3.8 }
  { series_1: 'Survey 1', series_2: 'Filter 2', question_id: 500, value: 3.1 }
]

window.moreComplexData = [
  {series_1: 'Survey 1',series_2: "Filter 1", question_id: 100, value: 3.4941219999454916},
  {series_1: 'Survey 1',series_2: "Filter 1", question_id: 200, value: 1.9292143830098212},
  {series_1: 'Survey 1',series_2: "Filter 1", question_id: 300, value: 2.713041902985424},
  {series_1: 'Survey 1',series_2: "Filter 1", question_id: 400, value: 1.5061968080699444},
  {series_1: 'Survey 1',series_2: "Filter 1", question_id: 500, value: 5.406578453723341},
  {series_1: 'Survey 1',series_2: "Filter 2", question_id: 100, value: 4.2298069428652525},
  {series_1: 'Survey 1',series_2: "Filter 2", question_id: 200, value: 5.5519170253537595},
  {series_1: 'Survey 1',series_2: "Filter 2", question_id: 300, value: 0.2769786645658314},
  {series_1: 'Survey 1',series_2: "Filter 2", question_id: 400, value: 1.6917675621807575},
  {series_1: 'Survey 1',series_2: "Filter 2", question_id: 500, value: 0.619645903352648},
  {series_1: 'Survey 1',series_2: "Filter 3", question_id: 100, value: 4.02297692745924},
  {series_1: 'Survey 1',series_2: "Filter 3", question_id: 200, value: 2.8029478769749403},
  {series_1: 'Survey 1',series_2: "Filter 3", question_id: 300, value: 0.9199619614519179},
  {series_1: 'Survey 1',series_2: "Filter 3", question_id: 400, value: 2.8409991916269064},
  {series_1: 'Survey 1',series_2: "Filter 3", question_id: 500, value: 4.59977040393278}
]
###
#

window.moreComplexData = [
  {"series_1":"SurveyA","series_2":"FilterA","series_3":1,"question_id":100,"count":292}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":2,"question_id":100,"count":146}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":3,"question_id":100,"count":91}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":4,"question_id":100,"count":190}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":5,"question_id":100,"count":180}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":1,"question_id":200,"count":142}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":2,"question_id":200,"count":95}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":3,"question_id":200,"count":158}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":4,"question_id":200,"count":215}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":5,"question_id":200,"count":146}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":1,"question_id":300,"count":150}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":2,"question_id":300,"count":260}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":3,"question_id":300,"count":220}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":4,"question_id":300,"count":113}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":5,"question_id":300,"count":280}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":1,"question_id":400,"count":164}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":2,"question_id":400,"count":185}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":3,"question_id":400,"count":52}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":4,"question_id":400,"count":186}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":5,"question_id":400,"count":89}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":1,"question_id":500,"count":177}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":2,"question_id":500,"count":213}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":3,"question_id":500,"count":99}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":4,"question_id":500,"count":149}
  {"series_1":"SurveyA","series_2":"FilterA","series_3":5,"question_id":500,"count":82}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":1,"question_id":100,"count":266}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":2,"question_id":100,"count":176}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":3,"question_id":100,"count":183}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":4,"question_id":100,"count":122}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":5,"question_id":100,"count":35}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":1,"question_id":200,"count":241}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":2,"question_id":200,"count":266}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":3,"question_id":200,"count":77}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":4,"question_id":200,"count":199}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":5,"question_id":200,"count":99}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":1,"question_id":300,"count":141}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":2,"question_id":300,"count":240}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":3,"question_id":300,"count":241}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":4,"question_id":300,"count":154}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":5,"question_id":300,"count":218}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":1,"question_id":400,"count":40}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":2,"question_id":400,"count":235}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":3,"question_id":400,"count":165}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":4,"question_id":400,"count":183}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":5,"question_id":400,"count":259}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":1,"question_id":500,"count":230}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":2,"question_id":500,"count":83}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":3,"question_id":500,"count":226}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":4,"question_id":500,"count":163}
  {"series_1":"SurveyA","series_2":"FilterB","series_3":5,"question_id":500,"count":19}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":1,"question_id":100,"count":172}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":2,"question_id":100,"count":145}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":3,"question_id":100,"count":271}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":4,"question_id":100,"count":154}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":5,"question_id":100,"count":105}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":1,"question_id":200,"count":134}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":2,"question_id":200,"count":128}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":3,"question_id":200,"count":204}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":4,"question_id":200,"count":155}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":5,"question_id":200,"count":203}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":1,"question_id":300,"count":204}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":2,"question_id":300,"count":128}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":3,"question_id":300,"count":157}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":4,"question_id":300,"count":107}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":5,"question_id":300,"count":228}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":1,"question_id":400,"count":252}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":2,"question_id":400,"count":208}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":3,"question_id":400,"count":107}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":4,"question_id":400,"count":87}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":5,"question_id":400,"count":155}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":1,"question_id":500,"count":213}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":2,"question_id":500,"count":87}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":3,"question_id":500,"count":213}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":4,"question_id":500,"count":96}
  {"series_1":"SurveyA","series_2":"FilterC","series_3":5,"question_id":500,"count":97}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":1,"question_id":100,"count":19}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":2,"question_id":100,"count":138}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":3,"question_id":100,"count":120}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":4,"question_id":100,"count":97}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":5,"question_id":100,"count":110}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":1,"question_id":200,"count":116}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":2,"question_id":200,"count":150}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":3,"question_id":200,"count":93}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":4,"question_id":200,"count":230}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":5,"question_id":200,"count":168}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":1,"question_id":300,"count":56}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":2,"question_id":300,"count":70}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":3,"question_id":300,"count":122}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":4,"question_id":300,"count":194}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":5,"question_id":300,"count":167}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":1,"question_id":400,"count":124}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":2,"question_id":400,"count":212}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":3,"question_id":400,"count":176}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":4,"question_id":400,"count":218}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":5,"question_id":400,"count":139}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":1,"question_id":500,"count":114}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":2,"question_id":500,"count":58}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":3,"question_id":500,"count":191}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":4,"question_id":500,"count":278}
  {"series_1":"SurveyB","series_2":"FilterA","series_3":5,"question_id":500,"count":259}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":1,"question_id":100,"count":126}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":2,"question_id":100,"count":211}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":3,"question_id":100,"count":83}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":4,"question_id":100,"count":89}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":5,"question_id":100,"count":115}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":1,"question_id":200,"count":237}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":2,"question_id":200,"count":216}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":3,"question_id":200,"count":107}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":4,"question_id":200,"count":167}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":5,"question_id":200,"count":203}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":1,"question_id":300,"count":114}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":2,"question_id":300,"count":70}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":3,"question_id":300,"count":111}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":4,"question_id":300,"count":128}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":5,"question_id":300,"count":102}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":1,"question_id":400,"count":187}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":2,"question_id":400,"count":105}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":3,"question_id":400,"count":66}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":4,"question_id":400,"count":148}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":5,"question_id":400,"count":180}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":1,"question_id":500,"count":116}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":2,"question_id":500,"count":95}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":3,"question_id":500,"count":147}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":4,"question_id":500,"count":260}
  {"series_1":"SurveyB","series_2":"FilterB","series_3":5,"question_id":500,"count":171}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":1,"question_id":100,"count":65}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":2,"question_id":100,"count":29}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":3,"question_id":100,"count":101}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":4,"question_id":100,"count":260}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":5,"question_id":100,"count":42}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":1,"question_id":200,"count":184}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":2,"question_id":200,"count":112}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":3,"question_id":200,"count":80}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":4,"question_id":200,"count":199}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":5,"question_id":200,"count":228}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":1,"question_id":300,"count":235}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":2,"question_id":300,"count":122}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":3,"question_id":300,"count":116}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":4,"question_id":300,"count":175}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":5,"question_id":300,"count":196}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":1,"question_id":400,"count":204}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":2,"question_id":400,"count":53}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":3,"question_id":400,"count":35}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":4,"question_id":400,"count":89}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":5,"question_id":400,"count":165}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":1,"question_id":500,"count":36}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":2,"question_id":500,"count":225}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":3,"question_id":500,"count":86}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":4,"question_id":500,"count":99}
  {"series_1":"SurveyB","series_2":"FilterC","series_3":5,"question_id":500,"count":85}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":1,"question_id":100,"count":244}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":2,"question_id":100,"count":112}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":3,"question_id":100,"count":82}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":4,"question_id":100,"count":190}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":5,"question_id":100,"count":240}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":1,"question_id":200,"count":140}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":2,"question_id":200,"count":164}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":3,"question_id":200,"count":218}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":4,"question_id":200,"count":171}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":5,"question_id":200,"count":112}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":1,"question_id":300,"count":124}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":2,"question_id":300,"count":244}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":3,"question_id":300,"count":113}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":4,"question_id":300,"count":83}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":5,"question_id":300,"count":251}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":1,"question_id":400,"count":152}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":2,"question_id":400,"count":20}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":3,"question_id":400,"count":62}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":4,"question_id":400,"count":62}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":5,"question_id":400,"count":219}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":1,"question_id":500,"count":165}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":2,"question_id":500,"count":231}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":3,"question_id":500,"count":262}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":4,"question_id":500,"count":142}
  {"series_1":"SurveyC","series_2":"FilterA","series_3":5,"question_id":500,"count":157}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":1,"question_id":100,"count":211}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":2,"question_id":100,"count":242}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":3,"question_id":100,"count":174}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":4,"question_id":100,"count":60}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":5,"question_id":100,"count":192}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":1,"question_id":200,"count":143}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":2,"question_id":200,"count":276}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":3,"question_id":200,"count":184}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":4,"question_id":200,"count":191}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":5,"question_id":200,"count":90}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":1,"question_id":300,"count":262}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":2,"question_id":300,"count":62}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":3,"question_id":300,"count":39}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":4,"question_id":300,"count":272}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":5,"question_id":300,"count":250}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":1,"question_id":400,"count":46}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":2,"question_id":400,"count":153}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":3,"question_id":400,"count":155}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":4,"question_id":400,"count":192}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":5,"question_id":400,"count":150}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":1,"question_id":500,"count":55}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":2,"question_id":500,"count":251}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":3,"question_id":500,"count":120}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":4,"question_id":500,"count":190}
  {"series_1":"SurveyC","series_2":"FilterB","series_3":5,"question_id":500,"count":166}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":1,"question_id":100,"count":158}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":2,"question_id":100,"count":241}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":3,"question_id":100,"count":220}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":4,"question_id":100,"count":167}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":5,"question_id":100,"count":67}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":1,"question_id":200,"count":162}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":2,"question_id":200,"count":166}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":3,"question_id":200,"count":261}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":4,"question_id":200,"count":119}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":5,"question_id":200,"count":69}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":1,"question_id":300,"count":150}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":2,"question_id":300,"count":135}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":3,"question_id":300,"count":148}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":4,"question_id":300,"count":113}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":5,"question_id":300,"count":292}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":1,"question_id":400,"count":169}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":2,"question_id":400,"count":217}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":3,"question_id":400,"count":115}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":4,"question_id":400,"count":117}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":5,"question_id":400,"count":111}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":1,"question_id":500,"count":210}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":2,"question_id":500,"count":93}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":3,"question_id":500,"count":77}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":4,"question_id":500,"count":120}
  {"series_1":"SurveyC","series_2":"FilterC","series_3":5,"question_id":500,"count":119}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":1,"question_id":100,"count":136}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":2,"question_id":100,"count":152}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":3,"question_id":100,"count":119}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":4,"question_id":100,"count":97}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":5,"question_id":100,"count":265}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":1,"question_id":200,"count":150}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":2,"question_id":200,"count":184}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":3,"question_id":200,"count":61}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":4,"question_id":200,"count":249}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":5,"question_id":200,"count":212}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":1,"question_id":300,"count":123}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":2,"question_id":300,"count":66}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":3,"question_id":300,"count":51}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":4,"question_id":300,"count":192}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":5,"question_id":300,"count":198}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":1,"question_id":400,"count":180}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":2,"question_id":400,"count":127}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":3,"question_id":400,"count":150}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":4,"question_id":400,"count":113}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":5,"question_id":400,"count":88}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":1,"question_id":500,"count":177}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":2,"question_id":500,"count":136}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":3,"question_id":500,"count":158}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":4,"question_id":500,"count":151}
  {"series_1":"SurveyD","series_2":"FilterA","series_3":5,"question_id":500,"count":172}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":1,"question_id":100,"count":38}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":2,"question_id":100,"count":243}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":3,"question_id":100,"count":163}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":4,"question_id":100,"count":177}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":5,"question_id":100,"count":107}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":1,"question_id":200,"count":274}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":2,"question_id":200,"count":176}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":3,"question_id":200,"count":90}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":4,"question_id":200,"count":256}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":5,"question_id":200,"count":103}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":1,"question_id":300,"count":182}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":2,"question_id":300,"count":257}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":3,"question_id":300,"count":137}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":4,"question_id":300,"count":187}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":5,"question_id":300,"count":132}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":1,"question_id":400,"count":151}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":2,"question_id":400,"count":233}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":3,"question_id":400,"count":52}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":4,"question_id":400,"count":165}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":5,"question_id":400,"count":186}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":1,"question_id":500,"count":121}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":2,"question_id":500,"count":187}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":3,"question_id":500,"count":69}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":4,"question_id":500,"count":99}
  {"series_1":"SurveyD","series_2":"FilterB","series_3":5,"question_id":500,"count":70}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":1,"question_id":100,"count":78}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":2,"question_id":100,"count":133}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":3,"question_id":100,"count":285}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":4,"question_id":100,"count":71}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":5,"question_id":100,"count":117}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":1,"question_id":200,"count":45}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":2,"question_id":200,"count":73}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":3,"question_id":200,"count":154}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":4,"question_id":200,"count":140}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":5,"question_id":200,"count":154}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":1,"question_id":300,"count":259}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":2,"question_id":300,"count":95}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":3,"question_id":300,"count":206}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":4,"question_id":300,"count":218}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":5,"question_id":300,"count":241}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":1,"question_id":400,"count":188}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":2,"question_id":400,"count":258}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":3,"question_id":400,"count":193}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":4,"question_id":400,"count":160}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":5,"question_id":400,"count":240}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":1,"question_id":500,"count":131}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":2,"question_id":500,"count":96}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":3,"question_id":500,"count":222}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":4,"question_id":500,"count":66}
  {"series_1":"SurveyD","series_2":"FilterC","series_3":5,"question_id":500,"count":66}
]

radar.series_1_domain(['Survey 1'])
radar.series_2_domain("Filter #{n}" for n in [1..3])
radar.series_3_domain("#{n}" for n in [100, 200, 300, 400, 500])
radar.data(moreComplexData)
radar.maxRadius(6)
radar.setFilter('Filter 1')
radar.render()

