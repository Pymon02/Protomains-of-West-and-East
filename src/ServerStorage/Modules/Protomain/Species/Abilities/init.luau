local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Types = require(ServerStorage.Modules.Protomain.Battle.Types)
local Move = require(ServerStorage.Modules.Protomain.Species.Moves.Move)
local Typing = require(ReplicatedStorage.Modules.Protomains.Typing)
local Ability = require(script.AbilityConstructor)
local Protomain = require(script.Parent.Parent)
local Utils = require(ReplicatedStorage.Modules.Utils.Utils)

local Abilties = {}

Abilties.Timid = Ability.new({
	battleStart = function(abilityOwner: Typing.Protomain)
		local isHitWithEffectiveMove = false

		return {
			Move.events.calculateAttackTyping.connect(
				function(typing: number, _attacker: Typing.Protomain, defender: Typing.Protomain)
					if defender == abilityOwner and typing >= 2 then
						isHitWithEffectiveMove = true
					end
				end
			),

			Move.events.dealDamagingMove.connect(
				function(_attacker: Typing.Protomain, _target: Typing.Protomain, _mult: number?)
					if isHitWithEffectiveMove then
						print(abilityOwner.evolution.name .. " is Timid")
						Protomain.stageChange(abilityOwner, "meleeAttack", -1)
						Protomain.stageChange(abilityOwner, "speed", 2)
						isHitWithEffectiveMove = false
					end
				end
			),
		}
	end,
	description = "When hit by a super effective move, the user's attack goes down by 1 stage but its speed rises by 2 stages.",
})

Abilties.MagicPower = Ability.new({
	battleStart = function(abilityOwner: Typing.Protomain)
		return Move.events.dealDamagingMove.connectBefore(
			function(attacker: Typing.Protomain, _defender: Typing.Protomain, mult: number?)
				if attacker == abilityOwner and attacker.move.type_ == Types.Mystic then
					return { [3] = Utils.oneIfNil(mult) + 0.50 }
				end
				return {}
			end
		)
	end,
	-- beforeEvent=function(event: Event.AbilityEvent)
	-- 	local isDamageMove = event.name == 'damageMove'
	-- 	local ownerIsAttacking = event.abilityOwner == event.parameters.attacker

	-- 	if isDamageMove and ownerIsAttacking and event.parameters.attacker.move.type_.name == 'Mystic' then
	-- 		print(`Magic Power increased {event.abilityOwner.evolution.name}'s attack!`)
	-- 		return {damageMult=Utils.oneIfNil(event.parameters.damageMult) + 0.5}
	-- 	end
	-- end,
	description = "The users Mystic type moves are boosted by 50%.",
})

Abilties.LegDominace = Ability.new({
	battleStart = function(abilityOwner: Typing.Protomain)
		return Move.events.dealDamagingMove.connectBefore(
			function(attacker: Typing.Protomain, _defender: Typing.Protomain, mult: number?)
				if attacker == abilityOwner and attacker.move.bodyPart == "legs" then
					print(`Leg Dominace increased {abilityOwner.evolution.name}'s attack!`)
					return { [3] = Utils.oneIfNil(mult) + 0.50 }
				end
				return {}
			end
		)
	end,
	description = "Moves that involve the user using their legs to attack have a boosted power of 50%.",
})

-- Ability.new{
-- 	name='Static Fuzz',

-- 	func=function(input: Ability.AbilityFunctionInput)
-- 		if input.move.bodyPart == 'legs' then
-- 			input.move.damageBoost += 0.5 -- TODO STATUS EFFECTS
-- 		end
-- 	end,
-- 	description="When the user is hit by a move that makes physicalContact, the foe has a 50% of getting paralyzed."
-- }

--Ability.new{
--	name='Sharp Claws',
--	func=function(input: Ability.AbilityFunctionInput)
--		if input.move.bodyPart == 'claws' or input.move.bodyPart == 'nails' then
--			input.move.damageBoost += 0.5
--		end
--	end,
--	description="Moves that involve the user using its claws/nails to attack has a boosted power of 50% percent."
--}

--Ability.new{
--	name='Raging Flame',
--	func=function(input: Ability.AbilityFunctionInput)
--		if (Protomain.getHealth(input.user) < Protomain.getMaxHealth(input.user) / 3)
--		and input.move.type_.name == 'Fire' then
--			input.move.damageBoost += 0.6
--		end
--	end,
--	description="Moves that involve the user using its claws/nails to attack has a boosted power of 50% percent."
--}

----Squirm
---- Effect: When the user is trapped it will be immediately set free.
----Ceo of Gushlings — 12/19/2021 9:09 AM
----Bully
----Effect: If the user is bigger than the foe the user's attacks will do more damage.

--Ability.new{
--	name='Lumination',
--	func=function(input: Ability.AbilityFunctionInput)
--		if input.move.type_.name == 'Dark' then
--			input.move = nil --move canceled
--		end
--	end,
--	on='allMoves',
--	activations={min=2, max=5},
--	description=
--		"When the user is sent into battle, it will illuminate the field hurting dark types a little and no dark moves can be used for 2-5 turns."
--}

--Ability.new{
--	name='Cold Heart',
--	func=function(input: Ability.AbilityFunctionInput)
--		if input.previousMove.typing.name == 'Ice' then
--			-- freeze
--			Function.createStageMove(2, 'meleeDefense')
--			Function.createStageMove(2, 'rangedDefense')
--		end
--	end,
--	description="When the user gets hit by an ice type damaging move they will become frozen but will receive a melee and ranged defense boost sharply."
--}

