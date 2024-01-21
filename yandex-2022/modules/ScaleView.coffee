
{LogoLayer} = require "Preview_LogoLayer"
{PhoneTypeView} = require "PhoneTypeView"


class exports.ScaleView extends PhoneTypeView
	constructor: (@options={}) ->

		_.defaults @options,
		
		super @options


	
	
	
	createLogoButton: () =>
		
		openHomeHandler = () ->
			window.location = "https://tilllur.com"
		
		logoButton = new LogoLayer
			width: 76, height: 32
			x: Align.left(32), y: Align.top(12)
			handler: openHomeHandler
	
	
	
	createScaleButton: (forState) =>
		
		buttonScale = new Layer
			size: 48, borderRadius: 48
			x: Align.right(-32), y: Align.bottom(-32)
			backgroundColor: "rgba(255,255,255, 0.1)"
			borderWidth: 2
			custom:
				preview: @
		
		buttonScale.style = cursor: "pointer"
		
		buttonScale.states =
			"normal": { borderColor: "rgba(255,255,255, 0.2)" }
			"fill": { borderColor: "rgba(255,255,255, 0.6)" }
		buttonScale.stateSwitch(forState)
		
		buttonInsideLayer = new Layer
			parent: buttonScale
			borderWidth: 2
			size: 28, borderRadius: 22
			x: 10, y: 10
			backgroundColor: null
			
		
		buttonInsideLayer.states =
			"normal": { borderColor: "rgba(255,255,255, 0.6)" }
			"fill": { borderColor: "rgba(255,255,255, 0.2)" }
		buttonInsideLayer.stateSwitch(forState)
		
		buttonScale.onTap ->
			if @states.current.name == "fill" then nextState = "normal" else nextState = "fill"
			@stateSwitch(nextState)
			@children[0].stateSwitch(nextState)
			@custom.preview.animate(nextState, curve: Spring(damping: 1), time: 0.5)
		
		updateButtonOnResize = (buttonLayer) =>
			localButton = buttonLayer
			
			Canvas.on "change:height", =>
				buttonLayer.x = Align.right(-32)
			
			Canvas.on "change:width", =>
				buttonLayer.y = Align.bottom(-32)
		
		updateButtonOnResize(buttonScale)



