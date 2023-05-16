my_list = [5,4,3,2,1,8,10,1,100]

def bubble_sort(my_list):
    for i in range(len(my_list)-1,0,-1):
        for j in range(i):
            if my_list[j] > my_list[j+1]: #if jth element is greater than j+1th element
                temp = my_list[j+1] #swap
                my_list[j+1] = my_list[j]
                my_list[j] = temp
    return my_list

print(bubble_sort(my_list))

def bubble_sort_new(my_list):
    for i in range(len(my_list)-1,0,-1):
        for j in range(i):
            if my_list[j] > my_list[j+1]:
                temp = my_list[j+1]
                my_list[j+1] = my_list[j]
                my_list[j] = temp
    print(my_list)


bubble_sort_new(my_list)