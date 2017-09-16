//
// Attract-Mode Front-End - SILKY v0.6.8 beta
// 2017, Oomek
//

class UserConfig {


	</ label="Game List Rows", help="How many games to display on the list", options="11,13,15,17,19,21,23,25,27,29,31", order=3 /> rows="19"
	</ label="Game List Auto Hide", help="Time in seconds after which game list hides\n0 disables auto hide and flyer. Default value is 1", option="0", order=4 /> glautohide="1"
	</ label="Enable Clock", help="Enable Clock", options="Yes,No", order=36 /> enable_clock="Yes";		
	</ label="Background colour as R,G,B", help="( 0-255 values allowed )\nSets the colour of background elements.\nLeave blank if you want the colour from the randomized to be stored permanently.", option="0", order=7 /> bgrgb="254,58,124"
	</ label="Accent colour as R,G,B", help="( 0-255 values allowed )\nSets the colour of accent elements.\nLeave blank if you want the colour from the randomized to be stored permanently.", option="0", order=8 /> selrgb="255,255,0"
	</ label="Title colour as R,G,B", help="( 0-255 values allowed )\nSets the colour of accent elements.\nLeave blank if you want the colour from the randomized to be stored permanently.", option="0", order=8 /> titrgb="255,255,0"
	</ label="Game Selection Bar Colour as R,G,B", help="( 0-255 values allowed )\nSets the colour of accent elements.\nLeave blank if you want the colour from the randomized to be stored permanently.", option="0", order=9 /> gslrgb="17,169,234" 
	</ label="Played Count Colour as R,G,B", help="( 0-255 values allowed )\nSets the colour of accent elements.\nLeave blank if you want the colour from the randomized to be stored permanently.", option="0", order=9 /> pldrgb="255,255,0" 
 </ label="--------    Syste Art Animation Otions     --------", help="Show or hide additional images", order=27 /> uct7="Select Below"
	</ label="Enable System Art", help="Enable Big Art", options="Yes,No", order=28 /> enable_bigart="Yes"; 
//  </ label="Select Big Art Foldert", help="Select Big Art Folder", options="wheel, marquee, flyer, fanart, boxart, cartart", order=29 /> select_bigartfolder="fanart";
	</ label="Enable System Art Fade on Selection", help="Enable Big Art Fade on Selection", options="Yes,No", order=31 /> enable_bigartfade="No";
	</ label="Enable System Art Fade on Load", help="Enable Big Art Fade on Load", options="Yes,No", order=32 /> enable_bigartfadeonload="No"; 
	</ label="Enable System Art Scale on Selection", help="Enable Big Art Scale on Selection", options="Yes,No", order=33 /> enable_bigartscale="Yes"; 
	</ label="Enable System Art Scale on Load", help="Enable Big Art Scale on Load", options="Yes,No", order=34 /> enable_bigartscaleonload="Yes"; 
	</ label="Enable System Art Rotate on Selection", help="Enable Big Art Rotate on Selection", options="Yes,No", order=35 /> enable_bigartrotate="No";
	</ label="Enable System Art Rotate on Load", help="Enable Big Art Rotate on Load", options="Yes,No", order=36 /> enable_bigartrotateonload="No";	 
	</ label="Enable System Art Fly-in on Selection", help="Enable Big Art Fly-in on Selection", options="Yes,No", order=37 /> enable_bigartflyin="No";

 }

 
// Check if the AM version supporting .nomargin property is running
local am_version_check = fe.add_text("", 0, 0, 0, 0)
try{ am_version_check.nomargin = true }catch(e){	while (!fe.overlay.splash_message( "You are running an older version of Attract Mode.\nPlease update to the latest nightly build.")){} return }
am_version_check.visible = false
 
 
fe.do_nut("nuts/ryb2rgb.nut")
fe.do_nut("nuts/animate.nut")
fe.do_nut("nuts/genre.nut")
// modules
fe.load_module("fade");
fe.load_module( "animate");