--Ability.new{
--	name='Love Touch',
--	func=Function.createChance(0.5,
--		function(input: Ability.AbilityFunctionInput)
--			local oppositeGender = (input.user.evolution.isMale ~= input.previousMove.user.evolution.isMale)
--			if input.previousMove.physicalContact and oppositeGender then
--				-- fall in love
--			end
--		end
--	),
--	description=
--		"When the user is hit by a move that makes physicalContact, the foe has a 50% chance of falling in love if the user and foe are the opposite gender."
--}

--Ability.new{
--	name='Timid',
--	afterEvent=function(event: Event.AbilityEvent)
--		local isDamageMove = event.name == 'damageMove'
--		local ownerIsBeingHit = event.abilityOwner == event.parameters.target
--		local moveIsSuperEffective = event.parameters.typing == 2

--		if isDamageMove and ownerIsBeingHit and moveIsSuperEffective then
--			Protomain.stageChange(event.abilityOwner, "meleeAttack", -1)
--			Protomain.stageChange(event.abilityOwner, "speed", 2)
--		end
--	end,
--	description="When hit by a super effective move, the user's attack goes down by 1 stage but its speed rises by 2 stages."
--}

--Ability.new{
--	name='Magic Power',
--	beforeEvent=function(event: Event.AbilityEvent)
--		local isDamageMove = event.name == 'damageMove'
--		local ownerIsAttacking = event.abilityOwner == event.parameters.attacker

--		if isDamageMove and ownerIsAttacking and event.parameters.attacker.move.type_.name == 'Mystic' then
--			print(`Magic Power increased {event.abilityOwner.evolution.name}'s attack!`)
--			return {damageMult=Utils.oneIfNil(event.parameters.damageMult) + 0.5}
--		end
--	end,
--	description="The users Mystic type moves are boosted by 50%."
--}

--Ability.new{
--	name='Leg Dominace',
--	beforeEvent=function(event: Event.AbilityEvent)
--		local isDamageMove = event.name == 'damageMove'
--		local ownerIsAttacking = event.abilityOwner == event.parameters.attacker
--		local isLegMove = event.abilityOwner.move.bodyPart == 'legs'

--		if isDamageMove and ownerIsAttacking and isLegMove then
--			print(`Leg Dominace increased {event.abilityOwner.evolution.name}'s attack!`)
--			return {damageMult=Utils.oneIfNil(event.parameters.damageMult) + 0.5}
--		end
--	end,
--	description="Moves that involve the user using their legs to attack have a boosted power of 50%."
--}

----Ability.new{
----	name='Static Fuzz',

----	func=function(input: Ability.AbilityFunctionInput)
----		if input.move.bodyPart == 'legs' then
----			input.move.damageBoost += 0.5 -- TODO STATUS EFFECTS
----		end
----	end,
----	description="When the user is hit by a move that makes physicalContact, the foe has a 50% of getting paralyzed."
----}

----Ability.new{
----	name='Sharp Claws',
----	func=function(input: Ability.AbilityFunctionInput)
----		if input.move.bodyPart == 'claws' or input.move.bodyPart == 'nails' then
----			input.move.damageBoost += 0.5
----		end
----	end,
----	description="Moves that involve the user using its claws/nails to attack has a boosted power of 50% percent."
----}

----Ability.new{
----	name='Raging Flame',
----	func=function(input: Ability.AbilityFunctionInput)
----		if (Protomain.getHealth(input.user) < Protomain.getMaxHealth(input.user) / 3)
----		and input.move.type_.name == 'Fire' then
----			input.move.damageBoost += 0.6
----		end
----	end,
----	description="Moves that involve the user using its claws/nails to attack has a boosted power of 50% percent."
----}

------Squirm
------ Effect: When the user is trapped it will be immediately set free.
------Ceo of Gushlings — 12/19/2021 9:09 AM
------Bully
------Effect: If the user is bigger than the foe the user's attacks will do more damage.

----Ability.new{
----	name='Lumination',
----	func=function(input: Ability.AbilityFunctionInput)
----		if input.move.type_.name == 'Dark' then
----			input.move = nil --move canceled
----		end
----	end,
----	on='allMoves',
----	activations={min=2, max=5},
----	description=
----		"When the user is sent into battle, it will illuminate the field hurting dark types a little and no dark moves can be used for 2-5 turns."
----}

----Ability.new{
----	name='Cold Heart',
----	func=function(input: Ability.AbilityFunctionInput)
----		if input.previousMove.typing.name == 'Ice' then
----			-- freeze
----			Function.createStageMove(2, 'meleeDefense')
----			Function.createStageMove(2, 'rangedDefense')
----		end
----	end,
----	description="When the user gets hit by an ice type damaging move they will become frozen but will receive a melee and ranged defense boost sharply."
----}

----Ability.new{
----	name='Love Touch',
----	func=Function.createChance(0.5,
----		function(input: Ability.AbilityFunctionInput)
----			local oppositeGender = (input.user.evolution.isMale ~= input.previousMove.user.evolution.isMale)
----			if input.previousMove.physicalContact and oppositeGender then
----				-- fall in love
----			end
----		end
----	),
----	description=
----		"When the user is hit by a move that makes physicalContact, the foe has a 50% chance of falling in love if the user and foe are the opposite gender."
----}

for name, ability in Abilties do
	ability.name = name
end

return Abilties
