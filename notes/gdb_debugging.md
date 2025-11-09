# Notes on Debugging with gdb

##### Verify that debugging information is included in the executable
-	`$ file [program_name]`  

##### 4 Ways to Start gdb
1.	`$ gdb [program_name]`
2. 	`$ gdb -slient [program_name]`
3. 	`$ gdb -tui -slient [program_name]`
3. 	`$ sudo gdb -tui -slient [program_name]`

##### Creating custom gdb commands
1.	create the file, `.gdbinit` in the root directory



