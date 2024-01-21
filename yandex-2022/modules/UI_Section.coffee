


{Text, ButtonTab} = require "UI_Buttons"

class exports.UI_Section extends Layer
	constructor: (@options={}) ->
		
		_.defaults @options,
			width: 200, height: Screen.height, y: 100
			backgroundColor: null

		super @options
	

	addSection: (title, actionArray = []) =>

		sectionView = new Layer
			parent: @
			width: 360, height: 100, backgroundColor: null
			x: 32, y: @children.length * 100

		@addSectionTitle(sectionView, title)

		sectionView.style = cursor: "pointer"
		sectionView.onTap -> ;
		sectionView.showHint = -> ;

		sumX = 0
		for actionItem, i in actionArray
			sectionButton = @addActionButton(actionItem, i)
			sectionButton.parent = sectionView
			sectionButton.x = sumX
			sumX += sectionButton.width + 8
		
		@width = Math.max(@width, sumX)



	addActionButton: (actionItem, index) =>
		buttonLayer = new ButtonTab
			text: actionItem.title
			y: 42
			selected: if index is 0 then true else false
			custom:
				actionItem: actionItem
		
		complexHandler = () ->
			@custom.actionItem.handler(@custom.actionItem.data, @)
			for button in @parent.children
				if button.name isnt ".sectionTitle"
					button.selected = true if button is @
					button.selected = false if button isnt @

		buttonLayer.on(Events.Tap, complexHandler)
		return buttonLayer


	addSectionTitle: (localParent, title = "Header Title") =>
		new Text
			parent: localParent
			text: title, name: ".sectionTitle"
			fontSize: 16, opacity: 0.5, padding: { top: 12 }

