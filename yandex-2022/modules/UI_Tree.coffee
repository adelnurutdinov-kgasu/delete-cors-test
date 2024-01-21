

# {SectionView} = require "SectionView"


class exports.TreeLayerView extends SectionView
	constructor: (@options={}) ->

		treeViewLayer = new ScrollComponent
			width: 320
			height: 0
			scrollVertical: true
			scrollHorizontal: false
			mouseWheelEnabled: true
			backgroundColor: "#222"
		
		treeViewLayer.content.height = 0
		treeViewLayer.mouseWheelEnabled = true
			

		_.defaults @options,
			treeView: treeViewLayer
			indent: 1
		
		super @options

		treeViewLayer.parent = @parent

	
	@define 'treeView',
		get: -> @options.treeView
		set: (value) -> @options.treeView = value
	
	@define 'indent',
		get: -> @options.indent
		set: (value) -> @options.indent = value
	


	printTree: () =>
		print @view.children
		@printNode(@view)
		@treeView.height = Screen.height
		@treeView.updateContent()
	

	printNode: (node, level = 0) =>
		if node.name == "" then layerName = "Untitled" else layerName = node.name
		# print Array(level + 1).join(" ・ ") + " #{layerName}"

		treeNodeLayer = new TextLayer
			parent: @treeView.content
			text: Array(level + 1).join(" ・ ") + " #{layerName}"
			
			fontSize: 15
			fontWeight: 500
			color: "white"

			opacity: if layerName == "Untitled" then 0.5 else 1
			height: 28
			y: @treeView.height
			# backgroundColor: Utils.randomColor()
			backgroundColor: null
			custom:
				layer: node
		
		treeNodeLayer.onTap ->
			print "#{@custom.layer.name} x: #{@custom.layer.x} y: #{@custom.layer.y} size: #{@custom.layer.width}x#{@custom.layer.height}"

		
		@treeView.height += 28


		if node.children.length > 0
			nextLevel = level + 1
			for childNode in node.children
				@printNode(childNode, nextLevel)
		