function irand(max) {
	local roll = (1.0 * rand() / RAND_MAX) * (max + 1)
	return roll.tointeger()
}

local my_config = fe.get_config()
local layout_width = fe.layout.width
local layout_height = fe.layout.height
local flx = ( fe.layout.width - layout_width ) / 2
local fly = ( fe.layout.height - layout_height ) / 2
local flw = layout_width
local flh = layout_height

local glist_delay = my_config["glautohide"].tointeger() * 1000
local glr = my_config["rows"].tointeger()
local bth = floor( flh * 160.0 / 1080.0 )
local bbh = floor( flh * 160.0 / 1080.0 )
local bbm = ceil( bbh * 0.2 )
local lbw = floor( flh * 540.0 / 1080.0 )

local update_artwork = false
local update_counter = 0

local cr_en = false
local crw = 0


local bgRYB = [irand(255), irand(255), irand(255)]
local selRYB = [255 - bgRYB[0], 255 - bgRYB[1], 255 - bgRYB[2]]
local titRYB = [255 - bgRYB[0], 255 - bgRYB[1], 255 - bgRYB[2]]
local gslRYB = [255 - bgRYB[0], 255 - bgRYB[1], 255 - bgRYB[2]]
local pldRYB = [255 - bgRYB[0], 255 - bgRYB[1], 255 - bgRYB[2]]


local bgRGB = ryb2rgb(bgRYB)
local selRGB = ryb2rgb(selRYB)
local titRGB = ryb2rgb(titRYB)
local gslRGB = ryb2rgb(titRYB)
local pldRGB = ryb2rgb(titRYB)

try { bgRGB = fe.nv[0] } catch(e) {}
try { selRGB = fe.nv[1] } catch(e) {}
try { titRGB = fe.nv[1] } catch(e) {}
try { gslRGB = fe.nv[1] } catch(e) {}
try { pldRGB = fe.nv[1] } catch(e) {}

local error_message = false
if( my_config["bgrgb"] != "" ) {
	try { bgRGB = split(my_config["bgrgb"], ",").map(function(value) return value.tointeger()) }
	catch(e) { error_message = true}
}

if( my_config["selrgb"] != "" ) {
	try { selRGB = split(my_config["selrgb"], ",").map(function(value) return value.tointeger()) }
	catch(e) { error_message = true}
}

if( my_config["titrgb"] != "" ) {
	try { titRGB = split(my_config["titrgb"], ",").map(function(value) return value.tointeger()) }
	catch(e) { error_message = true}
}

if( my_config["gslrgb"] != "" ) {
	try { gslRGB = split(my_config["gslrgb"], ",").map(function(value) return value.tointeger()) }
	catch(e) { error_message = true}
}
if( my_config["pldrgb"] != "" ) {
	try { pldRGB = split(my_config["pldrgb"], ",").map(function(value) return value.tointeger()) }
	catch(e) { error_message = true}
}


if ( error_message || bgRGB.len() != 3 || selRGB.len() != 3 || titRGB.len() != 3 || gslRGB.len() != 3 || pldRGB.len() != 3)
	while (!fe.overlay.splash_message( "Background or Accent colour has a wrong format.\nPlease check it in Layout Options")){} 


// Flyer
local flyerH = flh - bth - bbh
local flyerW = lbw
local flyer = fe.add_artwork("flyer", flw + flx - crw - flyerW, bth, flyerW, flyerH )
flyer.trigger = Transition.EndNavigation
//flyer.trigger = 0

/////////////////
//Game Description
////////////////
local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;

local gtext = fe.add_text("[Overview]", flx*0.73, fly*0.25, flw*0.25, flh*0.45 );
gtext.set_rgb( 255, 255, 255 );
gtext.align = Align.Left;
gtext.charsize = 40;
gtext.rotation = 0;
gtext.word_wrap = true;
gtext.font = "BebasNeueRegular.otf"

