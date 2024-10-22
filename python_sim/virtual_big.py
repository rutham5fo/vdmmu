import math
import queue
from block import Block

class Manager:

    """
    Group_Count -> The number of split groups the manager can actively track
                   Assuming 2 bytes can hold -> || full/empty (1) | Size_limit (7) | Next_Offset (7) | Reserved || ==> Group_reg
                   A word (32) can hold 2 group_regs.
    """
    def __init__(self, number, level, group_count=32):
        # Create internal regs
        self.num = number
        self.level = level
        self.group_count = group_count
        self.avail_units = 0
        self.start_block = self.num*(2**self.level)
        self.free_group = 0
        self.offset = 0
        # Input Q to hold alloc/dealloc req from parent
        self.req_q = queue.Queue(2)
        # Output Q to hold return addresses from allocs
        self.rep_q = queue.Queue(2)
    
    def reset(self):
        self.avail_units = 0
        self.free_group = 0
        self.offset = 0
        while (not self.req_q.empty()):
            self.req_q.get()
        while (not self.rep_q.empty()):
            self.rep_q.get()
    
    def find_free_group(self, groups_map):
        # Return the next free group regs addr
        ret_val = None
        for x in range(self.group_count):
            if (groups_map[x] == 0):
                ret_val = x
                break
        return ret_val
    
    def write_req(self, data=None):
        if (data != None):
            self.req_q.put(data)
    
    def write_rep(self, data=None):
        if (data != None):
            self.rep_q.put(data)
    
    def read_req(self):
        ret_val = None
        if (not self.req_q.empty()):
            ret_val = self.req_q.get()
        return ret_val
    
    def read_rep(self):
        ret_val = None
        if (not self.rep_q.empty()):
            ret_val = self.rep_q.get()
        return ret_val
    
    #def run(self, left, right, groups_sel, groups_map, groups_func):
    def run(self, left, right, groups_sel, groups_map):
        # [NOTE:] A apparent disadvantage is the slow update speed of self.avail_units
        # The alloc/dealloc must traverse the down the whole tree (starting from parent)
        # and must once again travel upwards to compute the new avail units.
        left_avail_units = left.get_avail_units()
        right_avail_units = right.get_avail_units()
        left_size = 0
        right_size = 0
        left_offset = left.get_alloc_offset()
        right_offset = right.get_alloc_offset()
        left_free_grp = lambda x: 0 if (x == 0) else left.get_free_group()
        right_free_grp = lambda x: 0 if (x == 0) else right.get_free_group()
        group = lambda x: self.find_free_group(groups_map) if (x == 0) else max(left_free_grp(x), right_free_grp(x))
        sel_offset = lambda left_avail: right_offset if (left_avail == 0) else left_offset
        ret_addr = None
        send_left = 0
        send_right = 0
        split = 0
        fwd_group = 0
        add_offset_left = 0
        add_offset_right = 0
        self.avail_units = left_avail_units + right_avail_units
        self.offset = sel_offset(left_avail_units)
        self.free_group = group(self.level)
        #print(f'\n MANAGER [{self.level}][{self.num}] ||| RUN || Avail_units = {self.avail_units}, offset = {self.offset}, free_group = {self.free_group}')
        if (not self.req_q.empty()):
            # request = [req_type (0 = alloc, 1 = dealloc), req_size, init_offset, blkgrp, split, start_node, add_offset]
            request = self.read_req()
            #print(f'\n MANAGER [{self.level}][{self.num}] ||| RUN || Received request = {request}')
            if (request != None):
                req_type = request[0]
                req_size = request[1]
                req_offset = request[2]
                req_blkgrp = request[3]
                req_split = request[4]
                req_start = request[5]
                req_add = request[6]
                if (req_type == 1):
                    if (req_split):
                        split = req_split
                        group_sel = groups_sel[req_blkgrp]
                        comp_size = group_sel[0]-req_add
                        left_size = comp_size
                        right_size = req_size-comp_size
                        left_offset = req_offset
                        right_offset = group_sel[1]
                        fwd_group = req_blkgrp
                        send_left = 1
                        send_right = 1
                        if (req_start):
                            add_offset_right = group_sel[0]
                        else:
                            add_offset_right = req_add
                    else:
                        if (req_blkgrp == self.start_block):
                            left_size = req_size
                            left_offset = req_offset
                            send_left = 1
                        else:
                            right_size = req_size
                            right_offset = req_offset
                            send_right = 1
                else:
                    if (req_size <= left_avail_units):
                        left_size = req_size
                        send_left = 1
                        split = req_split
                        add_offset_right = req_add
                        fwd_group = req_blkgrp
                    elif (req_size <= right_avail_units):
                        right_size = req_size
                        send_right = 1
                        split = req_split
                        add_offset_right = req_add
                        fwd_group = req_blkgrp
                    else:
                        split = 1
                        left_size = left_avail_units
                        right_size = req_size-left_avail_units
                        send_left = 1
                        send_right = 1
                        if (req_start == 1):
                            fwd_group = self.free_group
                            add_offset_right = left_avail_units
                        else:
                            fwd_group = req_blkgrp
                            add_offset_right = req_add
                # Update Groups if alloc
                if (split and fwd_group != None):
                    # Update groups_sel reg
                    #left_empty = lambda x: 1 if (x == 0) else 0
                    groups_sel[fwd_group][0] = left_size+req_add
                    groups_sel[fwd_group][1] = right_offset
                    #groups_func[fwd_group] = left_empty(left_size)
                    if (self.level == 0):
                        groups_map[fwd_group] = 1-req_type
            
                # Build return addr, iff this is the start node(manager)
                if (req_type == 0 and req_start == 1):
                    # ret_addr = [split (1), level (1), manum (1), blkgrp (5), offset (7), access_addr (9)]
                    if (split and fwd_group != None):
                        ret_addr = [split, self.level, self.num, fwd_group, left_offset, 0]
                    elif(send_left == 1):
                        ret_addr = [split, self.level, self.num, self.start_block, left_offset, 0]
                    else:
                        ret_addr = [split, self.level, self.num, self.start_block+1, right_offset, 0]

            # Send request to left and right child
            #if (send_left):
            if (fwd_group != None):
                left_req = [req_type, left_size, left_offset, fwd_group, split, 0, add_offset_left]
            else:
                left_req = [req_type, 0, left_offset, 0, split, 0, add_offset_left]
            left.write_req(left_req)
            #print(f'\n MANAGER [{self.level}][{self.num}] ||| RUN || Sending request = {left_req} to left child')
            #if (send_right):
            if (fwd_group != None):
                right_req = [req_type, right_size, right_offset, fwd_group, split, 0, add_offset_right]
            else:
                right_req = [req_type, 0, right_offset, 0, split, 0, add_offset_right]
            right.write_req(right_req)
            #print(f'\n MANAGER [{self.level}][{self.num}] ||| RUN || Sending request = {right_req} to right child')
            
        # write to reply queue if ret_addr exists
        if (ret_addr != None):
            self.write_rep(ret_addr)
    
    def get_avail_units(self):
        return self.avail_units

    def get_alloc_offset(self):
        return self.offset
    
    def get_free_group(self):
        return self.free_group

