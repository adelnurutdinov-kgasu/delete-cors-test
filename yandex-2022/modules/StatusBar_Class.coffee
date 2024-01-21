

class exports.StatusBar_Class extends Layer
	constructor: (@options={}) ->

		_.defaults @options,
			parent: @view
			width: @view.width

			y: Align.top, name: ".status bar", backgroundColor: null

			theme: @view.statusBar_theme
			forceAndroid: @view.forceAndroidBar
			prototypeCreationYear: @view.timeValue
		
		super @options

		@create()





	@define 'view',
		get: -> @options.view
		set: (value) -> @options.view = value
	
	@define 'theme',
		get: -> @options.theme
		set: (value) -> @options.theme = value
	
	@define 'forceAndroid',
		get: -> @options.forceAndroid
		set: (value) -> @options.forceAndroid = value

	@define 'prototypeCreationYear',
		get: -> @options.prototypeCreationYear
		set: (value) -> @options.prototypeCreationYear = value




	viewSize: (w, h) => return @view.width == w and @view.height == h

	create: () =>
		
		if @forceAndroid then @createClassicAndroidStatusBar() 

		else if @viewSize(375, 812) or @viewSize(390, 844) or @viewSize(414, 896) or @viewSize(428, 926) or @viewSize(360, 782)
			@createNotchStatusBar()
		
		else if @viewSize(393, 852)
			@createNotchStatusBar()
		
		else if @viewSize(375, 667) or @viewSize(414, 736) or @viewSize(320, 568)
			@createClassicStatusBar()
		
		
		else @createAndroidStatusBar()
	
	
	
	



	createAndroidStatusBar: () =>
		@height = 32
		
		classicCenterComponent = new TextLayer
			parent: @, width: 52, height: 20, x: Align.left(4), y: Align.top(2 + 5)
			color: device_assets.color[@theme], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: @, width: 100, height: 20, x: Align.right(-4), y: Align.top(5)
			image: device_assets.androidStatusBarRightImage[@theme]
	
	
	createClassicAndroidStatusBar: () =>
		@height = 20
		
		classicCenterComponent = new TextLayer
			parent: @, width: 52, height: 20, x: Align.left, y: Align.top(2)
			color: device_assets.color[@theme], backgroundColor: null
			fontSize: 14, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: @, width: 100, height: 20, x: Align.right, y: Align.top()
			image: device_assets.androidStatusBarRightImage[@theme]
	
	



	createClassicStatusBar: () =>
		@height = 20
		
		classicLeftComponent = new Layer
			parent: @, width: 100, height: @height, x: Align.left
			image: device_assets.oldStatusBarLeftImage[@theme]
		
		classicCenterComponent = new TextLayer
			parent: @, width: 54, height: 16, x: Align.center, y: Align.center
			color: device_assets.color[@theme], backgroundColor: null
			fontSize: 12, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		classicRightomponent = new Layer
			parent: @, width: 100, height: @height, x: Align.right
			image: device_assets.oldStatusBarRightImage[@theme]
		
	
	createNotchStatusBar: () =>
		@height = 44
		
		notchLeftComponent = new TextLayer
			parent: @, width: 54, height: 21, x: Align.left(21), y: Align.top(12)
			color: device_assets.color[@theme], backgroundColor: null, letterSpacing: -0.17
			fontSize: 15, fontWeight: 600, textAlign: "center", fontFamily: ".system, SF Pro Text"
			text: @prototypeCreationYear
		
		notchCenterComponent = new Layer
			parent: @, width: 375, height: @height, x: Align.center
			image: device_assets.notch
		
		notchRightComponent = new Layer
			parent: @, width: 100, height: @height, x: Align.right
			image: device_assets.statusBarRightImage[@theme]




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