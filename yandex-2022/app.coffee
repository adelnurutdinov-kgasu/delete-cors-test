# Import
# cp ~/Downloads/ios-11-gui-for-framer-master/Components/iOSSegmentedControl.coffee ~/Documents/Git/Prototyping-Queue/2022-02-08\ \[pp\]\ Yandex\ 2022\ –\ Flow.framer/modules/
# cp ~/Downloads/ios-11-gui-for-framer-master/Components/iOSSwitch.coffee ~/Documents/Git/Prototyping-Queue/2022-02-08\ \[pp\]\ Yandex\ 2022\ –\ Flow.framer/modules/

Framer.Extras.Hints.disable()
Canvas.backgroundColor = "222"

{iOSSwitch} = require 'iOSSwitch'
{iOSSegmentedControl} = require "iOSSegmentedControl"


Framer.Defaults.Animation =
	curve: Spring(damping: 1)
	time: 0.5

isShowTips = false

# Debug Colors

array256 = []
array256.push item for item in [0..255]

debugColor = () ->
	if isShowTips
		return new Color(r: Utils.randomChoice(array256), g: Utils.randomChoice(array256), b: Utils.randomChoice(array256), a: 0.5)
	return null

# Screen

screen = new Layer
	name: "screen"
	width: 375
	height: 812
	backgroundColor: "FAF9F8"


{ Preview } = require "PreviewComponent"
preview = new Preview { view: screen }



# Global

isTabs_AsThirdTab = true

changeState = (toState) ->
	if toState == "global"
		firstTab_Flow.stateSwitch("shown")
		secondTab_Flow.stateSwitch("hidden")
		thirdTab_Flow.stateSwitch("hidden")
		
		firstTab_Flow.placeBehind(aliceBar)
		secondTab_Flow.sendToBack()
		thirdTab_Flow.sendToBack()
	
	else if toState == "reels"
		firstTab_Flow.stateSwitch("hidden")
		secondTab_Flow.stateSwitch("shown")
		thirdTab_Flow.stateSwitch("hidden")
		
		secondTab_Flow.placeBefore(aliceBar)
		firstTab_Flow.sendToBack()
		thirdTab_Flow.sendToBack()
	
	else if toState == "tabs"
		firstTab_Flow.stateSwitch("hidden")
		secondTab_Flow.stateSwitch("hidden")
		thirdTab_Flow.stateSwitch("shown")
		
		thirdTab_Flow.placeBefore(aliceBar)
		firstTab_Flow.sendToBack()
		secondTab_Flow.sendToBack()
	
	
	
	else if toState == "tabs_fromFeed"
		globalTabs_View.animate("toTabs", time: 0.5)
		tabs.animate("shown")
	
	else if toState == "feed_fromTabs"
		globalTabs_View.animate("fromTabs", time: 0.5)
		tabs.animate("hidden")



firstTab_Flow_prev = (event, layer) ->	
	firstTab_Flow.showPrevious()

firstTab_Flow_prevSwipe = Utils.throttle 0.5, (event, layer) ->
	firstTab_Flow.showPrevious()




globalTabs_View = new Layer
	name: "globalTabs_View"
	parent: screen
	width: screen.width
	height: screen.height

globalTabs_View.states =
	"toTabs": { y: screen.height + 20 }
	"fromTabs": { y: 0 }
globalTabs_View.stateSwitch("fromTabs")


firstTab_Flow = new FlowComponent
	parent: globalTabs_View
	width: screen.width
	height: screen.height

firstTab_Flow.states =
	"hidden": { opacity: 0, x: -400  }
	"shown": { opacity: 1, x: 0 }
firstTab_Flow.stateSwitch("shown")


startPage_ViewController = new Layer
	name: "startPage_ViewController"
	width: screen.width
	height: screen.height
	backgroundColor: debugColor()
	backgroundColor: "white"




secondTab_Flow = new Layer
	name: "secondTab_Flow"
	parent: globalTabs_View
	width: screen.width
	height: screen.height