class virtualMem:

    def __init__(self, block_size, block_count, group_count):
        self.block_size = block_size
        self.block_count = block_count
        self.max_man_level = int(math.ceil(math.log(block_count, 2.0)))
        self.manager_count = (2**self.max_man_level)-1
        self.group_count = group_count
        if (self.block_count < 2**self.max_man_level):
            raise Exception(f'\n VIRTUAL ||| Block count ({self.block_count}) should be a power of 2, nearest valid block_count = {2**self.max_man_level}')
        # Initialize Blocks
        self.blocks = [Block(self.block_size, x) for x in range(self.block_count)]
        # Initialize Block Managers
        self.managers = [[Manager(x, y, self.group_count) for x in range(int(2**(self.max_man_level-y-1)))] for y in range(self.max_man_level)]
        # Initialize Groups
        # Node_groups_sel = [size flag, offset] -> There can be max block_count-1 breaks in a group
        self.max_breaks = 2*(2**(self.max_man_level-1))-1
        self.groups_sel = [[[0, 0] for _ in range(self.group_count)] for _ in range(self.max_breaks)]
        self.groups_map = [[0 for _ in range(self.group_count)] for _ in range(self.max_breaks)]
        #self.groups_func = [[0 for _ in range(self.group_count)] for _ in range(self.max_breaks)]
        # Initialize manager_orMap
        self.manorMap = [[0 for x in range(int(2**(self.max_man_level-y-1)))] for y in range(self.max_man_level)]

        # Init run all mans and blocks
        self.run_elems()
        
        # ---- Efficiency Measure ----
        self.emu_active = False
        self.fragmentation = 0              # Total number of island of 1s
        self.packing = 0                    # Occupied space / Total space
        self.alloc_fail_avail_units = 0     # The total free space at the time of alloc failure
        self.alloc_fail_size = 0            # The request size that caused alloc failure
        self.total_allocs = 0
        # ----------------------------

        # Each request should have (procID, request_type, request_size, Dealloc_addr)
        # request_type -> 0 = alloc | 1 = dealloc
        self.req_q = queue.Queue(2)
        # Each reply is (address, procID)
        self.rep_q = queue.Queue(2)

        print(f'\n VIRTUAL ||| INIT || Init complete')
    
    def reset(self):
        self.groups_sel = [[[0, 0] for _ in range(self.group_count)] for _ in range(self.max_breaks)]
        self.groups_map = [[0 for _ in range(self.group_count)] for _ in range(self.max_breaks)]
        self.manorMap = [[0 for x in range(int(2**(self.max_man_level-y-1)))] for y in range(self.max_man_level)]

        self.reset_elems()
        
        # ---- Efficiency Measure ----
        self.emu_active = False
        self.fragmentation = 0              # Total number of island of 1s
        self.packing = 0                    # Occupied space / Total space
        self.alloc_fail_avail_units = 0     # The total free space at the time of alloc failure
        self.alloc_fail_size = 0            # The request size that caused alloc failure
        self.total_allocs = 0
        # ----------------------------

        while (not self.req_q.empty()):
            self.req_q.get()
        while (not self.rep_q.empty()):
            self.rep_q.get()
        
        self.run_elems()
    
    def efficiency_measurement_unit(self, request_size):
        self.alloc_fail_avail_units = 0
        for x in range(self.block_count):
            self.alloc_fail_avail_units += self.blocks[x].get_avail_units()
        self.alloc_fail_size = request_size
        total_size = self.block_count*self.block_size
        mem_occupied = total_size-self.alloc_fail_avail_units
        self.packing = mem_occupied/total_size
        # Go through memory and count blocks (islands) of 1s
        prev_vmap = 0
        for y in range(self.block_count):
            for x in range(self.block_size):
                if (self.blocks[y].vmap[x] == 1 and prev_vmap == 0):
                    prev_vmap = 1
                elif (self.blocks[y].vmap[x] == 0 and prev_vmap == 1):
                    prev_vmap = 0
                    self.fragmentation += 1
        #print(f'\n VIRTUAL ||| EMU || avail_units = {self.alloc_fail_avail_units}, request_size = {self.alloc_fail_size}')
        #print(f'\n VIRTUAL ||| EMU || packing_eff = {self.packing}, fragmentation = {self.fragmentation}, total_allocs = {self.total_allocs}')
    
    def reset_elems(self):
        for y in range(self.max_man_level+1):
            for x in range(int(2**(self.max_man_level-y))):
                if (y == 0):
                    self.blocks[x].reset()
                else:
                    self.managers[y-1][x].reset()

    def run_elems(self):
        # direction = 0 -> Top-down, 1 -> bottom-up
        # first perform top-down to pass reqs
        # second perform bottom-up to update mans
        level_range = lambda dir: list(reversed(range(self.max_man_level+1))) if (dir == 0) else range(self.max_man_level+1)
        for d in range(2):
            #print(f'\n VIRTUAL ||| RUN_ELEMS ||| Direction = {d} (0 = Top-Down, 1 = Bottom-Up)')
            for y in level_range(d):
                for x in range(int(2**(self.max_man_level-y))):
                    if (y == 0):
                        self.blocks[x].run()
                    else:
                        left_node = lambda level, manum: self.blocks[manum*2] if (level == 0) else self.managers[level-1][manum*2]
                        right_node = lambda level, manum: self.blocks[manum*2+1] if (level == 0) else self.managers[level-1][manum*2+1]
                        breaks_prev = lambda level: 2*(2**(level-1))-1 if (level != 0) else 0
                        cur_groups_addr = lambda level, manum: (manum*(2*(2**level)))+breaks_prev(level)
                        #self.managers[y-1][x].run(left_node(y-1, x), right_node(y-1, x), self.groups_sel[cur_groups_addr(y-1, x)], self.groups_map[cur_groups_addr(y-1, x)], self.groups_func[cur_groups_addr(y-1, x)])
                        self.managers[y-1][x].run(left_node(y-1, x), right_node(y-1, x), self.groups_sel[cur_groups_addr(y-1, x)], self.groups_map[cur_groups_addr(y-1, x)])

    def comp_orMap(self, request_size):
        comp_mans = lambda req_size, manum, level: 0 if (req_size <= self.managers[level][manum].get_avail_units()) else 1
        for y in range(self.max_man_level):
            for x in range(int(2**(self.max_man_level-y-1))):
                self.manorMap[y][x] = comp_mans(request_size, x, y)
    
    def find_start_node(self):
        ret_val = (None, None)
        exit_loop = False
        for y in range(self.max_man_level):
            for x in range(int(2**(self.max_man_level-y-1))):
                if (self.manorMap[y][x] == 0):
                    ret_val = (y, x)
                    exit_loop = True
                    break
            if (exit_loop):
                break
        return ret_val
    
    def alloc(self, request_size):
        ret_addr = None
        # Find a manager that can allocate this request
        self.comp_orMap(request_size)
        level, manum = self.find_start_node()
        # Write to manager req_q
        # request = [req_type (0 = alloc, 1 = dealloc), req_size, init_offset, blkgrp, split, start_node, add_offset]
        alloc_req = [0, request_size, 0, 0, 0, 1, 0]
        if (level != None and manum != None):
            #print(f'\n VIRTUAL ||| ALLOC || Sending request {alloc_req} to manager[{level}][{manum}]')
            self.managers[level][manum].write_req(alloc_req)
            # Update EMU metrics
            self.total_allocs += request_size
        return (level, manum)
    
    def dealloc(self, addr=None, size=0):
        split = addr[0]
        level = addr[1]
        manum = addr[2]
        blkgrp = addr[3]
        offset = addr[4]
        dealloc_req = [1, size, offset, blkgrp, split, 1, 0]
        #print(f'\n VIRTUAL ||| DEALLOC || Sending request {dealloc_req} to manager[{level}][{manum}]')
        self.managers[level][manum].write_req(dealloc_req)
    
    def show_map(self):
        for x in range(self.block_count):
            self.blocks[x].show_map()
    
    def show_groups(self):
        for x in range(self.group_count):
            group = []
            for y in range(self.max_breaks):
                #temp = [self.groups_map[y][x], self.groups_sel[y][x], self.groups_func[y][x]]
                temp = [self.groups_map[y][x], self.groups_sel[y][x]]
                group.append(temp)
            print(f'\n VIRTUAL ||| GROUP [{x}] = {group}')
    
    def get_emu_active(self):
        return self.emu_active
    
    def print_emu_state(self):
        print(f'\n VIRTUAL ||| EMU status of VIRTUAL:')
        print(f' avail_units = {self.alloc_fail_avail_units}, request_size = {self.alloc_fail_size}, packing = {self.packing}, fragmentation = {self.fragmentation}, total_allocs = {self.total_allocs}')
    
    def get_emu_state(self):
        return [self.alloc_fail_avail_units, self.alloc_fail_size, self.packing, self.fragmentation, self.total_allocs]
    
    def run(self):
        # read the request queue
        req = self.read_req()
        level = None
        manum = None
        rep = None
        if (req != None):
            #print(f'\n VDMMU: Read request [ ProcID = {req[0]}, Type = {req[1]}, Size = {req[2]}, Address = {req[3]} ]')
            procID = req[0]
            reqType = req[1]
            reqSize = req[2]
            reqAddr = req[3]
            if (reqType == 0):
                level, manum = self.alloc(reqSize)
            else:
                #print(f'\n VDMMU: Sending dealloc addr = {reqAddr}, size = {reqSize}')
                self.dealloc(reqAddr, reqSize)
            # Run all mans and blocks
            self.run_elems()
            if (reqType == 0 and level != None and manum != None):
                rep = [procID, self.managers[level][manum].read_rep()]
                #print(f'\n VDMMU: Replying to request {req} with reply {rep}')
                self.write_reply(rep)
            elif (reqType == 0 and self.emu_active == False):
                # Measure Allocation Efficiency
                #print(f'\n VIRTUAL ||| Measuring Memory Efficiency:')
                self.efficiency_measurement_unit(reqSize)
                self.emu_active = True
    
    def write_req(self, procReq):
        # push procReq into request queue
        if (procReq != None):
            self.req_q.put(procReq)
        else:
            #print(f'\n VDMMU: Request = None')
            pass
    
    def write_reply(self, data=None):
        if (data != None):
            self.rep_q.put(data)

    def read_req(self):
        ret_val = None
        if (not self.req_q.empty()):
            ret_val = self.req_q.get()
        return ret_val
    
    def read_reply(self):
        # read rep_q and return
        ret_val = None
        if not self.rep_q.empty():
            ret_val = self.rep_q.get()
        return ret_val