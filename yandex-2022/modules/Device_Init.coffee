

{ Device_Class } = require "Device_Class"

class exports.Device_Init extends Device_Class
	constructor: (@options={}) ->

		_.defaults @options,
			visible: @view.deviceConfig.enabled
			forceAndroidBar: @view.deviceConfig.force_AndroidBar
			statusBar: @view.deviceConfig.statusBar_theme
			homeBar: @view.deviceConfig.homeBar_theme
			
			prototypeCreationYear: @view.timeValue

			# getters
			statusBarView: null
			homeBarView: null
		
		super @options

		@createBars()



	# deprecated
	@define 'visible',
		get: -> if @options.visible then return 1 else return 0
		set: (value) -> @options.visible = value
	
	@define 'forceAndroidBar',
		get: -> @options.forceAndroidBar
		set: (value) -> @options.forceAndroidBar = value

	@define 'statusBar',
		get: -> @options.statusBar
		set: (value) -> @options.statusBar = value
	
	@define 'homeBar',
		get: -> @options.homeBar
		set: (value) -> @options.homeBar = value

	@define 'prototypeCreationYear',
		get: -> @options.prototypeCreationYear
		set: (value) -> @options.prototypeCreationYear = value





	@define 'statusBarView',
		get: -> @options.statusBarView
		set: (value) -> @options.statusBarView = value
	
	@define 'homeBarView',
		get: -> @options.homeBarView
		set: (value) -> @options.homeBarView = value



	viewSize: (w, h) => return @view.width == w and @view.height == h

	# Create Bars

	createBars: () =>
		@statusBarView = new Layer 
			parent: @view, width: @view.width, y: Align.top, name: ".status bar"
			opacity: @visible, backgroundColor: null
		
		if @forceAndroidBar
			@createClassicAndroidStatusBar(@statusBarView) 

		else if @viewSize(375, 812) or @viewSize(390, 844) or @viewSize(414, 896) or @viewSize(428, 926) or @viewSize(360, 782)
			@createNotchStatusBar(@statusBarView)
			@createHomeIndicator new Layer
				parent: @view, width: @view.width, height: 34, y: Align.bottom, name: ".home bar", opacity: @visible, backgroundColor: null
		
		else if @viewSize(393, 852)
			@createNotchStatusBar(@statusBarView)
			@createHomeIndicator new Layer
				parent: @view, width: @view.width, height: 34, y: Align.bottom, name: ".home bar", opacity: @visible, backgroundColor: null
		
		else if @viewSize(375, 667) or @viewSize(414, 736) or @viewSize(320, 568)
			@createClassicStatusBar(@statusBarView)
		
		
		else @createAndroidStatusBar(@statusBarView)
	
	
	
	



	createAndroidStatusBar: (barLayer) =>
		barLayer.height = 32
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 52, height: 20, x: Align.left(4), y: Align.top(2 + 5)
			color: device_assets.color[@statusBar], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: 20, x: Align.right(-4), y: Align.top(5)
			image: device_assets.androidStatusBarRightImage[@statusBar]
	
	
	createClassicAndroidStatusBar: (barLayer) =>
		barLayer.height = 20
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 52, height: 20, x: Align.left, y: Align.top(2)
			color: device_assets.color[@statusBar], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: 20, x: Align.right, y: Align.top()
			image: device_assets.androidStatusBarRightImage[@statusBar]
	
	



	createClassicStatusBar: (barLayer) =>
		barLayer.height = 20
		
		classicLeftComponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.left
			image: device_assets.oldStatusBarLeftImage[@statusBar]
		
		classicCenterComponent = new TextLayer
			parent: barLayer, width: 54, height: 16, x: Align.center, y: Align.center
			color: device_assets.color[@statusBar], backgroundColor: null
			fontSize: 12, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.right
			image: device_assets.oldStatusBarRightImage[@statusBar]
		
	
	createNotchStatusBar: (barLayer) =>
		barLayer.height = 44
		
		notchLeftComponent = new TextLayer
			parent: barLayer, width: 54, height: 21, x: Align.left(21), y: Align.top(12)
			color: device_assets.color[@statusBar], backgroundColor: null, letterSpacing: -0.17
			fontSize: 15, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		notchCenterComponent = new Layer
			parent: barLayer, width: 375, height: barLayer.height, x: Align.center
			image: device_assets.notch
		
		notchRightComponent = new Layer
			parent: barLayer, width: 100, height: barLayer.height, x: Align.right
			image: device_assets.statusBarRightImage[@statusBar]





	createHomeIndicator: (barLayer) =>
		@homeBarView = new Layer
			name: ".homeView"
			parent: barLayer, width: 135, height: 5, x: Align.center, y: Align.bottom(-8)
			backgroundColor: device_assets.color[@homeBar], borderRadius: 20
	



device_assets =
	color:
		dark: "#000"
		light: "#FFF"
	
	statusBarRightImage:
		dark: "modules/PreviewComponentAssets/statusBar_right_dark.png"
		light: "modules/PreviewComponentAssets/statusBar_right_light.png"
	oldStatusBarLeftImage:
		dark: "modules/PreviewComponentAssets/oldStatusBar_left_dark.png"
		light: "modules/PreviewComponentAssets/oldStatusBar_left_light.png"
	oldStatusBarRightImage:
		dark: "modules/PreviewComponentAssets/oldStatusBar_right_dark.png"
		light: "modules/PreviewComponentAssets/oldStatusBar_right_light.png"
	androidStatusBarRightImage:
		dark: "modules/PreviewComponentAssets/androidStatusBar_right_dark.png"
		light: "modules/PreviewComponentAssets/androidStatusBar_right_light.png"
	


	notch: "modules/PreviewComponentAssets/statusBar_notch.png"
	tip: "modules/PreviewComponentAssets/tip.png"