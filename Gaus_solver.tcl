#include <tcl.h>

set script_root "/home/student_id/training/Koryun/gaus/TCL_VERSION"

# Read Content from file
proc read_from_file {argv} {
	set filename [lindex $argv 0]
	catch {set file [open $filename]
	} result
	set line [read $result]
	set parsing_values [split $line "\s"]
	return $parsing_values
}

# Write data in file
proc write_data { file_name output_data } {
	set fp [open $file_name a]
	puts $fp $output_data
	close $fp
}

# Deleting previous generating files
proc clean_up {} {
	global script_root
	file delete -force "${script_root}/output.txt"
	file delete -force "${script_root}/result.txt"
}

proc initialize_value {argv} {
	set expression [read_from_file $argv ]
	set wordList [regexp -inline -all -- {\S+} $expression]
	set y {}
	foreach x $wordList {
		lappend y $x
	}
	return $y
}

proc initalize_matrix {a} {
	set rows [lindex $a 1]
	set mylist {}
	set index 1
	for {set i 0} {$i < $rows} {incr i} {
		set row {}
		for {set j 0} {$j <  [expr $rows + 1]} {incr j} {
			lappend row  [lindex $a [incr index]]
		}
		lappend mylist $row
	}
	return $mylist
}

proc Gaus_Solver {mat n} {
	set flag 0
	for {set i 0} {$i < $n} {incr i} {
		if {[lindex [lindex $mat $i] $i] == 0} {
			set c 1
		while { [expr $i + $c] < $n &&  [lindex [lindex $mat [expr $i + $c] $i]] == 0} {
				incr c
		}
			if {[expr $i + $c] == $n} {
				set flag 1
				break
			}
			for {set k 0} {$k <= $n} {incr k} {
				set j $i
				set temp [lindex [lindex $mat $j] $k] 
				lset mat $j $k [lindex [lindex $mat [expr $j + $c] $k] 
				lset mat [expr $j + $c] $k $temp 
			}
		}
		for {set j 0} {$j < $n} {incr j} {
			if {$i != $j} {
				set p [expr [lindex [lindex $mat $j] $i] / \
                                      [lindex [lindex $mat $i] $i] ]
				for {set k 0} {$k <= $n} {incr k} { 
					lset  mat $j $k [expr [lindex [lindex $mat $j] $k] - \
				        [expr [lindex [lindex $mat $i] $k] * $p ] ]
	       }
			
			}
		}	
	}
	if {$flag == 1} {
		set flag [CheckConsistency $mat $n $flag]
	}
	return $mat
}

proc result_checker {mat n} {
	set list_result {}
	for {set i 0} {$i < $n} {incr i} {
		for {set j 0} {$j < $n} {incr j} {

			if {$i == 0 && [ lindex [ lindex $mat $i] $j] != 0} {
				set x1 [expr [lindex [lindex $mat $i] $n] / \
				       [lindex [lindex $mat $i] $j] ]
				lappend list_result $x1
			}
			if {$i == 1 && [lindex [lindex $mat $i] $j] != 0} {
				set x2 [expr [lindex [lindex $mat $i] $n] / \
				       [lindex [lindex $mat $i] $j] ]
				lappend list_result $x2
			}
			if {$i == 2 && [lindex [lindex $mat $i] $j] != 0} {
				set x3 [expr [lindex [lindex $mat $i] $n] / \
				       [lindex [lindex $mat $i] $j] ]
				lappend list_result $x3
			}
			if {$i == 3 && [lindex [lindex $mat $i] $j] != 0} {
				set x4 [expr [lindex [lindex $mat $i] $n] / \
				       [lindex [lindex $mat $i] $j] ]
				lappend list_result $x4
			}
			if {$i == 4 && [lindex [lindex $mat $i] $j] != 0} {
				set x5 [expr [lindex [lindex $mat $i] $n] / \
				       [lindex [lindex $mat $i] $j] ]
				lappend list_result $x5
			}
		}
	}
	return $list_result
}

proc test_result {input_data} {
	set matrix [initalize_matrix $input_data]
	set rows [lindex $input_data 1]
	set res [Gaus_Solver $matrix $rows]
	set result [result_checker $res $rows]
	global script_root
	set fp [open "${script_root}/golden.txt" r]
	set y [read $fp]
	close $fp
	set wordList [regexp -inline -all -- {\S+} $y]
	write_data "${script_root}/output.txt"	$result
	set golden_result {}
	foreach x $wordList {
		lappend golden_result $x
	}
	if {$result == $golden_result} {
		write_data "${script_root}/result.txt" "$matrix  result -->  $result   Passed"
	} else {
		write_data "${script_root}/result.txt" "$matrix  result --> $result    Failed"
	}
}

proc CheckConsistency {mat n flag} {
	set flag 3
	for {set i  0} {$i < $n} {incr i} {
                set sum  0
                for {set j  0} {$j < $n} {incr j} {
                       set sum [expr $sum + [lindex [lindex $mat $i] $j ]]
                	if { $sum == [lindex [lindex $mat $i] $j ] } {
                        	set flag  2
			}
		}
         }
         return $flag
}

proc main {argv} {
	clean_up
	set input_data [initialize_value $argv ]
	test_result $input_data
}

main $argv
