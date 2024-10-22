import math
import queue

class FullAllocSystem:
    def __init__(self, bitmap_size):

        self.phy_bm_size = bitmap_size
        self.full_units = 0
        self.free_units = self.phy_bm_size-self.full_units
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

        print("\n VMEM_COMPACT: MBS Init complete:")
        print('\n VMEM_COMPACT: phy_bm_size = {0}'.format(self.phy_bm_size))
    
    def reset(self):
        self.full_units = 0
        self.free_units = self.phy_bm_size
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
        
    def efficiency_measurement_unit(self, request_size):
        alloc_fail_size = request_size
        alloc_fail_avail_units = self.free_units
        total_size = self.phy_bm_size
        mem_occupied = self.full_units
        packing = mem_occupied/total_size
        # Go through memory and count blocks (islands) of 1s
        fragmentation = 0
        #print(f'\n VMEM_COMPACT ||| EMU || avail_units = {alloc_fail_avail_units}, request_size = {alloc_fail_size}')
        #print(f'\n VMEM_COMPACT ||| EMU || packing_eff = {packing}, fragmentation = {fragmentation}, total_allocs = {self.total_allocs}')
        return (alloc_fail_avail_units, alloc_fail_size, packing, fragmentation)

    def alloc(self, request_size):
        self.phy_addr = None
        if (request_size <= self.free_units):
            self.phy_addr = self.full_units
            self.free_units -= request_size
            self.full_units += request_size
        
        if (self.phy_addr == None and self.emu_active == False):
            #print(f'\n VMEM_COMPACT ||| Measuring Memory Efficiency:')
            self.alloc_fail_avail_units, self.alloc_fail_size, self.packing, self.fragmentation = self.efficiency_measurement_unit(request_size)
            self.emu_active = True

        # Return the physical address
        return self.phy_addr
    
    def dealloc(self, phy_addr, request_size):
        self.full_units -= request_size
        self.free_units += request_size
        
    def get_emu_active(self):
        return self.emu_active
    
    def print_emu_state(self):
        print(f'\n VMEM_COMPACT ||| EMU status:')
        print(f' avail_units = {self.alloc_fail_avail_units}, request_size = {self.alloc_fail_size}, packing = {self.packing}, fragmentation = {self.fragmentation}, total_allocs = {self.total_allocs}')

    def get_emu_state(self):
        return [self.alloc_fail_avail_units, self.alloc_fail_size, self.packing, self.fragmentation, self.total_allocs]
    
    def run(self):
        # read the request queue
        if not self.req_q.empty():
            req = self.req_q.get()
            #print(f'\n VMEM_COMPACT: Read request [ ProcID = {req[0]}, Type = {req[1]}, Size = {req[2]}, Address = {req[3]} ]')
            if (req[1] == 0):
                rep = (req[0], self.alloc(req[2]))
                #print(f'\n VMEM_COMPACT: Replying to request {req} with reply {rep}')
                self.rep_q.put(rep)
            else:
                self.dealloc(req[3], req[2])
    
    def write_req(self, procReq):
        # push procReq into request queue
        if (procReq != None):
            self.req_q.put(procReq)
        else:
            #print(f'\n VMEM_COMPACT: Request = None')
            pass
    
    def read_reply(self):
        # read rep_q and return
        ret_val = None
        if not self.rep_q.empty():
            ret_val = self.rep_q.get()
        return ret_val