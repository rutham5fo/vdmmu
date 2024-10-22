import math
import random

def bin_to_list(val, bin_size):
    temp = bin(val)[2:].zfill(bin_size)
    #print(f'\n Bin_to_list ||| input val = {val}, bin = {temp}')
    ret_val = []
    for b in temp:
        ret_val.append(int(b))
    return ret_val

def print_list(data, per_line=2):
    print_count = 0
    print(f'\n')
    for elem in range(len(data)):
        if (print_count == per_line):
            print(f'\n')
            print_count = 0
        print(f'{data[elem]}', end=" || ")
        print_count += 1

class ButterNode:
    def __init__(self, name, level):
        self.node_name = name
        self.node_level = level
        # create place holders for register sections
        if (self.node_level != 0):
            self.left_path_sel = [0]*self.node_level
            self.right_path_sel = [0]*self.node_level
        else:
            self.left_path_sel = None
            self.right_path_sel = None
        self.left_payload = 0
        self.left_active = 0
        self.right_payload = 0
        self.right_active = 0
        #print(f'\n INIT ||| node_name = {self.node_name}, node_level = {self.node_level}')
    
    def get_left_out(self):
        ret_val = None
        if (self.node_level == 0):
            ret_val = [self.left_payload, self.left_active]
        else:
            ret_val = [self.left_path_sel, self.left_payload, self.left_active]
        return ret_val
    
    def get_right_out(self):
        ret_val = None
        if (self.node_level == 0):
            ret_val = [self.right_payload, self.right_active]
        else:
            ret_val = [self.right_path_sel, self.right_payload, self.right_active]
        return ret_val
    
    def reset_node(self):
        if (self.node_level != 0):
            self.left_path_sel = [0]*self.node_level
            self.right_path_sel = [0]*self.node_level
        else:
            self.left_path_sel = None
            self.right_path_sel = None
        self.left_payload = 0
        self.left_active = 0
        self.right_payload = 0
        self.right_active = 0
    
    def run(self, in_left, in_right):
        # Monitor for node conflicts, i.e, if both left and right inputs are active at the same time.
        # Conflit type = 1 -> if both inputs active and both outputs are active
        # conflict type = 2 -> if both inputs active and only one output active
        if (in_left[2] == 1 and in_right[2] == 1):
            if (in_left[0][0] == in_right[0][0]):
                #raise Exception(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Conflict of type 2 has occured')
                pass
            else:
                #raise Exception(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Conflict of type 1 has occured')
                pass
        elif (in_left[2] == 1 and in_right[2] == 0):
            if (in_left[0][0] == 0):
                #print(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Sending packet to left child')
                if (self.node_level != 0):
                    self.left_path_sel = in_left[0][1:]
                self.left_payload = in_left[1]
                self.left_active = in_left[2]
            else:
                #print(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Sending packet to right child')
                if (self.node_level != 0):
                    self.right_path_sel = in_left[0][1:]
                self.right_payload = in_left[1]
                self.right_active = in_left[2]
        elif (in_left[2] == 0 and in_right[2] == 1):
            if (in_right[0][0] == 0):
                #print(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Sending packet to left child')
                if (self.node_level != 0):
                    self.left_path_sel = in_right[0][1:]
                self.left_payload = in_right[1]
                self.left_active = in_right[2]
            else:
                #print(f'\n NODE [{self.node_level}, {self.node_name}] ||| RUN || Sending packet to right child')
                if (self.node_level != 0):
                    self.right_path_sel = in_right[0][1:]
                self.right_payload = in_right[1]
                self.right_active = in_right[2]
        else:
            self.reset_node()

class Butterfly:

    def __init__(self, width):
        self.butter_width = width
        self.butter_max_level = int(math.floor(math.log(self.butter_width, 2.0)))
        # Create nodes
        self.butter_nodes = [[ButterNode(x, y) for x in range(self.butter_width)] for y in range(self.butter_max_level)]
    
    def run(self, in_data):
        # in_data is a list of list
        # run the network from top down
        dummy_path_sel = [0]*self.butter_max_level
        dummy_payload = 0
        dummy_active = 0
        dummy_data = [dummy_path_sel, dummy_payload, dummy_active]
        for y in list(reversed(range(self.butter_max_level))):
            switch = 2**(y+1)
            out_sel = 0
            prev_left_data = None
            prev_right_data = None
            #print(f'\n BUTTERFLY ||| Computing level {y} || switch = {switch}')
            for x in range(self.butter_width):
                # flip every 'switch' rounds
                # out_sel = 0 -> select out_left from y+1 stage
                # out_sel = 1 -> select out_right from y+1 stage
                # in_sel_left = 0 -> select the node from y+1 level at x pos
                # in_sel_left = 1 -> select the node from y+1 level at x-switch pos
                # in_sel_right = 0 -> select the node from y+1 level at x+switch pos
                # in_sel_right = 1 -> select the node from y+1 level at x pos
                # We dont need in_sel_left and right since they will follow out_sel
                if (x != 0 and int(x%switch) == 0):
                    out_sel = 1-out_sel
                    #print(f'\n BUTTERFLY ||| Changing out_sel to {out_sel}')
                
                if (y == self.butter_max_level-1):
                    #print(f'\n BUTTERFLY ||| Computing Node ({y}, {x}) || data_left = {in_data[x]}, data_right = {dummy_data}')
                    self.butter_nodes[y][x].run(in_data[x], dummy_data)
                else:
                    prev_left_data = lambda u: self.butter_nodes[y+1][x].get_left_out() if (u == 0) else self.butter_nodes[y+1][x-switch].get_right_out()
                    prev_right_data = lambda u: self.butter_nodes[y+1][x+switch].get_left_out() if (u == 0) else self.butter_nodes[y+1][x].get_right_out()
                    #print(f'\n BUTTERFLY ||| Computing Node ({y}, {x}) || out_sel = {out_sel}, data_left = {prev_left_data(out_sel)}, data_right = {prev_right_data(out_sel)}')
                    self.butter_nodes[y][x].run(prev_left_data(out_sel), prev_right_data(out_sel))
                
                # Wait for user input
                #input()
    
    def reset(self):
        for y in range(self.butter_max_level):
            for x in range(self.butter_width):
                self.butter_nodes[y][x].reset_node()
    
    def get_result(self):
        # Compute the last stage by taking the OR of layer 0 outputs
        # The left output of x is ORd with left output of x+1
        # incr by 2 (move to next set of 2)
        ret_val = []
        out_sel = 0
        dummy_payload = 0
        dummy_active = 0
        dummy_data = [dummy_payload, dummy_active]
        for x in range(self.butter_width):
            data_left = lambda y: self.butter_nodes[0][x].get_left_out() if (y == 0) else self.butter_nodes[0][x-1].get_right_out()
            data_right = lambda y: self.butter_nodes[0][x+1].get_left_out() if (y == 0) else self.butter_nodes[0][x].get_right_out()
            if (data_left(out_sel)[1] == 1 and data_right(out_sel)[1] == 0):
                ret_val.append(data_left(out_sel))
            elif (data_left(out_sel)[1] == 0 and data_right(out_sel)[1] == 1):
                ret_val.append(data_right(out_sel))
            else:
                ret_val.append(dummy_data)
            out_sel = 1-out_sel
        return ret_val