secondTab_Flow.states =
	"hidden": { opacity: 0 }
	"shown": { opacity: 1 }
secondTab_Flow.stateSwitch("hidden")

secondTab_Flow.sendToBack()

reels = new Layer
	name: "reels"
	parent: secondTab_Flow
	width: screen.width
	height: screen.height
	image: "images/reels.png"





thirdTab_Flow = new FlowComponent
	parent: globalTabs_View
	width: screen.width
	height: screen.height

thirdTab_Flow.states =
	"hidden": { opacity: 0 }
	"shown": { opacity: 1 }
thirdTab_Flow.stateSwitch("shown")

thirdTab_Flow.sendToBack()





# Under View

tabsView = new Layer
	name: "tabsView"
	width: screen.width
	height: screen.height
	backgroundColor: "black"

tabs = new Layer
	name: "tabs"
	parent: tabsView
	width: screen.width
	height: screen.height
	image: "images/tabsView.png"

tabs.states =
	"hidden": { opacity: 0.2 }
	"shown": { opacity: 1 }
	"custom": { image: "images/tabsView.png" }
	"tab": { image: "images/tabsViewNext.png" }






changeTabs = () ->
	isTabs_AsThirdTab = !isTabs_AsThirdTab
	updateTabs()

updateTabs = () ->
	if isTabs_AsThirdTab
		tabs.stateSwitch("tab")
		tabsView.parent = thirdTab_Flow
		thirdTab_Flow.showNext(tabsView)
		tabs.stateSwitch("shown")
	else
		tabs.stateSwitch("custom")
		tabs.stateSwitch("hidden")
		tabsView.parent = screen
		tabsView.sendToBack()

updateTabs()




# Start Page


startPage = new Layer
	name: "startPage"
	parent: startPage_ViewController
	width: screen.width
	height: screen.height
	backgroundColor: debugColor()
	backgroundColor: "white"








feedScroll = new ScrollComponent
	name: "feedScroll"
	parent: startPage
	width: 375
	height: 812 - 100
	y: 100
	scrollVertical: true
	scrollHorizontal: false
	directionLock: true
	contentInset:
		bottom: 80+8
	backgroundColor: "F3F3F2"

feedScroll.sendToBack()


feedScroll.content.on "change:y", ->
	v = feedScroll.scrollY
	if v > 154
		scrollProxy.stateSwitch("feed")
	else
		scrollProxy.stateSwitch("start")
	
# 	print v
# 	print feedScroll.content.height - feedScroll.height

	if v < 40 then scrollDirectionProxy.stateSwitch("shown")
	else if v > feedScroll.content.height - feedScroll.height
		scrollDirectionProxy.stateSwitch("hidden")
	else if @draggable.direction == "up"
		scrollDirectionProxy.stateSwitch("hidden")
	else if @draggable.direction == "down"
		scrollDirectionProxy.stateSwitch("shown")



# Scroll: Bottom Bar

# Bars

isRedLogo = () ->
	return startPage_TopImage.states.current.name == "start yellow logo"

changeStartBar = () ->
	if isRedLogo()
		startPage_BottomImage.stateSwitch("start yellow")
		startPage_TopImage.stateSwitch("start yellow")
	else
		startPage_BottomImage.stateSwitch("start yellow logo")
		startPage_TopImage.stateSwitch("start yellow logo")






scrollDirectionProxy = new Layer
	name: "scrollDirectionProxy"
	opacity: 0
	x: -3000

scrollDirectionProxy.states =
	"shown": { opacity: 0 }
	"hidden": { opacity: 0 }
scrollDirectionProxy.stateSwitch("shown")