local layout_width = fe.layout.width
local layout_height = fe.layout.height
local flx = ( fe.layout.width - layout_width ) / 2
local fly = ( fe.layout.height - layout_height ) / 2
local flw = layout_width
local flh = layout_height

// Game ListBox Background
local gameListBoxBackground = fe.add_text("", flx + flw - crw, bth, lbw, flh - bth - bbh )
gameListBoxBackground.set_bg_rgb( bgRGB[0] * 0.75, bgRGB[1] * 0.75, bgRGB[2] * 0.75 )
gameListBoxBackground.bg_alpha = 0


// Game ListBox
local gameListBox = fe.add_listbox( flx + flw - crw, bth, lbw, flh - bth - bbh)
gameListBox.align = Align.Left
gameListBox.rows = glr
gameListBox.charsize = floor( floor( flh - bth - bbh ) / glr * 0.7 )
gameListBox.set_sel_rgb( 240, 240, 240 )
gameListBox.set_selbg_rgb( gslRGB[0], gslRGB[1], gslRGB[2] )
gameListBox.set_bg_rgb( 255, 0, 0 )
gameListBox.font = "BebasNeueRegular.otf"
gameListBox.style = Style.Regular
gameListBox.sel_style = Style.Regular
gameListBox.y += floor( ( gameListBox.height - ( floor( gameListBox.height / gameListBox.rows ) * gameListBox.rows ) ) / 2 )


// Game Listbox Animations
local gameListBoxAnimX = Animate( gameListBox, "x", 4, glist_delay, 0.88 )
local gameListBoxAnimA = Animate( gameListBox, "listbox_alpha", 1, glist_delay, 0.88 )
local gameListBoxBackgroundAnimX = Animate( gameListBoxBackground, "x", 4, glist_delay, 0.88 )
local gameListBoxBackgroundAnimA = Animate( gameListBoxBackground, "bg_alpha", 1, glist_delay, 0.88 )
if ( glist_delay == 0 ) {
	gameListBoxAnimX.to = flw + flx - crw - lbw
	gameListBoxBackgroundAnimX.to = flw + flx - crw - lbw
	gameListBoxAnimA.to = 255
	gameListBoxBackgroundAnimA.to = 255
}

// Snap Background
local snapBackground = fe.add_image( "images/gradientV.png", flx, bth, flw - crw - flyerW, flh - bth - bbh )
snapBackground.set_rgb( bgRGB[0] * 0.6, bgRGB[1] * 0.6, bgRGB[2] * 0.6 )





 // Top Background
local bannerTop = fe.add_text( "", flx, 0, flw, bth)
bannerTop.set_bg_rgb( bgRGB[0], bgRGB[1], bgRGB[2] )


// Bottom Background
local bannerBottom = fe.add_text( "", flx, flh - bbh, flw, bbh)
bannerBottom.set_bg_rgb( bgRGB[0], bgRGB[1], bgRGB[2] )


// Favourite Icon
local favIconMargin = floor(bbh * 0.0625)
local favouriteIcon = fe.add_image("images/star.png", flx + favIconMargin, flh - bbh + favIconMargin, bbh - favIconMargin * 2, bbh - favIconMargin * 2)
favouriteIcon.set_rgb( selRGB[0], selRGB[1], selRGB[2] )
 
 
// Game Title
local gameTitleW = flw - crw - bbm - bbm
local gameTitleH = floor( bbh * 0.35 ) 
local gameTitle = fe.add_text( "[Title]", flx + bbm, flh - bbh + bbm, gameTitleW, gameTitleH )
gameTitle.align = Align.Left
gameTitle.style = Style.Regular
gameTitle.set_rgb(titRGB[0],titRGB[1],titRGB[2])
gameTitle.nomargin = true
gameTitle.charsize = floor(gameTitle.height * 1000/700)
gameTitle.font = "BebasNeueBold.otf"


