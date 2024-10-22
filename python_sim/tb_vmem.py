import csv
import random
from virtual_big import virtualMem as vdmmu_big
from virtual_small import virtualMem as vdmmu_small
from buddy import modifiedBuddySystem as mbs
from virtual_compact import FullAllocSystem as fas
from process import proc

def test_manual():
    # templates

    block_size = 32
    block_count = 4
    group_count = 8

    # Create procs and vdmmu
    vmem_big = vdmmu_big(block_size, block_count, group_count)
    
    # Run VDMMU and procs
    reps = []
    while(1):
        print(f'\n Enter (1) Alloc, (2) Dealloc, (3) Show map, (4) Exit: ')
        option = str(input())
        if (option == '1'):
            print(f'\n Enter Alloc request size: ')
            req_size = int(input())
            req = [0, 0, req_size, None]
            print(f' Sending request {req}')
            vmem_big.write_req(req)
        elif (option == '2'):
            print(f'\n Avail addresses: {reps}')
            print(f' Choose an index: ')
            index = int(input())
            if (index <= len(reps)):
                temp = reps[index]
                dereq = [0, 1, temp[1], temp[0][1]]
                reps.remove(temp)
                print(f' Sending derquest {dereq}')
                vmem_big.write_req(dereq)
        elif (option == '3'):
            vmem_big.show_map()
            vmem_big.show_groups()
        elif (option == '4'):
            print(f'\n Exiting...')
            break

        vmem_big.run()
        temp = vmem_big.read_reply()
        if (temp != None and temp[1] != None):
            print(f'\n Got reply: {temp}')
            temp = [temp, req_size]
            reps.append(temp)

def test_auto(sample, vmem_big, vmem_small, mem, vmem_compact, proc1, proc2, proc3, proc4):

    cycle = 0
    emu_exit = True

    run_mem = True
    run_vmem_big = True
    run_vmem_small = True
    run_vmem_compact = True

    data_buddy = None
    data_butt_linear = None
    data_butt_tree = None
    data_butt_compact = None
    data_sample = None

    # Run VDMMU and procs
    while(1):
        #print(f'\n --------------- SAMPLE {sample} || CYCLE {cycle} ---------------')
        runvect_move = proc1.run()
        proc2.run(runvect_move)
        proc3.run(runvect_move)
        proc4.run(runvect_move)
        # Transfer proc request over to vmem queue
        req_vmem_big = proc1.reqvect_get()
        req_vmem_small = proc3.reqvect_get()
        req_mem = proc2.reqvect_get()
        req_vmem_compact = proc4.reqvect_get()
        if (run_vmem_big):
            vmem_big.write_req(req_vmem_big)
            vmem_big.run()
        if (run_vmem_small):
            vmem_small.write_req(req_vmem_small)
            vmem_small.run()
        if (run_mem):
            mem.write_req(req_mem)
            mem.run()
        if (run_vmem_compact):
            vmem_compact.write_req(req_vmem_compact)
            vmem_compact.run()
        # Transfer vmem reply over to proc1 to move app to run vector
        rep_vmem_big = vmem_big.read_reply()
        rep_vmem_small = vmem_small.read_reply()
        rep_mem = mem.read_reply()
        rep_vmem_compact = vmem_compact.read_reply()
        proc1.runvect_put(rep_vmem_big)
        proc2.runvect_put(rep_mem)
        proc3.runvect_put(rep_vmem_small)
        proc4.runvect_put(rep_vmem_compact)

        if (emu_exit):
            if (vmem_big.get_emu_active() and run_vmem_big):
                print(f'\n VMEM_BIG ||| Computing metrics for sample {sample}')
                #vmem_big.show_map()
                #vmem_big.show_groups()
                vmem_big.print_emu_state()
                data_butt_tree = vmem_big.get_emu_state()
                run_vmem_big = False
            if (vmem_small.get_emu_active() and run_vmem_small):
                print(f'\n VMEM_SMALL ||| Computing metrics for sample {sample}')
                #vmem_small.show_map()
                #vmem_small.show_groups()
                vmem_small.print_emu_state()
                data_butt_linear = vmem_small.get_emu_state()
                run_vmem_small = False
            if (mem.get_emu_active() and run_mem):
                print(f'\n BUDDY ||| Computing metrics for sample {sample}')
                #mem.get_bitmap()
                mem.print_emu_state()
                data_buddy = mem.get_emu_state()
                run_mem = False
            if (vmem_compact.get_emu_active() and run_vmem_compact):
                print(f'\n VMEM_COMPACT ||| Computing metrics for sample {sample}')
                vmem_compact.print_emu_state()
                data_butt_compact = vmem_compact.get_emu_state()
                run_vmem_compact = False
        if (not run_mem and not run_vmem_big and not run_vmem_small and not run_vmem_compact):
            break

        cycle += 1
    
    if (data_buddy != None and data_butt_linear != None and data_butt_tree != None and data_butt_compact != None):
        data_order = [data_buddy, data_butt_linear, data_butt_tree, data_butt_compact]
        data_sample = []
        for x in range(len(data_order[-1])):
            for y in range(len(data_order)):
                data_sample.append(data_order[y][x])
            data_sample.append(" ")
    
    return data_sample

