import math
import queue

class modifiedBuddySystem:
    def __init__(self, bitmap_size):

        self.phy_bm_size = bitmap_size
        self.phy_bm = [0] * self.phy_bm_size
        self.max_level = int(math.floor(math.log(bitmap_size, 2.0)))
        self.or_map = [[None]*self.phy_bm_size for y in range(self.max_level+1)]
        self.level_sel = 0
        self.depth = 2**(self.max_level-self.level_sel)
        # Each request should have (procID, request_type, request_size, Dealloc_addr)
        # request_type -> 0 = alloc | 1 = dealloc
        self.req_q = queue.Queue()
        # Each reply is (address, procID)
        self.rep_q = queue.Queue()

        # ---- Efficiency Measure ----
        self.emu_active = False
        self.fragmentation = 0              # Total number of island of 1s
        self.packing = 0                    # Occupied space / Total space
        self.alloc_fail_avail_units = 0     # The total free space at the time of alloc failure
        self.alloc_fail_size = 0            # The request size that caused alloc failure
        self.total_allocs = 0
        # ----------------------------

        self.comp_orMap()

        print("\n BUDDY: MBS Init complete:")
        print('\n BUDDY: phy_bm_size = {0}, max_level = {1}'.format(self.phy_bm_size, self.max_level))
        print('\n BUDDY: phy_bm = {0}'.format(self.phy_bm))
    
    def reset(self):
        self.phy_bm = [0] * self.phy_bm_size
        self.or_map = [[None]*self.phy_bm_size for y in range(self.max_level+1)]
        self.level_sel = 0
        self.depth = 2**(self.max_level-self.level_sel)
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
        
        self.comp_orMap()
    
    def efficiency_measurement_unit(self, request_size):
        alloc_fail_size = request_size
        alloc_fail_avail_units = 0
        for x in range(self.phy_bm_size):
            if (self.phy_bm[x] == 0):
                alloc_fail_avail_units += 1
        total_size = self.phy_bm_size
        mem_occupied = total_size-alloc_fail_avail_units
        packing = mem_occupied/total_size
        # Go through memory and count blocks (islands) of 1s
        prev_vmap = 0
        fragmentation = 0
        for x in range(self.phy_bm_size):
            if (self.phy_bm[x] == 1 and prev_vmap == 0):
                prev_vmap = 1
            elif (self.phy_bm[x] == 0 and prev_vmap == 1):
                prev_vmap = 0
                fragmentation += 1
        #print(f'\n BUDDY ||| EMU || avail_units = {alloc_fail_avail_units}, request_size = {alloc_fail_size}')
        #print(f'\n BUDDY ||| EMU || packing_eff = {packing}, fragmentation = {fragmentation}, total_allocs = {self.total_allocs}')
        return (alloc_fail_avail_units, alloc_fail_size, packing, fragmentation)

    def alloc(self, request_size):
        # Find first 0 at corresponding level of or_map using request_size as level selector
        self.level_sel = int(math.ceil(math.log(request_size, 2.0)))

        if self.level_sel > self.max_level or self.level_sel < 0:
            print('\n BUDDY: Invalid request_size = {0}, generates level_select = {1}'.format(request_size, self.level_sel))
            raise Exception(" BUDDY: Invalid request_size")
        
        self.depth = 2**(self.max_level-self.level_sel)
        self.phy_addr = None
        #print('\n BUDDY: Level sel = {}, Selected OR_MAP level = {}'.format(self.level_sel, self.or_map[self.level_sel]))
        for x in range(self.depth):
            if self.or_map[self.level_sel][x] == 0:
                self.phy_addr = x*(2**self.level_sel)
                break
        
        # Flip 'request_size' bits starting from phy_addr
        if self.phy_addr != None:
            self.total_allocs += request_size
            for x in range(request_size):
                self.phy_bm[self.phy_addr+x] = 1
        elif (self.emu_active == False):
            #print(f'\n BUDDY ||| Measuring Memory Efficiency:')
            self.alloc_fail_avail_units, self.alloc_fail_size, self.packing, self.fragmentation = self.efficiency_measurement_unit(request_size)
            self.emu_active = True

        # Return the physical address
        return self.phy_addr
    
    def comp_orMap(self):
        # Re-construct or_map for current phy_bm
        for y in range(self.max_level + 1):
            self.depth = 2**(self.max_level-y)
            #print('\n BUDDY: ALLOC: OR_MAP depth = {}'.format(self.depth))
            for x in range(self.depth):
                if y == 0:
                    self.or_map[y][x] = self.phy_bm[x]
                else:
                    self.or_map[y][x] = self.or_map[y-1][x*2] | self.or_map[y-1][x*2+1]
                #print('\n BUDDY: ALLOC: OR_MAP x = {}, y = {}'.format(x, y))
        #print('\n BUDDY: OR-MAP = {0}'.format(self.or_map))
    
    def dealloc(self, phy_addr, request_size):
        for x in range(request_size):
            self.phy_bm[phy_addr+x] = 0
    
    def get_bitmap(self):
        print('\n BUDDY: Physical_Bitmap = {}'.format(self.phy_bm))

    def get_ormap(self):
        print('\n BUDDY: Or-Map = {}'.format(self.or_map))
    
    def get_emu_active(self):
        return self.emu_active
    
    def print_emu_state(self):
        print(f'\n BUDDY ||| EMU status:')
        print(f' avail_units = {self.alloc_fail_avail_units}, request_size = {self.alloc_fail_size}, packing = {self.packing}, fragmentation = {self.fragmentation}, total_allocs = {self.total_allocs}')

    def get_emu_state(self):
        return [self.alloc_fail_avail_units, self.alloc_fail_size, self.packing, self.fragmentation, self.total_allocs]
    
    def run(self):
        self.comp_orMap()
        # read the request queue
        if not self.req_q.empty():
            req = self.req_q.get()
            #print(f'\n BUDDY: Read request [ ProcID = {req[0]}, Type = {req[1]}, Size = {req[2]}, Address = {req[3]} ]')
            if (req[1] == 0):
                rep = (req[0], self.alloc(req[2]))
                #print(f'\n BUDDY: Replying to request {req} with reply {rep}')
                self.rep_q.put(rep)
            else:
                self.dealloc(req[3], req[2])
    
    def write_req(self, procReq):
        # push procReq into request queue
        if (procReq != None):
            self.req_q.put(procReq)
        else:
            #print(f'\n BUDDY: Request = None')
            pass
    
    def read_reply(self):
        # read rep_q and return
        ret_val = None
        if not self.rep_q.empty():
            ret_val = self.rep_q.get()
        return ret_val