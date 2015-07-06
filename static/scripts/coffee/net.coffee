cytoscape = require 'cytoscape'
data1 =
  data:
    id: 'j'
    name: 'Jerry'
    weight: '65'
    faveColor: '#6FB1FC'
    faveShape: 'triangle'
data2 =
  data:
    id: 'e'
    name: 'Elaine'
    weight: '45'
    faveColor: '#EDA1ED'
    faveShape: 'ellipse'
data3 =
  data:
    id: 'k'
    name: 'Kramer'
    weight: '70'
    faveColor: '#86B342'
    faveShape: 'octagon'
cy = cytoscape
  container: document.getElementById 'cy'
  elements:
    nodes: [
      { data: { id: 'j', name: 'Jerry', weight: 65, faveColor: '#6FB1FC', faveShape: 'triangle' } },
      { data: { id: 'e', name: 'Elaine', weight: 45, faveColor: '#EDA1ED', faveShape: 'ellipse' } },
      { data: { id: 'k', name: 'Kramer', weight: 75, faveColor: '#86B342', faveShape: 'octagon' } },
      { data: { id: 'g', name: 'George', weight: 70, faveColor: '#F5A45D', faveShape: 'rectangle' } }
    ]
    edges:[
      { data: { source: 'j', target: 'e', faveColor: '#6FB1FC', strength: 90 } },
      { data: { source: 'j', target: 'k', faveColor: '#6FB1FC', strength: 70 } },
      { data: { source: 'j', target: 'g', faveColor: '#6FB1FC', strength: 80 } },
      { data: { source: 'e', target: 'j', faveColor: '#EDA1ED', strength: 95 } },
      { data: { source: 'e', target: 'k', faveColor: '#EDA1ED', strength: 60 }, classes: 'questionable' },
      { data: { source: 'k', target: 'j', faveColor: '#86B342', strength: 100 } },
      { data: { source: 'k', target: 'e', faveColor: '#86B342', strength: 100 } },
      { data: { source: 'k', target: 'g', faveColor: '#86B342', strength: 100 } },
      { data: { source: 'g', target: 'j', faveColor: '#F5A45D', strength: 90 } }
    ]

  zoom: 1
  pan:
    x: 0
    y: 0


  minZoom: 1e-50
  maxZoom: 1e50
  zoomingEnabled: true
  userZoomingEnabled: true
  panningEnabled: true
  userPanningEnabled: true
  boxSelectionEnabled: false
  selectionType: (isTouchDevice ? 'additive' : 'single')
  touchTapThreshold: 8
  desktopTapThreshold: 4
  autolock: false
  autoungrabify: false
  autounselectify: false

  # rendering options:
  headless: false
  styleEnabled: true
  hideEdgesOnViewport: false
  hideLabelsOnViewport: false
  textureOnViewport: false
  motionBlur: false
  motionBlurOpacity: 0.2
  wheelSensitivity: 1
  pixelRatio: 1
  initrender: ->
  renderer: {}
  ready: (evt)->
    window.cy = @
    console.log evt
    console.log  'jkl'
cy.layout
  name: 'preset'
cy.nodes
  positions: (idx, node)->
    console.log idx, node