def main():
    samples = 10
    automated = True
    if (automated):
        # templates
        """
        appClass_a_size_min = 2
        appClass_a_size_max = 5
        appClass_b_size_min = 10
        appClass_b_size_max = 25
        appClass_c_size_min = 27
        appClass_c_size_max = 35
        
        appClass_a_count = 8
        appClass_b_count = 10
        appClass_c_count = 2

        block_size = 8
        block_count = 2
        group_count = 8
        proc_shelf_size = 20
        proc_runway_size = 20
        proc_max_reqs = 2
        """
        appClass_a_size_min = 2
        appClass_a_size_max = 3
        appClass_b_size_min = 20
        appClass_b_size_max = 26
        appClass_c_size_min = 63
        appClass_c_size_max = 75

        appClass_a_count = 8
        appClass_b_count = 10
        appClass_c_count = 2

        block_size = 64
        block_count = 2
        group_count = 8
        proc_shelf_size = 20
        proc_runway_size = 20
        proc_max_reqs = 2

        # CSV Data Format
        # [Log Name: _, _, _, _, _, _, Efficiency Measurement - Block_Size = Size ; Block_count = Count, _, _, _, _, _, _, _, _],
        # [Header 1 -> _, Available (AU), _, ||, _, Request Size (AU), _, ||, _, Packing Efficiency (%), _, ||, _, Fragmentation (Blocks), _, ||, _ Total Allocs (AU)],
        # [Header 2 -> BUDDY, BUTTER_LINEAR, BUTTER_TREE], [Header 2], [Header 2],
        # [Data BUDDY], [Data BUTTER_LINEAR], [Data BUTTER_TREE]
        # [Average of all columns]

        # Data {System Type}
        # [Available, Packing, Fragmentation, Total_Allocs]

        space = " "
        log_name = " Efficiency Measurement - Block_Size = Size ; Block_count = Count "
        csv_name = "efficiency_measures"+"_"+str(block_size)+"_"+str(block_count)+".csv"
        header_1 = [" Available (AU) ", "Request Size (AU) ", " Packing Efficiency (%) ", " Fragmentation (Blocks) ", " Total Allocs (AU) ", space]
        header_2 = [" BUDDY ", " BUTTER LINEAR ", " BUTTER TREE ", " COMPACT "]

        data_csv = [[space, space, space, space, space, space, space, log_name, space, space, space, space, space, space, space],
                    [space, header_1[0], space, header_1[-1], space, header_1[1], space, header_1[-1], space, header_1[2], space, header_1[-1], space, header_1[3], space, header_1[-1], space, header_1[4], space],
                    [header_2[0], header_2[1], header_2[2], header_2[3], header_1[-1], header_2[0], header_2[1], header_2[2], header_2[3], header_1[-1], header_2[0], header_2[1], header_2[2], header_2[3], header_1[-1], header_2[0], header_2[1], header_2[2], header_2[3], header_1[-1], header_2[0], header_2[1], header_2[2], header_2[3], header_1[-1]]]

        data_len = (len(header_1)-1) * len(header_2)
        data_run = [[" " for _ in range(data_len)] for _ in range(samples)]
        empty_row = [" " for _ in range(data_len)]

        # Create procs and vdmmu
        mem = mbs(block_size*block_count)
        vmem_big = vdmmu_big(block_size, block_count, group_count)
        vmem_small = vdmmu_small(block_size, block_count, group_count)
        vmem_compact = fas(block_size*block_count)
        proc1 = proc(proc_shelf_size, proc_runway_size, proc_max_reqs, False)
        proc2 = proc(proc_shelf_size, proc_runway_size, proc_max_reqs, True)
        proc3 = proc(proc_shelf_size, proc_runway_size, proc_max_reqs, True)
        proc4 = proc(proc_shelf_size, proc_runway_size, proc_max_reqs, True)

        for samp in range(samples):

            appClass_select = [["A", appClass_a_size_min, appClass_a_size_max, appClass_a_count],
                               ["B", appClass_b_size_min, appClass_b_size_max, appClass_b_count],
                               ["C", appClass_c_size_min, appClass_c_size_max, appClass_c_count]]
            
            # create apps for proc
            for n in range(proc_shelf_size):
                sel = random.choice(appClass_select)
                appName = sel[0]+"_"+str(n)
                range_min = sel[1]
                range_max = sel[2]
                if (sel[3]-1 == 0):
                    appClass_select.remove(sel)
                else: sel[3] -= 1
                proc1.create_app(appName, random.randint(range_min, range_max), random.randint(range_min, range_max))
        
            proc2.copy_proc(proc1)
            proc3.copy_proc(proc1)
            proc4.copy_proc(proc1)
            proc1.show_proc()
            #proc2.show_proc()
            #proc3.show_proc()

            print(f'\n -------------- Running sample {samp} --------------')
            data_sample = test_auto(samp, vmem_big, vmem_small, mem, vmem_compact, proc1, proc2, proc3, proc4)

            if (data_sample != None):
                data_run[samp] = data_sample
            
            proc1.reset()
            proc2.reset()
            proc3.reset()
            proc4.reset()
            vmem_big.reset()
            vmem_small.reset()
            mem.reset()
            vmem_compact.reset()
        
        # Build CSV data
        for samp in range(samples):
            data_csv.append(data_run[samp])
        # Add empty row before average dump
        data_csv.append(empty_row)
        # Compute averages
        # 3 = number of rows for all headers
        data_row_init = 4
        sum_row = [" " for _ in range(data_len)]
        avg = [" " for _ in range(data_len)]
        for x in range(samples):
            for y in range(data_len):
                if (data_csv[data_row_init+x][y] != " "):
                    if (sum_row[y] == " "):
                        sum_row[y] = data_csv[data_row_init+x][y]
                    else:
                        sum_row[y] += data_csv[data_row_init+x][y]
        for y in range(data_len):
            if (sum_row[y] != " "):
                avg[y] = sum_row[y]/samples
        # Add Averages to CSV data
        data_csv.append(avg)

        with open(csv_name, 'w', newline='') as file:
            csv_writer = csv.writer(file)
            csv_writer.writerows(data_csv)
        # End Export
    else:
        test_manual()

if __name__ == "__main__":
    main()