scrollDirectionProxy.on Events.StateSwitchEnd, (from, to) ->
	barTransitionTime = 0.2
	if from != to
		startPage_TopView.animate(to, time: barTransitionTime)
		if isAliceFab then aliceBar.animate(to, time: barTransitionTime)
		startPage_TopImage.animate(to, time: barTransitionTime)
	
	else if aliceBar.states.current.name == "shown" and to == "hidden"
		if isAliceFab then aliceBar.animate(to, time: barTransitionTime)



# Bottom Part (Static)
startPage_BottomView = new Layer
	name: "startPage_BottomView"
	parent: startPage
	width: 375
	height: 84
	y: Align.bottom
	clip: true
	backgroundColor: null


startPage_BottomImage = new Layer
	name: "startPage_BottomImage"
	parent: startPage_BottomView
	width: 375
	height: 146
	y: Align.bottom

startPage_BottomImage.states =
	"start yellow": { image: "images/startBar_1.png" }
	"start yellow logo": { image: "images/startBar_2.png" }
startPage_BottomImage.stateSwitch("start yellow")


# Bottom Part (Dynamic)
startPage_TopView = new Layer
	name: "startPage_TopView"
	parent: startPage
	width: 375
	height: startPage_BottomImage.height - startPage_BottomView.height
	y: Align.bottom(-startPage_BottomView.height)
	clip: true
	backgroundColor: null

startPage_TopView.states =
	"shown": { y: Align.bottom(-startPage_BottomView.height) }
	"hidden": { y: Align.bottom(-startPage_BottomView.height + startPage_TopView.height) }

startPage_TopImage = new Layer
	name: "startPage_TopImage"
	parent: startPage_TopView
	width: 375
	height: 146
	y: Align.top

startPage_TopImage.states =
	"start yellow": { image: "images/startBar_1.png" }
	"start yellow logo": { image: "images/startBar_2.png" }
	"shown": { opacity: 1 }
	"hidden": { opacity: 0 }
startPage_TopImage.stateSwitch("start yellow logo")



startPage_TopView.placeBehind(startPage_BottomView)


# TODO
startPage_BottomView_Alice = new Layer
	name: "startPage_BottomView_Alice"
	parent: startPage_TopImage
	width: 32, height: 32, x: 26, y: 18
	image: "images/aliceField.png"
	backgroundColor: "white"

startPage_BottomView_Alice.states =
	"shown": { opacity: 1 }
	"hidden": { opacity: 0 }
startPage_BottomView_Alice.stateSwitch("hidden")



# Feed


article_card_with_embed = new Layer
	name: "article_card_with_embed"
	width: 375
	height: 440
	image: "images/article%20card%20with%20embed.png"

article_card = new Layer
	name: "article_card"
	width: 375
	height: 423
	image: "images/Cardsasds.png"

news_card = new Layer
	name: "news_card"
	width: 375
	height: 495
	image: "images/news%20card.png"

shortcutView = new ScrollComponent
	name: "shortcutView"
	width: 375
	height: 136
	scrollVertical: false
	scrollHorizontal: true
	contentInset:
		left: 16
		right: 16
		top: 12
	directionLock: true
	backgroundColor: "white"




isOrder_StartWithNews = true
newsCardOrder = [shortcutView, news_card, article_card, article_card_with_embed]
zenCardOrder = [shortcutView, article_card, news_card, article_card_with_embed]


Framer.Extras.Preloader.addImage(item.image) for item in newsCardOrder
item.parent = feedScroll.content for item in newsCardOrder
feedScroll.updateContent()

changeOrder = () ->
	isOrder_StartWithNews = !isOrder_StartWithNews
	updateOrder()

updateOrder = () ->
	if isOrder_StartWithNews then currentOrder = newsCardOrder
	else currentOrder = zenCardOrder
	
	orderY = 0
	for item in currentOrder
		item.y = orderY
		orderY += item.height + 6

updateOrder()
feedScroll.updateContent()



# Shortcuts

isNewShortcuts = false
# image: "images/shortcut_new_01.png"

for i in [0...6]
	new Layer
		parent: shortcutView.content
		size: 108
		x: (108 + 8) * i
		borderRadius: 16
		clip: true