// Game Year And Manufacturer
function year_formatted()
{
	local m = fe.game_info( Info.Manufacturer )
	local y = fe.game_info( Info.Year )

	if (( m.len() > 0 ) && ( y.len() > 0 ))
		return "© " + y + "  " + m

	return m
}

local gameYearW = flw - crw - bbm - floor( bbh * 2.875 )
local gameYearH = floor( bbh * 0.15 )
local gameYear = fe.add_text( "[!year_formatted]", flx + bbm, flh - bbm - gameYearH, gameYearW, gameYearH )
gameYear.align = Align.Left
gameYear.style = Style.Regular
gameYear.nomargin = true
gameYear.charsize = floor(gameYear.height * 1000/700)
gameYear.font = flh <= 600 ? "BebasNeueRegular.otf": "BebasNeueBook.otf"



// Category
local categoryW = floor( bth * 2.5 )
local categoryH = floor( bth * 0.25 )
local categoryX = floor(( flw - crw ) * 0.5 - categoryW * 0.5 + flx)
local categoryY = floor( bth * 0.5 ) - floor( categoryH * 0.5 )
local category = fe.add_text("[FilterName]", categoryX, categoryY, categoryW, categoryH )
category.align = Align.Centre
category.filter_offset = 0
category.style = Style.Regular
category.charsize = floor(category.height * 1000/701)
category.font = "BebasNeueBold.otf"

local categoryLeft = fe.add_text("[FilterName]", 0, categoryY, categoryW, categoryH )
categoryLeft.align = Align.Centre
categoryLeft.filter_offset = -1
categoryLeft.set_rgb(selRGB[0],selRGB[1],selRGB[2])
categoryLeft.style = Style.Regular
categoryLeft.charsize = floor(category.height * 1000/700)
categoryLeft.font = "BebasNeueBook.otf"

local categoryRight = fe.add_text("[FilterName]", 0, categoryY, categoryW, categoryH )
categoryRight.align = Align.Centre
categoryRight.filter_offset = 1
categoryRight.set_rgb(selRGB[0],selRGB[1],selRGB[2])
categoryRight.style = Style.Regular
categoryRight.charsize = floor(category.height * 1000/701)
categoryRight.font = "BebasNeueBook.otf"

local categoryLeft2 = fe.add_text("[FilterName]", 0, categoryY, categoryW, categoryH )
categoryLeft2.align = Align.Centre
categoryLeft2.filter_offset = -2
categoryLeft2.set_rgb(selRGB[0],selRGB[1],selRGB[2])
categoryLeft2.style = Style.Regular
categoryLeft2.charsize = floor(category.height * 1000/701)
categoryLeft2.alpha = 0
categoryLeft2.font = "BebasNeueBook.otf"

local categoryRight2 = fe.add_text("[FilterName]", 0, categoryY, categoryW, categoryH )
categoryRight2.align = Align.Centre
categoryRight2.filter_offset = 2
categoryRight2.set_rgb(selRGB[0],selRGB[1],selRGB[2])
categoryRight2.style = Style.Regular
categoryRight2.charsize = floor(category.height * 1000/701)
categoryRight2.alpha = 0
categoryRight2.font = "BebasNeueBook.otf"


local categoryGap = floor( bth * 0.225 )
categoryLeft.x = category.x - category.msg_width / 2 - categoryLeft.msg_width / 2 - categoryGap
categoryRight.x = category.x + category.msg_width / 2 + categoryRight.msg_width / 2 + categoryGap
categoryLeft2.x = categoryLeft.x - categoryLeft.msg_width / 2 - categoryLeft2.msg_width / 2 - categoryGap
categoryRight2.x = categoryRight.x + categoryRight.msg_width / 2  + categoryRight2.msg_width / 2 + categoryGap




