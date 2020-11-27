#include "script_component.hpp"
/*
 * Author: nkenny
 * Unit repositions to a new advantagous position inside a building
 *
 * Arguments:
 * 0: unit hiding <OBJECT>
 * 1: source of danger <OBJECT> or position <ARRAY>
 *
 * Return Value:
 * unit
 *
 * Example:
 * [bob, angryJoe] call lambs_danger_fnc_doReposition;
 *
 * Public: No
*/
params ["_unit", ["_target", ObjNull, [objNull, []]]];

// enemy
if (isNull _target) then {
    _target = _unit findNearestEnemy _unit;
};

// get building positions
private _buildingPos = [_unit, 21, true, true, true] call EFUNC(main,findBuildings);
[_buildingPos, true] call CBA_fnc_shuffle;

// Check if there is a closer building position
private _distance = (_unit distance2D _target) - 0.25;
private _destination = _buildingPos findIf {_x distance2D _target < _distance};
if (_destination != -1) then {
    _unit doMove ((_buildingPos select _destination) vectorAdd [-1 + random 2, -1 + random 2, 0]);
    _unit setVariable [QGVAR(currentTarget), _buildingPos select _destination, EGVAR(main,debug_functions)];
    _unit setVariable [QGVAR(currentTask), "Repositioning", EGVAR(main,debug_functions)];
} else {
    // stay indoors
    _unit setVariable [QGVAR(currentTask), "Stay inside (reposition)", EGVAR(main,debug_functions)];
};

// toggle stance
_unit setUnitPosWeak selectRandom ["UP", "UP", "MIDDLE"];

// end
_unit