changeShortcuts = () ->
	isNewShortcuts = !isNewShortcuts
	updateShortcuts()

updateShortcuts = () ->
	if isNewShortcuts then tempStr = "new"
	else tempStr = "old"
	
	for item, i in shortcutView.content.children
		item.image = "images/shortcut_#{tempStr}_0#{i+1}.png"

updateShortcuts()

# Site

sites =
	vc: "apple.com"
	search: "how to cook buckwheat"
	news: "News"
	weather: "Weather"
	


loadSite = (title) ->
	if isAliceFab then aliceBar.animate("shown", time: 0.3)
	
	if title == sites.vc
		siteContent.image = "images/site_vc.jpg"
		siteContent.height = 821
		siteScroll.scrollToPoint({ x: 0, y: 0 }, false)
	
	else if title == sites.search
		siteContent.image = "images/search_feed.jpg"
		siteContent.height = 1465
		siteScroll.scrollToPoint({ x: 0, y: 0 }, false)
	
	else if title == sites.news
		siteContent.image = "images/newsContent.jpg"
		siteContent.height = 1260
		siteScroll.scrollToPoint({ x: 0, y: 0 }, false)
	
	else if title == sites.weather
		siteContent.image = "images/weather.jpg"
		siteContent.height = 844
		siteScroll.scrollToPoint({ x: 0, y: 0 }, false)
	
	
	site_title.text = title
	site_title_small.text = title
	siteScroll.updateContent()




site_ViewController = new Layer
	name: "site_ViewController"
	width: screen.width
	height: screen.height
	backgroundColor: "white"
	parent: screen

site_ViewController.on(Events.SwipeRightEnd, firstTab_Flow_prevSwipe)



siteScroll = new ScrollComponent
	name: "siteScroll"
	parent: site_ViewController
	width: 375
	height: 812 - 44 - 50
	y: Align.top(44)
	scrollVertical: true
	scrollHorizontal: false
	directionLock: true

siteContent = new Layer
	name: "siteContent"
	parent: siteScroll.content
	width: 375
	height: 821
	image: "images/site_vc.jpg"





site_Bar = new Layer
	name: "site_Bar"
	parent: site_ViewController
	width: 375
	height: 146
	y: Align.bottom
	backgroundColor: "#ECEAE9"

site_Bar.states =
	"shown": { y: Align.bottom }
	"hidden": { y: Align.bottom(site_Bar.height - 50) }
site_Bar.stateSwitch("shown")


site_Bar_Image = new Layer
	name: "site_Bar_Image"
	parent: site_Bar
	width: site_Bar.width
	height: site_Bar.height
	image: "images/vcBar.png"

site_Bar_Image.states =
	"shown": { opacity: 1 }
	"hidden": { opacity: 0 }
site_Bar_Image.stateSwitch("shown")





site_title = new TextLayer
	name: "site_title"
	parent: site_Bar_Image
	backgroundColor: "white"
	width: 231, height: 40, x: 72, y: 12
	fontSize: 18
	color: "black"
	textAlign: "center"
	padding:  { top: 10 }

site_title_small = new TextLayer
	name: "site_title_small"
	parent: site_Bar
	width: 231, x: 72
	fontSize: 14
	color: "black"
	textAlign: "center"
	padding:  { top: 7 }

site_title_small.placeBehind(site_Bar_Image)




site_Bar_alice = new Layer
	name: "site_Bar_alice"
	parent: site_Bar_Image
	width: 32, height: 32, x: 26, y: 18
	image: "images/aliceField.png"
	backgroundColor: "white"

site_Bar_alice.states =
	"shown": { opacity: 1 }
	"hidden": { opacity: 0 }
site_Bar_alice.stateSwitch("hidden")






site_backButton = new Layer
	name: "site_backButton"
	parent: site_Bar
	width: 109, height: 50, x: 18, y: 68
	backgroundColor: debugColor()

