TemplateUI = class("TemplateUI")
TemplateUI.__index = TemplateUI
 

function TemplateUI.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TemplateUI)
    return target
end

function TemplateUI:initFromCsb()
	self._widget = cc.CSLoader:createNode("ui/xxxxxx.csb")
	if self._widget == nil then return false; end
	local frameSize = cc.Director:getInstance():getVisibleSize()
	self._widget : setContentSize(frameSize)
	ccui.Helper:doLayout( self._widget )

  
end

function TemplateUI:loadData()

end

function TemplateUI:AddTouchEventListener()
    local function OnBackButtonPressed(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:removeFromParent()
        end
    end
end

function TemplateUI:onEnter()
    TemplateUI._layer = self
end

function TemplateUI:onExit()
    TemplateUI._layer = nil
    collectgarbage("collect")
end

function TemplateUI:init()
	self:initFromCsb()
    self:loadData()
    self:AddTouchEventListener()
	self:addChild(self._widget)
    local function onNodeEvent(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end
    self._widget:registerScriptHandler(onNodeEvent)
end

 
function createTemplateUI()
    local ui_layer = TemplateUI.extend(cc.Layer:create())
    ui_layer:init()
    return ui_layer
end

 
