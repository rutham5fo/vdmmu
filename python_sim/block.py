import queue
from butterfly import Mapper

class Block:

    def __init__(self, block_size, block_num):
        self.block_num = block_num
        self.block_size = block_size
        # Initialize constants
        self.pos_const = [x for x in range(self.block_size)]
        # Initialize bitmaps and intermediary regs
        self.vmap = [0]*self.block_size
        self.omap = [x for x in range(self.block_size)]
        self.act_vmask = [0]*self.block_size
        self.full_vmask = [0]*self.block_size
        self.free_vmask = [0]*self.block_size
        self.full_omask = [0]*self.block_size
        self.free_omask = [0]*self.block_size
        self.full_packets = [0]*self.block_size
        self.free_packets = [0]*self.block_size
        # Allocator state values
        self.avail_units = self.block_size
        self.alloc_addr = 0
        self.alloc_offset = 0
        # initalize mapper unit
        self.mapUnit = Mapper(self.block_size)

        # Alloc/Dealloc Q
        self.req_q = queue.Queue(2)

        print(f'\n BLOCK [{self.block_num}] ||| INIT || Init complete')
    
    def reset(self):
        self.vmap = [0]*self.block_size
        self.omap = [x for x in range(self.block_size)]
        self.act_vmask = [0]*self.block_size
        self.full_vmask = [0]*self.block_size
        self.free_vmask = [0]*self.block_size
        self.full_omask = [0]*self.block_size
        self.free_omask = [0]*self.block_size
        self.full_packets = [0]*self.block_size
        self.free_packets = [0]*self.block_size
        self.avail_units = self.block_size
        self.alloc_addr = 0
        self.alloc_offset = 0
        while (not self.req_q.empty()):
            self.req_q.get()
    
    def shift_list(self, data=None, count=0, direction=0):
        if (count == 0 or data == None): return data
        else:
            #print(f'\n SHIFTER ||| In_val = {data}')
            new_data = None
            if (direction == 1):
                new_data = [0] + data[:-1]
            else:
                new_data = data[1:] + [0]
            #print(f'\n SHIFTER ||| New_val = {new_data}')
            return self.shift_list(new_data, count-1, direction)
    
    def or_list(self, data_a=None, data_b=None):
        new_data = [0]*self.block_size
        for x in range(len(data_a)):
            if (data_a[x] == 1 or data_b[x] == 1):
                new_data[x] = 1
        return new_data
    
    def and_list(self, data_a=None, data_b=None):
        new_data = [0]*self.block_size
        for x in range(len(data_a)):
            if (data_a[x] == 1 and data_b[x] == 1):
                new_data[x] = 1
        return new_data
    
    def invert_list(self, data=None):
        new_data = [0]*self.block_size
        for x in range(len(data)):
            new_data[x] = 1-data[x]
        return new_data

    def find_vaddr(self, offset):
        ret_val = None
        for x in range(self.block_size):
            if self.omap[x] == offset:
                ret_val = x
                break
        return ret_val

    def omap_update(self, full_result, free_result):
        # Flipper only in name, does no flipping.
        # Simply update all omap regs depending on mask
        for elem in range(self.block_size):
            if (full_result[elem][1] == 1):
                self.omap[elem] = full_result[elem][0]
            elif (free_result[elem][1] == 1):
                self.omap[elem] = free_result[elem][0]
    
    def vmap_update(self, full_result, activation_mask):
        # update vmap with shifted full list
        for elem in range(self.block_size):
            if (activation_mask[elem] == 1):
                self.vmap[elem] = full_result[elem][1]
    
    def vmap_flipper(self, start=None, size=0):
        # Set 'size-1' bits starting at address 0 in temp_map
        base_map = [0]*self.block_size
        for x in range(size):
            base_map[x] = 1
        #print(f'\n BLOCK [{self.block_num}] ||| VMAP_Flipper || base_map = {base_map}')
        # shift the base_map >> start to get active_map
        active_map = self.shift_list(base_map, start, 1)
        #print(f'\n BLOCK [{self.block_num}] ||| VMAP_Flipper || active_map = {active_map}')
        # Flip all bits in map, indicated by a 1 in active_map
        for i in range(self.block_size):
            if (active_map[i] == 1):
                self.vmap[i] = 1-self.vmap[i]
    
    def full_vmask_gen(self, start=None):
        base_mask = [0]*self.block_size
        for x in range(self.block_size-start):
            base_mask[x] = 1
        # full_mask = base_mask reversed & vmap
        self.act_vmask = base_mask[::-1]
        #print(f'\n BLOCK [{self.block_num}] ||| Full_vmask_gen || Reverse base_mask = {base_mask_rev}, Vmap = {self.vmap}')
        self.full_vmask = self.and_list(self.act_vmask, self.vmap)
        #print(f'\n BLOCK [{self.block_num}] ||| Full_vmask_gen || full_vmask = {self.full_vmask}')
    
    def free_vmask_gen(self, start=None, size=0):
        base_mask = [0]*self.block_size
        for x in range(start+size):
            base_mask[x] = 1
        # free_mask = base_mask & vmap inverted
        self.free_vmask = self.and_list(base_mask, self.invert_list(self.vmap))
        #print(f'\n BLOCK [{self.block_num}] ||| Free_vmask_gen || free_vmask = {self.free_vmask}')
    
    def full_omask_gen(self, size=0):
        new_pos = [0]*self.block_size
        roll_over = lambda x, max: max+x if (x < 0) else x
        for x in range(self.block_size):
            new_val = self.pos_const[x]-size
            new_pos[x] = roll_over(new_val, self.block_size)
        self.full_omask = new_pos
    
    def free_omask_gen(self, start=None, size=0):
        new_pos = [0]*self.block_size
        roll_over = lambda x, max: x-max if (x >= max) else x
        for x in range(self.block_size):
            full_units = self.block_size-self.avail_units
            add_val = full_units-start-size
            new_val = self.pos_const[x]+add_val
            new_pos[x] = roll_over(new_val, self.block_size)
        self.free_omask = new_pos
    
    def full_packet_gen(self):
        for x in range(self.block_size):
            self.full_packets[x] = [self.full_omask[x], self.omap[x], self.full_vmask[x]]
    
    def free_packet_gen(self):
        for x in range(self.block_size):
            self.free_packets[x] = [self.free_omask[x], self.omap[x], self.free_vmask[x]]
    
    def alloc(self, request_size=0):
        # Return addr generation is taken care by allocator nodes in the alloc_tree
        if (request_size != 0):
            #print(f'\n BLOCK [{self.block_num}] ||| Alloc || Allocating request of size {request_size} at addr {self.alloc_addr}')
            self.vmap_flipper(self.alloc_addr, request_size)
            self.alloc_addr += request_size
            if (self.alloc_addr == self.block_size):
                self.alloc_offset = 0
            else:
                self.alloc_offset = self.omap[self.alloc_addr]
            self.avail_units -= request_size

    def dealloc(self, offset=None, size=0):
        if (size != 0):
            # Get vaddr from offset
            vaddr = self.find_vaddr(offset)
            if (vaddr == None):
                raise Exception(f'\n Invalid offset, vaddr not found for offset {offset}')
            #print(f'\n BLOCK [{self.block_num}] ||| Dealloc || Deallocating {size} at addr {vaddr}')
            # Update vmap
            self.vmap_flipper(vaddr, size)
            #self.show_vmap()
            # Gen Full_vmask, free_vmask
            self.full_vmask_gen(vaddr)
            self.free_vmask_gen(vaddr, size)
            # Gen full_omask, free_omask
            self.full_omask_gen(size)
            self.free_omask_gen(vaddr, size)
            # Gen packets for full_butter, free_butter
            self.full_packet_gen()
            self.free_packet_gen()
            # Call full and free butterflies to update omap
            full_list, free_list = self.mapUnit.refresh(self.full_packets, self.free_packets)
            # Update omap
            self.omap_update(full_list, free_list)
            self.vmap_update(full_list, self.act_vmask)
            #self.show_omap()
            # Update alloc stats
            self.alloc_addr -= size
            self.alloc_offset = self.omap[self.alloc_addr]
            self.avail_units += size
    
    def run(self):
        req = self.read_req()
        if (req != None):
            #print(f'\n BLOCK [{self.block_num}] ||| RUN || Got req = {req}')
            if (req[0] == 1):
                self.dealloc(req[2], req[1])
            else:
                self.alloc(req[1])
    
    def write_req(self, data=None):
        if (data != None):
            self.req_q.put(data)

    def read_req(self):
        ret_val = None
        if (not self.req_q.empty()):
            ret_val = self.req_q.get()
        return ret_val
    
    def get_avail_units(self):
        return self.avail_units
    
    def get_alloc_offset(self):
        return self.alloc_offset
    
    def get_alloc_addr(self):
        return self.alloc_addr
    
    def show_vmap(self):
        print(f'\n BLOCK [{self.block_num}] ||| Virtual_bitmap = {self.vmap}')
    
    def show_omap(self):
        print(f'\n BLOCK [{self.block_num}] ||| Offset_map = {self.omap}')
    
    def show_map(self):
        print(f'\n BLOCK [{self.block_num}] ||| Map: \n')
        for x in range(self.block_size):
            combined_map = [self.vmap[x], self.omap[x]]
            print(f'{combined_map}', end=", ")
        print(f'\n')

def block_test():
    print(f'\n BLOCK_TEST ||| Enter block size = ')
    block_size = int(input())
    block = Block(block_size)
    while(1):
        print(f'\n BLOCK_TEST ||| Enter (1) Alloc, (2) Dealloc, (3) Show map, (4) Exit: ')
        option = str(input())
        if (option == '1'):
            print(f'\n BLOCK_TEST ||| Enter request_size: ')
            request_size = int(input())
            if (request_size > block.get_avail_units()):
                print(f'\n BLOCK_TEST ||| Request cannot be allocated')
            else:
                block.alloc(request_size)
        elif (option == '2'):
            print(f'\n BLOCK_TEST ||| Enter Dealloc offset: ')
            offset = int(input())
            print(f'\n BLOCK_TEST ||| Enter Dealloc size: ')
            request_size = int(input())
            block.dealloc(offset, request_size)
        elif (option == '3'):
            block.show_map()
        elif (option == '4'):
            print(f'BLOCK_TEST ||| Exiting...')
            break
        else:
            print(f'\n BLOCK_TEST ||| Invalid entry')

def main():
    block_test()

if __name__ == "__main__":
    main()