site_backButton.on(Events.Tap, firstTab_Flow_prev)


site_homeButton = new Layer
	name: "site_homeButton"
	parent: site_Bar
	width: 109, height: 50, y: 68
	x: Align.center
	backgroundColor: debugColor()

site_homeButton.on(Events.Tap, firstTab_Flow_prev)


site_tabsButton = new Layer
	name: "site_tabsButton"
	parent: site_Bar
	x: 242, y: 68, width: 109, height: 50
	backgroundColor: debugColor()

site_tabsButton.onTap ->
	if isTabs_AsThirdTab
		firstTab_Flow.showPrevious(animate: false)
		thirdTab_Flow.showNext(site_ViewController, animate: false)
		changeState("tabs")
		thirdTab_Flow.showPrevious(stackTransition)
		
	else changeState("tabs_fromFeed")



# Scroll: Site

siteScrollProxy = new Layer
	name: "siteScrollProxy"
	opacity: 0
	x: -3000

siteScrollProxy.states =
	"shown": { opacity: 0 }
	"hidden": { opacity: 0 }
siteScrollProxy.stateSwitch("shown")

siteScrollProxy.on Events.StateSwitchEnd, (from, to) ->
	siteTransitionTime = 0.2
	if to != from
		site_Bar.animate(to, time: siteTransitionTime)
		site_Bar_Image.animate(to, time: siteTransitionTime)
		if isAliceFab then aliceBar.animate(to, time: siteTransitionTime)


siteScroll.content.on "change:y", ->
	v = @parent.scrollY
# 	print v

	if v < 40 then siteScrollProxy.stateSwitch("shown")
	else if v > @height - @parent.height
		siteScrollProxy.stateSwitch("hidden")
	else if @draggable.direction == "up"
		siteScrollProxy.stateSwitch("hidden")
	else if @draggable.direction == "down"
		siteScrollProxy.stateSwitch("shown")

# Article

article_ViewController = new Layer
	name: "article_ViewController"
	width: screen.width
	height: screen.height
	backgroundColor: "white"
	parent: screen

article_ViewController.on(Events.SwipeRightEnd, firstTab_Flow_prevSwipe)



articleScroll = new ScrollComponent
	name: "articleScroll"
	parent: article_ViewController
	width: 375
	height: 812 - 100 - 78
	y: Align.top(100)
	scrollVertical: true
	scrollHorizontal: false
	directionLock: true

articleContent = new Layer
	name: "articleContent"
	parent: articleScroll.content
	width: 375
	height: 1286
	image: "images/article_content.png"




article_Bar = new Layer
	name: "article_Bar"
	parent: article_ViewController
	width: 375
	height: 78
	y: Align.bottom
	image: "images/article_bar.png"


article_Header = new Layer
	name: "article_Header"
	parent: article_ViewController
	width: 376
	height: 101
	y: Align.top
	image: "images/article_header.png"


article_Header_back = new Layer
	name: "article_Header_back"
	parent: article_Header
	y: 44
	height: 56
	width: 42
	backgroundColor: debugColor()

article_Header_back.on(Events.Tap, firstTab_Flow_prev)



# Buttons

# Feed — Content ->
article_card_with_embed.onTap ->
	loadSite(sites.vc)
	firstTab_Flow.transition(site_ViewController, stackTransition)

news_card.onTap ->
	loadSite(sites.news)
	firstTab_Flow.transition(site_ViewController, stackTransition)
	siteScroll.scrollToPoint({ x: 0, y: 0 }, false)

article_card.onTap ->
	firstTab_Flow.transition(article_ViewController, stackTransition)


shortcutView.content.children[1].onTap ->
	loadSite(sites.weather)
	firstTab_Flow.transition(site_ViewController, stackTransition)





# Feed — Bottom Bar ->
startPage_SearchButton = new Layer
	name: "startPage_SearchButton"
	parent: startPage_TopImage
	x: 65, y: Align.top, width: 245, height: startPage_TopView.height
	backgroundColor: debugColor()

