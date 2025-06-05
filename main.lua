local Launcher = {}

function Launcher:init()
    self.resources = getResources()
    self.isInitializing = true
    self.startedResource = 0
    self.priority = {}
    -- example: self.priority = {"mysql", "anticheat"} 

    for _, resourceName in ipairs(self.priority) do
        local resource = getResourceFromName(resourceName)
        if resource and getResourceState(resource) ~= "running" then
            if startResource(resource) then
                self.startedResource = self.startedResource + 1
            end
        end
    end

    for _, resource in ipairs(self.resources) do
        local resourceName = getResourceName(resource)
        if getResourceState(resource) ~= "running" then
            if startResource(resource) then
                self.startedResource = self.startedResource + 1
            end
        end
    end

    outputDebugString("[!] ========== A TOTAL OF " .. self.startedResource .. " RESOURCES HAVE BEEN LAUNCHED ========== [!]")

    self.resources = nil
    self.isInitializing = false
end
addEventHandler("onResourceStart", resourceRoot, function() Launcher:init() end)

function Launcher:serverConnect()
    if self.isInitializing then
        cancelEvent(true, "Please wait while the server is being prepared.")
    end
end
addEventHandler("onPlayerConnect", root, function() Launcher:serverConnect() end)
