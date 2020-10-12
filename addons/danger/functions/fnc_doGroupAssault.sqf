#include "script_component.hpp"
/*
 * Author: nkenny
 * Actualises assault cycle
 *
 * Arguments:
 * 0: Units list <ARRAY>
 * 1: List of building/enemy positions <ARRAY>
 * 2: Cycles <NUMBER>
 *
 * Return Value:
 * bool
 *
 * Example:
 * [units bob] call lambs_danger_fnc_doGroupAssault;
 *
 * Public: No
*/
params ["_cycle", "_units", "_pos"];

// update
_units = _units select {_x call EFUNC(main,isAlive) && {!isPlayer _x}};
_cycle = _cycle - 1;

{
    private _targetPos = selectRandom _pos;

    // setpos
    _x doMove _targetPos;
    _x setDestination [_targetPos, "FORMATION PLANNED", false]; // added to reduce cover bounding - nkenny

    // manoeuvre
    _x forceSpeed ([2, 4] select (getSuppression _x > 0 || {_x distance _targetPos < 35}));
    _x setUnitPosWeak "UP";
    _x setVariable [QGVAR(currentTask), "Group Assault", EGVAR(main,debug_functions)];
    _x setVariable [QGVAR(forceMove), true];

    // brave!
    _x setSuppression 0;

} foreach _units;

// recursive cyclic
if (_cycle > 0 && {!(_units isEqualTo [])}) then {
    [
        {_this call FUNC(doGroupAssault)},
        [_cycle, _units, _pos],
        8 + random 4
    ] call CBA_fnc_waitAndExecute;
};
