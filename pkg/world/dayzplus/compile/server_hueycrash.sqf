	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray"];
	
	if (isDedicated) then {
	_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
	_veh = createVehicle ["UH1YWreck_DZ",_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID",1,true];
	dayzFire = [_veh,2,time,false,false];
	publicVariable "dayzFire";
	if (isServer) then {
		nul=dayzFire spawn BIS_Effects_Burn;
	};
	
	_num = round(random 4) + 3;
	_config = 		configFile >> "CfgBuildingLoot" >> "UH1YCrash";
	_itemType =		[] + getArray (_config >> "itemType");
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	_weights = [];
	_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
	for "_x" from 1 to _num do {
		_index = _weights call BIS_fnc_selectRandom;
		if (count _itemType > _index) then {
			_iArray = _itemType select _index;
			_iArray set [2,_position];
			_iArray set [3,5];
			_iArray call spawn_loot;
			_nearby = _position nearObjects ["WeaponHolder",20];
			{
				_x setVariable ["permaLoot",true];
			} forEach _nearBy;
		};
	};
	};
};