// List Entry
local gameListEntryW = floor( bth * 2.5 )
local gameListEntryH = floor( bth * 0.25 )
local gameListEntryY = floor( bth / 2.0 ) - floor( gameListEntryH / 2 )
local gameListEntry = fe.add_text("[ListEntry]/[ListSize]", flx + flw - crw - gameListEntryW, gameListEntryY , gameListEntryW, gameListEntryH )
gameListEntry.align = Align.Right
gameListEntry.style = Style.Regular
gameListEntry.font = "BebasNeueLight.otf"
gameListEntry.charsize = floor(gameListEntry.height * 1000/700)




// Left Black Bar
local barLeft = fe.add_text( "", 0, 0, flx, flh)
barLeft.set_bg_rgb( 0, 0, 0 )


// Right Black Bar
local barRight = fe.add_text( "", flw + flx, 0, flx, flh)
barRight.set_bg_rgb( 0, 0, 0 )


// Category Animations
local categoryOvershot = 4
local categorySmoothing = 0.9
local categoryAnimX = Animate( category, "x", categoryOvershot, 0, categorySmoothing )
local categoryLeftAnimX = Animate( categoryLeft, "x", categoryOvershot, 0, categorySmoothing )
local categoryRightAnimX = Animate( categoryRight, "x", categoryOvershot, 0, categorySmoothing )
local categoryLeft2AnimX = Animate( categoryLeft2, "x", categoryOvershot, 0, categorySmoothing )
local categoryRight2AnimX = Animate( categoryRight2, "x", categoryOvershot, 0, categorySmoothing )
local categoryLeftAnimA = Animate( categoryLeft, "alpha", categoryOvershot, 0, categorySmoothing )
local categoryRightAnimA = Animate( categoryRight, "alpha", categoryOvershot, 0, categorySmoothing )
local categoryLeft2AnimA = Animate( categoryLeft2, "alpha", categoryOvershot, 0, categorySmoothing )
local categoryRight2AnimA = Animate( categoryRight2, "alpha", categoryOvershot, 0, categorySmoothing )

/////////////////////
//Video
/////////////////////

local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;

local snap = FadeArt( "snap", flx*0.035, fly*0.155, flw*0.65, flh*0.7 );
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = true; 
local flx = ( fe.layout.width - layout_width ) / 2
local fly = ( fe.layout.height - layout_height ) / 2
local flw = layout_width
local flh = layout_height
////////////////////////////////////////////////////////////////////////////////////////

// Wheel Image
local wheelScale = ( flw - crw * 2 ) < flh ? flw - crw * 2 : flh
local wheelImageW = floor( wheelScale * 0.3 )
local wheelImageH = floor( wheelScale * 0.3 )
local wheelImage = fe.add_artwork( "wheel" ,flx + bbm, bth - floor( wheelImageH / 2 ), wheelImageW, wheelImageH )
wheelImage.preserve_aspect_ratio = true

//wheelImage.trigger = Transition.EndNavigation
//wheelImage.trigger = 0

//local wheelImageAnimS = Animate( wheelImage, "scale", 0.01, 0, 0.9 )
//local wheelImageAnimA = Animate( wheelImage, "alpha", 1, 0, 0.9 )



// Transitions

fe.add_transition_callback( this, "on_transition" )

