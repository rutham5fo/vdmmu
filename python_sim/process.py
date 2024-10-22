import copy
import queue
import random

class proc:
    # Class vars to keep track of status
    num_procs = 0

    def __init__(self, shelf_size, run_size, max_reqs, follow_mode=False):
        self.app_size = shelf_size
        self.runway_size = run_size
        self.app_max_reqs = max_reqs
        self.follow_mode = follow_mode
        # (app_name, size, app_lifetime, address)
        self.app_idlevect = []
        self.app_runvect = []
        self.app_reqvect = queue.Queue(self.app_max_reqs)
        self.app_repvect = queue.Queue()
        self.proc_id = proc.num_procs
        self.app_pending_reqs = 0
        self.pending_apps = 0
        self.rejects = 0
        proc.num_procs += 1
        print(f'\n PROC[{self.proc_id}]: Created proc {self.proc_id}, of shelf_size {self.app_size}')

    def reset(self):
        self.app_pending_reqs = 0
        self.pending_apps = 0
        self.rejects = 0
        self.app_idlevect.clear()
        self.app_runvect.clear()
        while (not self.app_reqvect.empty()):
            self.app_reqvect.get()
        while (not self.app_repvect.empty()):
            self.app_repvect.get()
    
    def copy_proc(self, src_proc):
        self.app_size = src_proc.app_size
        self.runway_size = src_proc.runway_size
        self.app_max_reqs = src_proc.app_max_reqs
        self.app_idlevect = copy.deepcopy(src_proc.app_idlevect)
    
    def create_app(self, name, lifetime, size):
        self.app_idlevect.append((name, size, lifetime, None))

    def proc_empty(self):
        # Return true if Idlevect and Runvect are empty
        ret_val = False
        if (len(self.app_idlevect) + len(self.app_runvect) == 0 and self.app_repvect.empty()): ret_val = True
        return ret_val

    def run(self, follow_item=None):
        # Decreament lifetime of all apps
        remove = None
        runvect_move = None
        for i in range(len(self.app_runvect)):
            if (self.app_runvect[i][2] == 0 and self.app_reqvect.empty()):
                # Generate dealloc req
                dereq = (self.proc_id, 1, self.app_runvect[i][1], self.app_runvect[i][3])
                #print(f'\n PROC[{self.proc_id}]: Pushing dereq {dereq} into reqvect')
                self.app_reqvect.put(dereq)
                remove = self.app_runvect[i]
            elif (self.app_runvect[i][2] != 0):
                temp = list(self.app_runvect[i])
                temp[2] -= 1
                self.app_runvect[i] = tuple(temp)
        if (remove != None):
            #print(f'\n PROC[{self.proc_id}]: Removing {remove} from app_runvect {self.app_runvect}')
            self.app_runvect.remove(remove)
            remove = None

        # If run list is empty, move app from idlevect to reqvect
        run_condition = lambda: (len(self.app_idlevect) != 0 and len(self.app_runvect)+self.pending_apps != self.runway_size and self.app_reqvect.empty()) if (not self.follow_mode) else (follow_item != None)
        run_item = lambda: random.choice(self.app_idlevect) if (not self.follow_mode) else follow_item
        if (run_condition()):
            temp = run_item()
            req = (self.proc_id, 0, temp[1], None)
            #print(f'\n PROC[{self.proc_id}]: Pushing req {req} into reqvect')
            remove = temp
            self.app_reqvect.put(req)
            self.pending_apps += 1
            runvect_move = temp
        if (remove != None):
            #print(f'\n PROC[{self.proc_id}]: Removed {remove} from app_idlevect and moved to app_repvect')
            #print(f'\n PROC[{self.proc_id}]: App_IdleVect = {self.app_idlevect}, remove = {remove}')
            self.app_idlevect.remove(remove)
            self.app_repvect.put(remove)
            remove = None

        return runvect_move
    
    def reqvect_get(self):
        # pop element from reqvect_q and remove app from runvect if dealloc req
        ret_val = None
        if not self.app_reqvect.empty():
            ret_val = self.app_reqvect.get()
            #print(f'\n PROC[{self.proc_id}]: Sending req {ret_val}')
        return ret_val

    def runvect_put(self, reply):
        if (reply != None):
            self.pending_apps -= 1
            if (reply[1] != None):
                # pop element from reply vect and move to run vect
                temp = list(self.app_repvect.get())
                #print(f'\n PROC: Read reply {reply}')
                temp[3] = reply[1]
                self.app_runvect.append(tuple(temp))
            else:
                # pop element from reply vect and move back to idle vect
                temp = self.app_repvect.get()
                self.app_idlevect.append(temp)
                self.rejects += 1
                #print(f'\n PROC[{self.proc_id}]: Request {temp} rejected with reply {reply} | Total rejects = {self.rejects}')

    
    def show_proc(self):
        # Display app shelf stats
        print(f'\n PROC[{self.proc_id}]: Shelf_size = {self.app_size}, runway_size = {self.runway_size}, pending_reqs = {self.app_pending_reqs}, rejected_reqs = {self.rejects}')
        print(f'\n PROC[{self.proc_id}]: IdleVect = {self.app_idlevect} | RunVect = {self.app_runvect} | ReqVect_empty = {self.app_reqvect.empty()} | RepVect_empty = {self.app_repvect.empty()}')
        print(f'\n PROC[{self.proc_id}]: Proc done = {self.proc_empty()}')