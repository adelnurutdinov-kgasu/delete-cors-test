

{Preview_Class} = require "Preview_Class"
{Device_Class} = require "Device_Class"

{HomeBar_Class} = require "HomeBar_Class"
{StatusBar_Class} = require "StatusBar_Class"

class exports.Preview_Init extends Preview_Class
	constructor: (@options={}) ->
		super @options

		@scalePreview()

	
	
	scalePreview: () =>
		if Utils.isMobile() then @previewMobile()
		else @previewDesktop()
	
	updatePreview: () =>
		if @stateGuard.states.current.name == "fill" then @stateSwitchToFill()
		else @stateSwitchToNormal()

		# if @borderView
		# 	if @scaleState == "fill" then @borderView.stateSwitchToFill()
		# 	else @borderView.stateSwitchToNormal()
	



	previewDesktop: () =>
		if @showDevice then @borderView = new Device_Class { view: @ }

		if @showHints then Framer.Extras.Hints.enable()
		else Framer.Extras.Hints.disable()

		if @showBars
			if @showHomeBar then @homeBarView = new HomeBar_Class { view: @ }
			if @showStatusBar then @statusBarView = new StatusBar_Class { view: @ }

		@clip = true
		@updateScale()
		@updatePreviewOnResize()
		
		if @scaleState == "fill" then @stateSwitchToFill()
		else @stateSwitchToNormal()

	
	previewMobile: () =>
		Framer.Extras.Hints.disable()
		
		@scale = Screen.width / @width
		@x = Align.center
		@y = Align.center

	

	updateScale: () =>

		@x = Align.center
		@y = Align.center

		if @borderView
			@borderView.x = Align.center
			@borderView.y = Align.center

		scaleX = (Screen.width - 112) / @width
		scaleY = (Screen.height - 112) / @height
		@states["fill"].scale = Math.min(scaleX, scaleY)

		if @borderView
			@borderView.states["fill"].scale = @states["fill"].scale








	updatePreviewOnResize: () =>
		localPreview = @
		
		Canvas.on "change:height", =>
			localPreview.updateScale()
			localPreview.updatePreview()
		
		Canvas.on "change:width", =>
			localPreview.updateScale()
			localPreview.updatePreview()
		

		Screen.on "change:height", =>
			localPreview.updateScale()
			localPreview.updatePreview()
		
		Screen.on "change:width", =>
			localPreview.updateScale()
			localPreview.updatePreview()
	
	


