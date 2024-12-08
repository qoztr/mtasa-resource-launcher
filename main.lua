local Launcher = {
    resources = nil,
    isInitializing = false,
    startedResource = 0,
    priority = {} --// Prioritized resources
    -- example: priority = {"mysql", "anticheat"} 
}

Launcher._function = {
    init = function() Launcher:init() end,
    serverConnect = function() Launcher:serverConnect() end,
}

function Launcher:init()
    self.resources = getResources()
    self.isInitializing = true
    self.startedResource = 0

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

addEventHandler("onResourceStart", resourceRoot, Launcher._function.init)

function Launcher:serverConnect()
    if self.isInitializing then
        cancelEvent(true, "Please wait while the server is being prepared.")
    end
end

addEventHandler("onPlayerConnect", root, Launcher._function.serverConnect)