# DBMS
### lab01

Purpose of this lab was to create a database with information about airports and races. As an additional requirement database has to be
in 3NF, has to have at least 3 views, 3 procedures, 3 functions and 3 triggers. Also had to be must've been ensured database integrity
and data validity.
#
Views:
* ariport_info: shows ___airport location___, ___chiefs name___, ___contacts___ and ___planes___ for every ___airport___
* check_routes: shows character representation of `routes` table
* inventory_check: shows ___planes___, their ___amount___ and ___capacity___ for every ___airport___
###
Procedures:
* add_plane: adds in `inventory` table entry specified plane model for specified airport in specified amount
* change_chief: _removes_ old chief from `chiefs` table and _inserts_ the new one for specified airport
* create_route: adds to `routes` table 2 entries: route from ___departure point___ to ___destination___ and vice versa
###
Triggers:
* chiefs_audit: when in `chiefs` table entry being _updated_ or _inserted_, operation info inserted to `chiefs_log` table
* disable_route: sets ___is_active___ on false parameter in `routes` table for specified row
* safe_update: supplies an interface which forbids to _update_ entries in `routes` table with ___is_active___ = false
* week_day_check: when _insert_ or _update_ operation occures with `routes` table checks if the ___race_day___ parameter is written correctly
###
Functions chiefs_audit_func, disable_route_func, safe_update_func and week_day_check_func process the actions for corresponding trigger.