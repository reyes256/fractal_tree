#!/bin/bash

declare -A matrix

# create a create_matrix function to create the matrix
# the matrix is a 2D array with 63 rows and 100 columns
# add a "_" to each cell of the matrix
function create_matrix {
    for (( i=0; i<63; i++ ))
    do
        for (( j=0; j<100; j++ )) 
        do
            matrix[$i,$j]="_"
        done
    done
}

# create a print_matrix function to print the matrix
# in the first iteration of the rows iterate all the columns and print a break line
# use the printf command to print the matrix and for the break line
function print_matrix {
    for (( i=0; i<63; i++ ))
    do
        for (( j=0; j<100; j++ ))
        do
            printf "${matrix[$i,$j]}"
        done
        printf "\n"
    done
}

# the fractal function receives the following parameters:
#   rows = last row of the matrix
#   center = center column of the matrix
#   branch_height = height of the branch
#   iterations = number of iterations of the fractal
# store the values of the parameters in local variables
function fractal {
    local rows=$1
    local center=$2
    local branch_height=$3
    local iterations=$4

    # if iterations is equal to cero exit the function with 0 status code
    if [ $iterations -eq 0 ]; then
        return 0
    fi

    # Create main branch
    # iterate over the branch height
    for (( i=0; i<$branch_height; i++ ))
    do
        # assign 1 to the matrix cell where:
        #   the x axis is equal to the current row minus the index of the loop
        #   the y axis is equal to the current center column
        matrix[$(($rows - $i)),$center]="1"
    done

    # Create left branch
    # iterate over the branch height
    # assign 1 to the matrix cell where:
    #   the x axis is equal to the result of the subtraction of the rows, branch height and the index of the loop
    #   the y axis is equal to the result of the subtraction of the current center column, the index of the loop and 1
    for (( i=0; i<$branch_height; i++ ))
    do
        matrix[$(($rows - $branch_height - $i)),$(($center - $i - 1))]="1" 
    done

    # With the same logic as the left branch, create the right branch
    for (( i=0; i<$branch_height; i++ ))
    do
        matrix[$(($rows - $branch_height - $i)),$(($center + $i + 1))]="1"
    done

    # Create new fractal on top of left branch
    # Call the fractal function with the parameters as follows:
    #   new last row = rows - branch_height * 2
    #   new center column = center - branch_height
    #   new branch height = branch_height / 2
    #   new number of iterations = iterations - 1
    fractal $(($rows - $branch_height * 2)) $(($center - $branch_height)) $(($branch_height / 2)) $(($iterations - 1))

    # Create new fractal on top of right branch
    fractal $(($rows - $branch_height * 2)) $(($center + $branch_height)) $(($branch_height / 2)) $(($iterations - 1)) # Ya definiendo la anterior no hay necesidad de volverle a explicar
}


# create a main function to call the other functions
# call the create_matrix function with the values of 63 and 100 as parameters
# read user input as "iterations"
# call the fractal function with the following values:
#   last row = 62
#   center column = 49
#   branch height = 16
#   number of iterations = iterations
# call the print_matrix function with the values of 63 and 100 as parameters
function main {
    create_matrix
    read iterations
    fractal 62 49 16 $iterations
    print_matrix
}
main