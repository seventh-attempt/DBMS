# DBMS
### lab01

Purpose of this lab was to create a database with information about airports and races. As an additional requirement database has to be
in 3NF, has to have at least 3 views, 3 procedures, 3 functions and 3 triggers. Also had to be must've been ensured database integrity
and data validity.
###
### Tables:
* `ariports`
* `chiefs`
* `chiefs_log`
* `contacts`
* `inventory`
* `planes`
* `routes`
###
### Views:
* `ariport_info`: shows ___airport location___, ___chiefs name___, ___contacts___ and ___planes___ for every ___airport___
* `check_routes`: shows character representation of `routes` table
* `inventory_check`: shows ___planes___, their ___amount___ and ___capacity___ for every ___airport___
###
### Procedures:
* `add_plane`: adds in `inventory` table entry specified plane model for specified airport in specified amount
* `change_chief`: _removes_ old chief from `chiefs` table and _inserts_ the new one for specified airport
* `create_route`: adds to `routes` table 2 entries: route from ___departure point___ to ___destination___ and vice versa
###
### Functions:
* `chiefs_audit_func`: writes operation info in `chiefs_log` table
* `disable_route_func`: sets ___is_active___ = false in `routes` table for specified row
* `safe_update_func`: supplies an interface which forbids to _update_ entries in `routes` table with ___is_active___ = false
* `week_day_check_func`: checks if the ___race_day___ parameter is written correctly
###
### Triggers:
* `chiefs_audit`: triggers `chiefs_audit_func` after _insert_ or _update_ operation completed on `chiefs` table
* `disable_route`: waits for _delete_ operation on `routes` table and then runs `disable_route_func_` instead
* `safe_update`: instead of _update_ operation on `routes` table runs `safe_update_func`
* `week_day_check`: when _insert_ or _update_ operation occures with `routes` table runs `week_day_check_func` instead 
###
### Verification section:
* contains some test queries that helps to ensure in lab correctness
###
### Drop section:
* contains queries that drop all dependencies and then deletes the scema
