

overrideTimeValue = "20:21"

class exports.Preview_Class extends Layer
	constructor: (@options={}) ->

		stateGuardLayer = new Layer { opacity: 0, size: 1 }
		stateGuardLayer.states =
			"normal": { scale: 1 }
			"fill": { scale: 1 }
		stateGuardLayer.stateSwitch("fill")

		_.defaults @options,
			name: "Preview"
			backgroundColor: null
			borderRadius: 42

			stateGuard: stateGuardLayer
			view: null

			borderView: null
			statusBarView: null
			homeBarView: null

			configView: null
			sectionView: null
			


			# Device
			showDevice: true

			# Bars
			showBars: true
			showStatusBar: true
			showHomeBar: true

			timeValue: overrideTimeValue # no override
			forceAndroidBar: false
			statusBar_theme: "dark"
			homeBar_theme: "dark"

			# Controls
			showUI: true
			showLogo: true
			scaleState: "fill" # fill / normal
			showHints: true
		
		super @options

		window.savePreviewMessageFramerObject(@)
		@updateInit()
		
		@states =
			"normal": { scale: 1 }
			"fill": { scale: 1 }



	@define 'view',
		get: -> @options.view
		set: (value) ->
			@options.view = value
			@width = @view.width
			@height = @view.height
			@view.parent = @
	
	@define 'stateGuard',
		get: -> @options.stateGuard
		set: (value) -> @options.stateGuard = value



	@define 'device',
		get: -> @options.borderView
	
	@define 'statusBar',
		get: -> @options.statusBarView
	
	@define 'homeBar',
		get: -> @options.homeBarView



	@define 'borderView',
		get: -> @options.borderView
		set: (value) -> @options.borderView = value
	
	@define 'statusBarView',
		get: -> @options.statusBarView
		set: (value) -> @options.statusBarView = value
	
	@define 'homeBarView',
		get: -> @options.homeBarView
		set: (value) -> @options.homeBarView = value



	@define 'configView',
		get: -> @options.configView
		set: (value) -> @options.configView = value
	
	@define 'sectionView',
		get: -> @options.sectionView
		set: (value) -> @options.sectionView = value
	

	
	
	

	animateStateToNormal: () =>
		@stateGuard.stateSwitch("normal")
		@animate(scale: @states["normal"].scale, options: { curve: Spring(damping: 1), time: 0.5 })
		if @borderView then @borderView.animateStateToNormal()
	
	animateStateToFill: () =>
		@stateGuard.stateSwitch("fill")
		@animate(scale: @states["fill"].scale, options: { curve: Spring(damping: 1), time: 0.5 })
		if @borderView then @borderView.animateStateToFill()

	stateSwitchToNormal: () =>
		@stateGuard.stateSwitch("normal")
		@animate(scale: @states["normal"].scale, options: { curve: Bezier.linear, time: 0 })
		if @borderView then @borderView.stateSwitchToNormal()
	
	stateSwitchToFill: () =>
		@stateGuard.stateSwitch("fill")
		@animate(scale: @states["fill"].scale, options: { curve: Bezier.linear, time: 0 })
		if @borderView then @borderView.stateSwitchToFill()
	

	
	

	@define 'showDevice',
		get: -> @options.showDevice
		set: (value) -> @options.showDevice = value
	


	@define 'showBars',
		get: -> @options.showBars
		set: (value) -> @options.showBars = value
	
	@define 'showStatusBar',
		get: -> @options.showStatusBar
		set: (value) -> @options.showStatusBar = value
	
	@define 'showHomeBar',
		get: -> @options.showHomeBar
		set: (value) -> @options.showHomeBar = value





	@define 'timeValue',
		get: -> @options.timeValue
		set: (value) -> @options.timeValue = value
	
	@define 'forceAndroidBar',
		get: -> @options.forceAndroidBar
		set: (value) -> @options.forceAndroidBar = value
	
	@define 'statusBar_theme',
		get: -> @options.statusBar_theme
		set: (value) -> @options.statusBar_theme = value
	
	@define 'homeBar_theme',
		get: -> @options.homeBar_theme
		set: (value) -> @options.homeBar_theme = value




	@define 'showUI',
		get: -> @options.showUI
		set: (value) -> @options.showUI = value
	
	@define 'showLogo',
		get: -> @options.showLogo
		set: (value) -> @options.showLogo = value
	
	@define 'showHints',
		get: -> @options.showHints
		set: (value) -> @options.showHints = value
	
	
	


	@define 'scaleState',
		get: -> @options.scaleState
		set: (value) -> @options.scaleState = value
	







	updateInit: () =>

		@scaleState = @getStateGeneric("scale", [{ value: "fill", result: "fill" },
												{ value: "normal", result: "normal" },
												{ value: "false", result: "normal" },
												{ value: "true", result: "fill" }], @scaleState)
		
		@scaleState = @getStateGeneric("fill", [{ value: "on", result: "fill" },
												{ value: "off", result: "normal" },
												{ value: "true", result: "fill" },
												{ value: "false", result: "normal" }], @scaleState)

		@showUI = @getStateGeneric("button", [{ value: "false", result: false },
												{ value: "true", result: true },
												{ value: "on", result: true },
												{ value: "off", result: false }], @showUI)
		
		@showUI = @getStateGeneric("ui", [{ value: "false", result: false },
												{ value: "true", result: true },
												{ value: "on", result: true },
												{ value: "off", result: false }], @showUI)

		@showLogo = @getStateGeneric("logo", [{ value: "false", result: false },
												{ value: "true", result: true },
												{ value: "on", result: true },
												{ value: "off", result: false }], @showLogo)
												
		@showDevice = @getStateGeneric("device", [{ value: "off", result: false },
													{ value: "on", result: true },
													{ value: "false", result: false },
													{ value: "true", result: true }], @showDevice)
		
		@showHints = @getStateGeneric("hints", [{ value: "off", result: false },
													{ value: "on", result: true },
													{ value: "false", result: false },
													{ value: "true", result: true }], @showHints)



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
						result = pair.result
					# else
						# print "not " + " #{pair.value}" 
		
		return result
	
	
	
	
