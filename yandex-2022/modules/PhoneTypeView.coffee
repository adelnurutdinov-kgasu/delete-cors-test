

{InitView} = require "InitView"

overrideTimeValue = "20:21"

class exports.PhoneTypeView extends InitView
	constructor: (@options={}) ->

		_.defaults @options,
			statusBar: "dark" # light/dark
			homeBar: "dark" # light/dark

			visible: true # true / false
			forceAndroidBar: false # true / false

			# override with care
			prototypeCreationYear: overrideTimeValue

			# getters
			statusBarView: null
			homeBarView: null
			
		
		super @options
	


	@define 'statusBar',
		get: -> @options.statusBar
		set: (value) -> @options.statusBar = value
	
	@define 'homeBar',
		get: -> @options.homeBar
		set: (value) -> @options.homeBar = value

	@define 'forceAndroidBar',
		get: -> @options.forceAndroidBar
		set: (value) -> @options.forceAndroidBar = value
	

	@define 'showBars',
		get: -> if @options.visible then return 1 else return 0
		set: (value) -> @options.visible = value

	# deprecated
	@define 'visible',
		get: -> if @options.visible then return 1 else return 0
		set: (value) -> @options.visible = value
	


	@define 'prototypeCreationYear',
		get: -> @options.prototypeCreationYear
		set: (value) -> @options.prototypeCreationYear = value



	@define 'statusBarView',
		get: -> @options.statusBarView
		set: (value) -> @options.statusBarView = value
	
	@define 'homeBarView',
		get: -> @options.homeBarView
		set: (value) -> @options.homeBarView = value




	# Create Bars

	createBars: () =>
		@statusBarView = new Layer 
			parent: @, width: @width, y: Align.top, name: ".status bar"
			opacity: @visible, backgroundColor: null
		
		if @forceAndroidBar
			@createClassicAndroidStatusBar(@statusBarView) 

		else if @viewSize(375, 812) or @viewSize(390, 844) or @viewSize(414, 896) or @viewSize(428, 926) or @viewSize(360, 782)
			@createNotchStatusBar(@statusBarView)
			@createHomeIndicator new Layer
				parent: @, width: @width, height: 34, y: Align.bottom, name: ".home bar", opacity: @visible, backgroundColor: null
		
		else if @viewSize(393, 852)
			print "ok"
			@createNotchStatusBar(@statusBarView)
			@createHomeIndicator new Layer
				parent: @, width: @width, height: 34, y: Align.bottom, name: ".home bar", opacity: @visible, backgroundColor: null
		
		else if @viewSize(375, 667) or @viewSize(414, 736) or @viewSize(320, 568)
			@createClassicStatusBar(@statusBarView)
		
		
		else @createAndroidStatusBar(@statusBarView)
	
	
	
	



	createAndroidStatusBar: (barLayer) =>
		barLayer.height = 32
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 52, height: 20, x: Align.left(4), y: Align.top(2 + 5)
			color: @assets.color[@statusBar], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: 20, x: Align.right(-4), y: Align.top(5)
			image: @assets.androidStatusBarRightImage[@statusBar]
	
	
	createClassicAndroidStatusBar: (barLayer) =>
		barLayer.height = 20
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 52, height: 20, x: Align.left, y: Align.top(2)
			color: @assets.color[@statusBar], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: 20, x: Align.right, y: Align.top()
			image: @assets.androidStatusBarRightImage[@statusBar]
	
	



	createClassicStatusBar: (barLayer) =>
		barLayer.height = 20
		
		classicLeftComponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.left
			image: @assets.oldStatusBarLeftImage[@statusBar]
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 54, height: 16, x: Align.center, y: Align.center
			color: @assets.color[@statusBar], backgroundColor: null
			fontSize: 12, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.right
			image: @assets.oldStatusBarRightImage[@statusBar]
		
	
	createNotchStatusBar: (barLayer) =>
		barLayer.height = 44
		
		notchLeftComponent = new TextLayer
			parent: barLayer, width: 54, height: 21, x: Align.left(21), y: Align.top(12)
			color: @assets.color[@statusBar], backgroundColor: null, letterSpacing: -0.17
			fontSize: 15, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		notchCenterComponent = new Layer
			parent: barLayer, width: 375, height: barLayer.height, x: Align.center
			image: @assets.notch
		
		notchRightComponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.right
			image: @assets.statusBarRightImage[@statusBar]
	
	
	



	createHomeIndicator: (barLayer) =>
		@homeBarView = new Layer
			name: ".homeView"
			parent: barLayer, width: 135, height: 5, x: Align.center, y: Align.bottom(-8)
			backgroundColor: @assets.color[@homeBar], borderRadius: 20
	
	