class Mapper:
    def __init__(self, width):
        self.mapper_width = width
        self.full_butterfly = Butterfly(self.mapper_width)
        self.free_butterfly = Butterfly(self.mapper_width)
    
    def refresh(self, full_packets, free_packets):
        # Convert input full and free packets to appropriate types
        bin_size = int(math.floor(math.log(self.mapper_width, 2.0)))
        #print(f'\n MAPPER ||| Refresh || bin_size = {bin_size}')
        mod_full_packet = [0]*self.mapper_width
        mod_free_packet = [0]*self.mapper_width
        #print(f'\n MAPPER ||| Refresh || full_packet: ')
        #print_list(full_packets, 4)
        #print(f'\n MAPPER ||| Refresh || free_packet: ')
        #print_list(free_packets, 4)
        for x in range(self.mapper_width):
            mod_full_packet[x] = [bin_to_list(full_packets[x][0], bin_size), full_packets[x][1], full_packets[x][2]]
            mod_free_packet[x] = [bin_to_list(free_packets[x][0], bin_size), free_packets[x][1], free_packets[x][2]]
        #print(f'\n MAPPER ||| Refresh || Mod_full_packet: ')
        #print_list(mod_full_packet, 4)
        #print(f'\n MAPPER ||| Refresh || Mod_free_packet: ')
        #print_list(mod_free_packet, 4)
        # Send through butterflies
        self.full_butterfly.run(mod_full_packet)
        self.free_butterfly.run(mod_free_packet)
        # Combine results and place it in omap_result
        full_result = self.full_butterfly.get_result()
        free_result = self.free_butterfly.get_result()
        # Reset butterflies
        self.full_butterfly.reset()
        self.free_butterfly.reset()
        #print(f'\n MAPPER ||| Refresh || full_result: ')
        #print_list(full_result)
        #print(f'\n MAPPER ||| Refresh || free_result: ')
        #print_list(free_result)
        return (full_result, free_result)
    
def butter_test():
    print(f'\n BUTTER_TEST ||| Enter the total number of elements: ')
    elem_count = int(input())
    bin_size = int(math.floor(math.log(elem_count, 2.0)))

    #print(f'\n BUTTER_TEST ||| Enter begining pos of block of 1s (0 indexed): ')
    #one_beg = int(input())
    #print(f'\n BUTTER_TEST ||| Enter ending pos of block (0 indexed): ')
    #one_end = int(input())

    one_beg = random.randint(1, elem_count-2)
    one_end = random.randint(one_beg+1, elem_count)
    print(f'\n BUTTER_TEST ||| Begining pos of 1s block = {one_beg}, end = {one_end}')

    if (one_end > elem_count-1 or one_end-one_beg < 0):
        raise Exception(f'\n BUTTER_TEST ||| Block cannot exceed total size')
    
    # get the number of zeros before the begining
    zeros = one_beg
    in_data = []
    for elem in range(elem_count):
        # Create inputs
        if (elem >= one_beg and elem <= one_end):
            dest = bin_to_list(elem-zeros, bin_size)
            payload = elem
            active = 1
        else:
            dest = bin_to_list(0, bin_size)
            payload = elem
            active = 0
        data = [dest, payload, active]
        in_data.append(data)
    
    print(f'\n BUTTER_TEST ||| Input data: ')
    print_list(in_data)

    # call butterfly with input data
    butter = Butterfly(elem_count)

    butter.run(in_data)

    # Get output
    out_data = butter.get_result()

    print(f'\n BUTTER_TEST ||| Output data: ')
    print_list(out_data)

def main():
    butter_test()

if __name__ == "__main__":
    main()