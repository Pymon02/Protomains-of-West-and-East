local Ability = {}

local Modules = game:GetService("ReplicatedStorage").Modules

local Typing = require(Modules.Protomains.Typing)

--[[
	Create a new ability.
]]
function Ability.new(array)
	local self = array :: Typing.Ability

	return self
end

return Ability

-- for _, protomain in self.allProtomains do
--     for _, ability in protomain.abilities do
--         ability.battleStart(protomain)
--     end
-- end