startPage_SearchButton.onTap ->
	loadSite(sites.search)
	firstTab_Flow.transition(site_ViewController, stackTransition)
	siteScroll.scrollToPoint({ x: 0, y: 0 }, false)



startPage_ScrollToTop_Button = new Layer
	name: "startPage_ScrollToTop_Button"
	parent: startPage_BottomView
	x: Align.left(15)
	y: Align.bottom, width: 115, height: startPage_BottomView.height
	backgroundColor: debugColor()

startPage_ScrollToTop_Button.onTap ->
	feedScroll.scrollToTop()



startPage_NavigateToReels_Button = new Layer
	name: "startPage_NavigateToReels_Button"
	parent: startPage_BottomImage
	x: Align.center, y: Align.bottom, width: 115, height: startPage_BottomView.height
	backgroundColor: debugColor()

startPage_NavigateToReels_Button.onTap ->
	changeState("reels")



startPage_NavigateToTabs_Button = new Layer
	name: "startPage_NavigateToTabs_Button"
	parent: startPage_BottomView
	x: Align.right(-15)
	y: Align.bottom, width: 115, height: startPage_BottomView.height
	backgroundColor: debugColor()

startPage_NavigateToTabs_Button.onTap ->
	if isTabs_AsThirdTab then changeState("tabs")
	else changeState("tabs_fromFeed")





# Reels -> 
secondTab_Flow_NavigateToFeed_Button = new Layer
	name: "secondTab_Flow_NavigateToFeed_Button"
	parent: secondTab_Flow
	x: Align.left(20)
	y: Align.bottom(-24)
	width: 103, height: 55
	backgroundColor: debugColor()

secondTab_Flow_NavigateToFeed_Button.onTap ->
	changeState("global")


secondTab_Flow_NavigateToTabs_Button = new Layer
	name: "secondTab_Flow_NavigateToTabs_Button"
	parent: secondTab_Flow
	x: Align.right(-20)
	y: Align.bottom(-24)
	width: 103, height: 55
	backgroundColor: debugColor()

secondTab_Flow_NavigateToTabs_Button.onTap ->
	if isTabs_AsThirdTab then changeState("tabs")
	else changeState("tabs_fromFeed")



# Tabs ->
tabsView_NavigateToFeed_Button = new Layer
	name: "tabsView_NavigateToFeed_Button"
	parent: tabsView
	x: Align.left(20), y: Align.bottom(-24)
	width: 103, height: 55
	backgroundColor: debugColor()

tabsView_NavigateToFeed_Button.onTap ->
	if isTabs_AsThirdTab then changeState("global")


tabsView_NavigateToReels_Button = new Layer
	name: "tabsView_NavigateToReels_Button"
	parent: tabsView
	width: 103, height: 55
	x: Align.center, y: Align.bottom(-24)
	backgroundColor: debugColor()

tabsView_NavigateToReels_Button.onTap ->
	if isTabs_AsThirdTab then changeState("reels")



tabsView_NavigateBack_Button = new Layer
	name: "tabsView_NavigateBack_Button"
	parent: tabsView
	x: 276, y: 718, width: 99, height: 54
	backgroundColor: debugColor()

tabsView_NavigateBack_Button.onTap ->
	if isTabs_AsThirdTab then return
	else changeState("feed_fromTabs")



# Stack Transition

stackTransition = (firstTab_Flow, layerA = startPage_ViewController, layerB = site_ViewController, overlay) ->
	overlay.width = layerA.width
	overlay.height = layerA.height
	
	transition =
		layerA:
			show: { x: 0 }
			hide: { x: -375/2 }
		layerB:
			show: { x: 0, opacity: 1 }
			hide: { x: 375 }
		overlay:
			show: { opacity: 0.4 }
			hide: { opacity: 0 }

# Scroll: Feed 

