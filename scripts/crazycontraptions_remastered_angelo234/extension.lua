local M = {}

local fuel_types = {
	{engine="petrol", fuel="petrol"},
	{engine="diesel", fuel="diesel"},
	{engine="electric", fuel="battery"}
}

string.strEndsWith = function(s, suffix)
	return s:lower():sub(-string.len(suffix:lower())) == suffix:lower()
end

local function getFuelTypeFromPart(slot_name, part_name)
	if slot_name:strEndsWith("fueltank") then
					
		if part_name:match("petrol") then
			return fuel_types[1]
			
		elseif part_name:match("diesel") then
			return fuel_types[2]
		
		elseif part_name:match("battery") then
			return fuel_types[3]
		
		else
			return fuel_types[1]
		end

	elseif slot_name:strEndsWith("engine") then

		if part_name:match("petrol") then
			return fuel_types[1]
			
		elseif part_name:match("diesel") then
			return fuel_types[2]
		
		elseif part_name:match("electric") then
			return fuel_types[3]
		
		else
			return fuel_types[1]
		end
	
	elseif slot_name:match("differential") then

		if part_name:match("electric") then
			return fuel_types[3]	
			
		else
			-- Pick to use either petrol or diesel fuel randomly
			local val = math.random()
			
			if val >= 0.5 then
				return fuel_types[1]
			else
				return fuel_types[2]
			end

		end
	end
	
	return nil
end

local function randomizeVehicleParts()
	-- Gets vehicle's name
	local carname = be:getPlayerVehicle(0):getJBeamFilename()
	
	local config = extensions.core_vehicle_partmgmt.getConfig()
	
	-- Get all slots
	local all_slots = require('jbeam/io').getAvailableSlotMap(extensions.core_vehicle_manager.getPlayerVehicleData().ioCtx)
	
	local fuel_type = nil
	
	-- Cycle through each slot
	for slot_name, curr_part in pairs(config.parts) do
		local parts_for_slot = all_slots[slot_name]
		
		if parts_for_slot then

			if fuel_type and slot_name:strEndsWith("fueltank") then
				
				local keyset = {}
					
				for part_k, part in pairs(parts_for_slot) do
					if part:match(fuel_type.fuel) then
						table.insert(keyset, part_k)   
					end
				end
				
				-- If no fueltanks matched the fuel type, find petrol fueltanks
				if #keyset == 0 then
					for part_k, part in pairs(parts_for_slot) do
						local has_match = false
					
						for _, a_fuel_type in pairs(fuel_types) do
							if part:match(a_fuel_type.fuel) then
								has_match = true
							end
						end
					
						if not has_match then
							table.insert(keyset, part_k)
						end
					end
				end
				
				local random_part = parts_for_slot[keyset[math.random(#keyset)]]
				
				config.parts[slot_name] = random_part

			elseif fuel_type and slot_name:strEndsWith("engine") then
				local keyset = {}
					
				for part_k, part in pairs(parts_for_slot) do
					if part:match(fuel_type.engine) then
						table.insert(keyset, part_k)   
					end
				end
				
				-- If no engines matched the fuel type, find petrol engines
				if #keyset == 0 then
					for part_k, part in pairs(parts_for_slot) do
						local has_match = false
					
						for _, a_fuel_type in pairs(fuel_types) do
							if part:match(a_fuel_type.engine) then
								has_match = true
							end
						end
					
						if not has_match then
							table.insert(keyset, part_k)
						end
					end
				end
				
				local random_part = parts_for_slot[keyset[math.random(#keyset)]]			
				config.parts[slot_name] = random_part
			
			elseif fuel_type and slot_name:match("differential") then
				if fuel_type.fuel == fuel_types[3].fuel then
					-- Any differential for electric vehicle
				
					local keyset = {}
					
					for part_k, part in pairs(parts_for_slot) do
						table.insert(keyset, part_k)   
					end
					
					local random_part = parts_for_slot[keyset[math.random(#keyset)]]			
					config.parts[slot_name] = random_part
					
				else
					-- If not electric vehicle, don't choose electric motor
				
					local keyset = {}
					
					for part_k, part in pairs(parts_for_slot) do
						if not part:match(fuel_types[3].engine) then
							table.insert(keyset, part_k)   
						end
					end
					
					local random_part = parts_for_slot[keyset[math.random(#keyset)]]			
					config.parts[slot_name] = random_part
					
				end
				
			else
				-- Get random part
				local keyset = {}
				for k in pairs(parts_for_slot) do
					table.insert(keyset, k)         
				end
				
				local random_part = parts_for_slot[keyset[math.random(#keyset)]]

				-- Set fuel type for other parts based on random part fuel type if not set
				if not fuel_type then
					fuel_type = getFuelTypeFromPart(slot_name, random_part)
				end

				config.parts[slot_name] = random_part
			end         
		end
	end
	
	extensions.core_vehicle_partmgmt.setPartsConfig(config.parts, true)
end

M.randomizeVehicleParts = randomizeVehicleParts

return M