function on_transition( ttype, var, ttime ) {
	if( ttype == Transition.ToNewSelection) {
			gameListBoxAnimX.to = flw + flx - crw - lbw
			if ( glist_delay != 0 ) gameListBoxAnimX.hide( flw + flx - crw, fe.layout.time )
			gameListBoxAnimA.to = 255
			if ( glist_delay != 0 ) gameListBoxAnimA.hide( 0, fe.layout.time )
			gameListBoxBackgroundAnimX.to = flw + flx - crw - lbw
			if ( glist_delay != 0 ) gameListBoxBackgroundAnimX.hide( flw + flx - crw, fe.layout.time )
			gameListBoxBackgroundAnimA.to = 255
			if ( glist_delay != 0 ) gameListBoxBackgroundAnimA.hide( 0, fe.layout.time )
		}
		
	if( ttype == Transition.EndNavigation ) {

		update_artwork = true	
		update_counter = 0
	}
	
	if( ttype == Transition.ToNewList) {
		
		update_artwork = true	
		update_counter = 0
		

		if ( glist_delay != 0 ) gameListBoxAnimX.hide( flw + flx - crw, fe.layout.time )
		gameListBoxAnimA.from = 0
		gameListBoxAnimA.to = 255
		if ( glist_delay != 0 ) gameListBoxAnimA.hide( 0, fe.layout.time )
		if ( glist_delay != 0 ) gameListBoxBackgroundAnimX.hide( flw + flx - crw, fe.layout.time )
		gameListBoxBackgroundAnimA.from = 0
		gameListBoxBackgroundAnimA.to = 255
		if ( glist_delay != 0 ) gameListBoxBackgroundAnimA.hide( 0, fe.layout.time )
		
		if ( var < 0 ) {
			gameListBoxAnimX.from = flw + flx - crw - lbw * 2
			gameListBoxAnimX.to = flw + flx - crw - lbw
			gameListBoxBackgroundAnimX.from = flw + flx - crw - lbw * 2
			gameListBoxBackgroundAnimX.to = flw + flx - crw - lbw
			categoryAnimX.from = categoryX - category.msg_width * 0.5 - categoryRight.msg_width * 0.5 - categoryGap
			categoryAnimX.to = categoryX
			categoryLeftAnimA.from = 0
			categoryLeftAnimA.to = 255
			categoryLeft2AnimA.from = 0.01
			categoryLeft2AnimA.to = 0
			categoryRight2AnimA.from = 255
			categoryRight2AnimA.to = 0
		}
		
		if ( var > 0 ) {
			gameListBoxAnimX.from = flw + flx - crw
			gameListBoxAnimX.to = flw + flx - crw - lbw
			gameListBoxBackgroundAnimX.from = flw + flx - crw
			gameListBoxBackgroundAnimX.to = flw + flx - crw - lbw
			categoryAnimX.from = categoryX + category.msg_width * 0.5 + categoryLeft.msg_width * 0.5 + categoryGap
			categoryAnimX.to = categoryX
			categoryRightAnimA.from = 0
			categoryRightAnimA.to = 255
			categoryRight2AnimA.from = 0.01
			categoryRight2AnimA.to = 0
			categoryLeft2AnimA.from = 255
			categoryLeft2AnimA.to = 0
		}

		categoryLeftAnimX.from = categoryAnimX.from - category.msg_width / 2 - categoryLeft.msg_width / 2 - categoryGap
		categoryLeftAnimX.to = categoryAnimX.to - category.msg_width / 2 - categoryLeft.msg_width / 2 - categoryGap
		categoryRightAnimX.from = categoryAnimX.from + category.msg_width / 2 + categoryRight.msg_width / 2 + categoryGap
		categoryRightAnimX.to = categoryAnimX.to + category.msg_width / 2 + categoryRight.msg_width / 2 + categoryGap

		categoryLeft2AnimX.from = categoryLeftAnimX.from - categoryLeft.msg_width / 2 - categoryLeft2.msg_width / 2 - categoryGap
		categoryLeft2AnimX.to = categoryLeftAnimX.to - categoryLeft.msg_width / 2 - categoryLeft2.msg_width / 2 - categoryGap
		categoryRight2AnimX.from = categoryRightAnimX.from + categoryRight.msg_width / 2 + categoryRight2.msg_width / 2 + categoryGap
		categoryRight2AnimX.to = categoryRightAnimX.to + categoryRight.msg_width / 2 + categoryRight2.msg_width / 2 + categoryGap
	}
	
	if( ttype == Transition.ToNewSelection || Transition.ToNewList) {
		if (fe.game_info(Info.Favourite, var) == "1") favouriteIcon.visible = true else favouriteIcon.visible = false
	}
	return false
}
 






