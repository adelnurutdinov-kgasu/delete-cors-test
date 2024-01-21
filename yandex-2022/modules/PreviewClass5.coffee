

{PreviewClass4} = require "PreviewClass4"


class exports.PreviewClass5 extends PreviewClass4
	constructor: (@options={}) ->

		controlPanelLayer = new Layer
			width: 360, height: 1000
			x: 20, y: 60
			backgroundColor: null

		_.defaults @options,
			controlPanel: controlPanelLayer
		
		super @options

		controlPanelLayer.parent = @parent

	
	@define 'controlPanel',
		get: -> @options.controlPanel
		set: (value) -> @options.controlPanel = value
	
	addSection: (title, actionArray = []) =>
		if Utils.isMobile() then return
		else
			sectionView = new Layer
				width: 360
				height: 100
				parent: @controlPanel
				backgroundColor: null
			
			sectionView.y = (@controlPanel.children.length - 1) * 100

			@addSectionTitle(title).parent = sectionView

			sumX = 0
			for actionItem, index in actionArray
				sectionButton = @addSectionButton(actionItem)
				sectionButton.parent = sectionView
				sectionButton.x = sumX
				sumX += sectionButton.width + 8
				




	addSectionButton: (actionItem, pV = 6, pH = 9) =>
		buttonLayer = new TextLayer
			text: actionItem.title
			y: 42
			padding: { top: pV, bottom: pV + 2, left: pH, right: pH }
			fontSize: 18
			fontWeight: 500
			color: "white"
			backgroundColor: "rgba(0,0,0,0.5)"
			borderRadius: 8
		
		buttonLayer.on(Events.Tap, actionItem.handler)
		return buttonLayer


	addSectionTitle: (title = "Header Title") =>
		return new TextLayer
			text: title
			fontSize: 15
			fontWeight: 500
			color: "white"
			opacity: 0.6
			padding:
				top: 12




# # Example
# preview.addSection("Choose Background", [
# 	{ title: test1, handler: test2 },
# 	{ title: test1, handler: test2 }
# ])