scrollProxy = new Layer
	name: "scrollProxy"
	opacity: 0
	y: -3000

scrollProxy.states =
	"start": { opacity: 0 }
	"feed": { opacity: 0 }
scrollProxy.stateSwitch("start")

scrollProxy.on Events.StateSwitchEnd, (from, to) ->
	logoTransitionTime = 0.2
	if from != to
		if to == "start"
			startPage_HeaderTitleYandex.animate("shown", time: logoTransitionTime)
			startPage_HeaderTitleZen.animate("hidden", time: logoTransitionTime)
		else
			startPage_HeaderTitleYandex.animate("hidden", time: logoTransitionTime)
			startPage_HeaderTitleZen.animate("shown", time: logoTransitionTime)



startPage_Header = new Layer
	name: "startPage_Header"
	parent: startPage
	width: 375
	height: 100
	image: "images/startPage_Header1.png"
	clip: true



startPage_HeaderTitleYandex = new Layer
	name: "startPage_HeaderTitleYandex"
	parent: startPage_Header
	width: 160
	height: 60
	y: Align.bottom
	image: "images/startPage_HeaderTitleYandex_logo.png"

startPage_HeaderTitleYandex.states =
	"hidden": { opacity: 0, y: Align.bottom(-30) }
	"shown": { opacity: 1, y: Align.bottom }
startPage_HeaderTitleYandex.stateSwitch("shown")



startPage_HeaderTitleZen = new Layer
	name: "startPage_HeaderTitleZen"
	parent: startPage_Header
	width: 160
	height: 60
	y: Align.bottom
	image: "images/startPage_HeaderTitleZen.png"

startPage_HeaderTitleZen.states =
	"hidden": { opacity: 0, y: Align.bottom(30) }
	"shown": { opacity: 1, y: Align.bottom }
startPage_HeaderTitleZen.stateSwitch("hidden")







# Alice Bar

isAliceFab = false

changeAliceFab = () ->
	isAliceFab = !isAliceFab
	updateAliceFab()

updateAliceFab = () ->
	if isAliceFab
		aliceBar.stateSwitch("shown")
		startPage_BottomView_Alice.stateSwitch("hidden")
		site_Bar_alice.stateSwitch("hidden")
	else
		aliceBar.stateSwitch("hidden")
		startPage_BottomView_Alice.stateSwitch("shown")
		site_Bar_alice.stateSwitch("shown")




aliceBar = new Layer
	name: "aliceBar"
	parent: globalTabs_View
	width: 375
	height: 80
	y: Align.bottom(-startPage_BottomImage.height)
	image: "images/aliceBar.png"

aliceBar.states =
	"shown": { opacity: 1 }
	"hidden": { opacity: 0 }
aliceBar.stateSwitch("shown")

updateAliceFab()




# Settings -> Move to Module

screen_settings = new Layer
	name: "screen_settings"
	parent: screen
	width: 390
	height: 844
	backgroundColor: "white"

screen_settings.states =
	"shown": { x: 0 }
	"hidden": { x: screen.width }
screen_settings.stateSwitch("hidden")




screen_settings_header = new Layer
	name: "screen_settings_header"
	width: 390
	height: 100
	image: "modules/settingsHeader.png"
	parent: screen_settings

screen_settings_header_back = new Layer
	name: "screen_settings_header_back"
	parent: screen_settings_header, height: 56, width: 56, y: 44, x: -8
	backgroundColor: "null"


settingsView_scroll = new ScrollComponent
	name: "settingsView_scroll"
	parent: screen_settings
	width: 390
	height: 844 - 100
	y: 100
	backgroundColor: "white"
	scrollVertical: true
	scrollHorizontal: false
	directionLock: true


getSettingsTitle = (title = "Дзен") ->
	settings_breaker1 = new TextLayer
		name: "settings_breaker1"
		name: "breaker"
		parent: settingsView_scroll.content
		fontSize: 24
		width: 390 - 20
		height: 40
		text: title
		fontWeight: "bold"
		x: Align.left(20)
		color: "black"
		contentInset:
			left: 20
			right: 80


