

{DeviceView} = require "DeviceView"


class exports.LocationView extends DeviceView
	constructor: (@options={}) ->

		_.defaults @options,
			initState: "fill" # fill / normal
			showButton: true
			showLogo: true
			forceDesktop: false

		
		super @options

		@scalePreview()


	@define 'initState',
		get: -> @options.initState
		set: (value) -> @options.initState = value
	
	@define 'showButton',
		get: -> @options.showButton
		set: (value) -> @options.showButton = value
	
	@define 'showLogo',
		get: -> @options.showLogo
		set: (value) -> @options.showLogo = value

	@define 'forceDesktop',
		get: -> @options.forceDesktop
		set: (value) ->
			@options.forceDesktop = value
			if value
				@showDevice = false
				@showBars = false
				@borderRadius = 8
	
	
	scalePreview: () =>
		forceDesktopMode = @getStateGeneric("desktop", [{ value: "false", result: false },
														{ value: "true", result: true }], false)

		if forceDesktopMode then @previewDesktop()
		else if Utils.isMobile() then @previewMobile()
		else @previewDesktop()
			
		
	

	updateScale: () =>

		scaleFactor = Screen.width / Canvas.width

		@originX = 0
		@originY = 0

		scaleX = (Screen.width - scaleFactor * 112) / @width
		scaleY = (Screen.height - scaleFactor * 112) / @height
		@states["fill"].scale = Math.min(scaleX, scaleY)

		@states["fill"].x = (Screen.width - @width * @states["fill"].scale) / 2
		@states["fill"].y = (Screen.height - @height * @states["fill"].scale) / 2

		@states["normal"].x = (Screen.width - @width) / 2
		@states["normal"].y = (Screen.height - @height) / 2

	




	setDesktopScaleMode: () =>

		forState = @getStateGeneric("scale", [{ value: "fill", result: "fill" },
												{ value: "normal", result: "normal" },
												{ value: "true", result: "fill" }], @initState)

		shouldShowButton = @getStateGeneric("button", [{ value: "false", result: false },
														{ value: "off", result: false }], @showButton)

		shouldShowLogo = @getStateGeneric("logo", [{ value: "false", result: false },
													{ value: "off", result: false }], @showLogo)
												
		shouldShowDevice = @getStateGeneric("device", [{ value: "false", result: false },
													{ value: "off", result: false }
													{ value: "true", result: true }], @showDevice)

		
		if shouldShowLogo then @createLogoButton()
		if shouldShowButton then @createScaleButton(forState)
		if shouldShowDevice then @showBorderView() else @hideBorderView()
		@stateSwitch(forState)
	
	
	
	previewDesktop: () =>
		@updateScale()
		@setDesktopScaleMode()
		@createBars()
		@clip = true
		@updatePreviewOnResize()


	updatePreviewOnResize: () =>
		localPreview = @
		
		Canvas.on "change:height", =>
			localPreview.updateScale()
			localPreview.stateSwitch(localPreview.states.current.name)
		
		Canvas.on "change:width", =>
			localPreview.updateScale()
			localPreview.stateSwitch(localPreview.states.current.name)
		

		Screen.on "change:height", =>
			localPreview.updateScale()
			localPreview.stateSwitch(localPreview.states.current.name)
		
		Screen.on "change:width", =>
			localPreview.updateScale()
			localPreview.stateSwitch(localPreview.states.current.name)
	
	
	
	
	
	
	
	previewMobile: () =>

		@scale = Screen.width / @width
		@originX = 0
		@originY = 0
	
	

	setCustomPreview: () =>
		@y = Align.top
		
		@scale = (Screen.height - 120) / @height
		@borderRadius = 20
		@clip = true




	# getStateGeneric: (key = "scale", pairs = [{ value: , result: }, {value: , result: }], defaultResult = "")
	getStateGeneric: (stateKey = "scale", statePairs = [], defaultResult = "") =>
		result = defaultResult

		for item in location.search[1..].split('&')
			keyValuePair = item.split("=")
			keyPart = keyValuePair[0]
			valuePart = keyValuePair[1]

			if keyPart == stateKey
				for pair in statePairs
					if valuePart == pair.value
						# print "ok " + " #{pair.value}" 
						result = pair.result
					# else
						# print "not " + " #{pair.value}" 
		
		return result
	
	
	
	