////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// HyperPi Cinematix by the Project HyperPie Group on Facebook
// https://www.facebook.com/groups/1158678304181964/
//  
////////////////////////////////////////////////////////////////////////////////////////////////////////   



local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;


 
//////////////////
///Extra Art Animation 1
//////////////////

/////////////////////////////////////////////////////
if ( my_config["enable_bigart"] == "Yes" ){
local bigart = fe.add_image(( "systems/[Title]"), flx*0.83, fly*0.85, flw*0.15, flh*0.15);
bigart.preserve_aspect_ratio = true;
bigart.trigger = Transition.EndNavigation;

local bigart_rotate_onload = {
    when = When.StartLayout,
    when = Transition.ToNewList,
    property = "rotation",
    start = 90,
    end = 0,
    time = 1500,
    tween = Tween.Expo
    loop=false
 }

if ( my_config["enable_bigartrotateonload"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigart_rotate_onload ) );
}

local bigartscale_onload = {
    when = When.StartLayout,
    when = Transition.ToNewList,
    property = "scale",
    start = 1.2,
    end = 1.0,
    time = 1000	
    tween = Tween.Quad,
}

local bigartfade_onload = {
    when = When.StartLayout,
    when = Transition.ToNewList,
	property = "alpha",
	delay = 500
	start = 255,
	end = 0,
	time = 1500,
	pulse = false
	loop = false
 }

if ( my_config["enable_bigartscaleonload"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartscale_onload ) );
}
if ( my_config["enable_bigartfadeonload"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartfade_onload ) );
}

local bigartscale = {
    when = Transition.EndNavigation,
    property = "scale",
    start = 1.2,
    end = 1.0,
    time = 500	
    tween = Tween.Quad,
	pulse = false
//	delay = 500
	
}

local bigartx = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*-0.1
    end = flx*0.06
    time = 1500,
    tween = Tween.Expo
	pulse = false
 }  
 
local bigartskew_x = {
    when = Transition.ToNewSelection ,
	property = "skew_x",
	start = 255,
    end = 0,
	time = 3000,
	loop = false
	pulse = false
 } 
 
local bigartfade = {
    when = Transition.ToNewSelection ,
	property = "alpha",
//	delay = 500
	start = 255,
	end = 0,
	time = 3000,
	pulse = false
	loop = false
 }
local bigartrotate = {
    when = Transition.ToNewSelection,
    property = "rotation",
    start = 90,
    end = 0,
    time = 1500,
    tween = Tween.Expo
    loop=false
 }
 

//Animation

if ( my_config["enable_bigartrotate"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartrotate ) );
}
if ( my_config["enable_bigartscale"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartscale ) );
}
if ( my_config["enable_bigartflyin"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartx ) );
animation.add( PropertyAnimation ( bigart, bigartskew_x ) );
}
if ( my_config["enable_bigartfade"] == "Yes" ){
animation.add( PropertyAnimation ( bigart, bigartfade ) );
}
}


//Display current time
if ( my_config["enable_clock"] == "Yes" ){
  local dt = fe.add_text( "", flx*0.65, fly*0.03, flw*0.3, flh*0.095 );
dt.align = Align.Centre
dt.filter_offset = 1
//dt.set_rgb(selRGB[0],selRGB[1],selRGB[2])
dt.style = Style.Regular
dt.charsize = floor(category.height * 1000/701)
dt.font = "BebasNeueBook.otf"

  local clock = fe.add_image ("clock.png",flx*0.73, fly*0.042, flw*0.040, flh*0.06);
  clock.preserve_aspect_ratio = true;
  clock.alpha = 240;
//  clock.set_rgb(titRGB[0],titRGB[1],titRGB[2])

function update_clock( ttime ){
  local now = date();
  dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min );
}
  fe.add_ticks_callback( this, "update_clock" );
}