getSettingsLine = (title = "Строчка") ->
	settings_zenArticleOpenTypeText = new TextLayer
		name: "settings_zenArticleOpenTypeText"
		parent: settingsView_scroll.content
		fontSize: 16
		width: 390 - 20
		height: 32
		text: title
		x: Align.left(20)
		color: "black"
		padding: 
			top: 6
		contentInset:
			left: 20
			right: 80

getSegmentedControl = (itemArray = ["On", "Off", "sd"], customWidth = 200) ->
	switchControl = new iOSSegmentedControl
		parent: settingsView_scroll.content
		x: Align.center
		y: Align.center -50
		tintColor: "#42B72A"
		width: customWidth
		items: itemArray
	
	switchControl.setSelected true, 0
	return switchControl















# Settings


screen_settings.on(Events.SwipeRightEnd, firstTab_Flow_prevSwipe)

isAliceFab = !isAliceFab
settings_showTips = new iOSSwitch
	parent: getSettingsLine("Alice as FAB")
	isOn: isAliceFab
	x: Align.right(-32)

settings_showTips.parent.y = Align.top(40)
settings_showTips.onValueChange (value) ->
	changeAliceFab()

changeAliceFab()
changeAliceFab()



isOrder_StartWithNews = !isOrder_StartWithNews
settings_showTips = new iOSSwitch
	parent: getSettingsLine("News card on top")
	isOn: isOrder_StartWithNews
	x: Align.right(-32)

settings_showTips.parent.y = Align.top(100)
settings_showTips.onValueChange (value) ->
	changeOrder()

changeOrder()
changeOrder()


isNewShortcuts = !isNewShortcuts
settings_showTips = new iOSSwitch
	parent: getSettingsLine("New Shortcuts")
	isOn: isNewShortcuts
	x: Align.right(-32)

settings_showTips.parent.y = Align.top(160)
settings_showTips.onValueChange (value) ->
	changeShortcuts()

# isNewShortcuts = !isNewShortcuts
changeShortcuts()
changeShortcuts()


settings_showTips = new iOSSwitch
	parent: getSettingsLine("Tabs as TabBar Item")
	isOn: isTabs_AsThirdTab
	x: Align.right(-32)

settings_showTips.parent.y = Align.top(220)
settings_showTips.onValueChange (value) ->
	changeTabs()

changeTabs()
changeTabs()


settings_showTips = new iOSSwitch
	parent: getSettingsLine("Logo in seach Arrow")
	isOn: isRedLogo()
	x: Align.right(-32)

settings_showTips.parent.y = Align.top(280)
settings_showTips.onValueChange (value) ->
	changeStartBar()

changeStartBar()
changeStartBar()





startPage_HeaderTitleYandex.onTap ->
	firstTab_Flow.transition(screen_settings, stackTransition)

startPage_HeaderTitleZen.onTap ->
	firstTab_Flow.transition(screen_settings, stackTransition)



screen_settings_header_back.on(Events.Tap, firstTab_Flow_prev)


firstTab_Flow.showNext(startPage_ViewController)

# firstTab_Flow.showNext(site_ViewController, animate: false)
# firstTab_Flow.showPrevious(animate: false)

firstTab_Flow.transition(site_ViewController, stackTransition)
firstTab_Flow.transition(startPage_ViewController, stackTransition)

firstTab_Flow.transition(screen_settings, stackTransition)
firstTab_Flow.transition(startPage_ViewController, stackTransition)

firstTab_Flow.transition(article_ViewController, stackTransition)
firstTab_Flow.transition(startPage_ViewController, stackTransition)

# firstTab_Flow.transition(search_ViewController, stackTransition)
# firstTab_Flow.transition(startPage_ViewController, stackTransition)

# load_StartPageBar(bars.start_yellow_logo)


# preview.printTree()