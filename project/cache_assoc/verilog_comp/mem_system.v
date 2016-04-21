/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
  // Outputs
  DataOut, Done, Stall, CacheHit, err,
  // Inputs
  Addr, DataIn, Rd, Wr, createdump, clk, rst
  );

  input [15:0] Addr;
  input [15:0] DataIn;
  input        Rd;
  input        Wr;
  input        createdump;
  input        clk;
  input        rst;

  output [15:0] DataOut;
  output Done;
  output Stall;
  output CacheHit;
  output err;

  // Added Wires.
  reg en, signal_error, write, comp, Done, CacheHit, stall_flag, read_mem, write_mem, cache_sel, 
    which_victim, cacheOutSel, signal_writeback;
  wire write_0, write_1, wb_cache;
  
  reg [1:0] mem_off, cache_off;
  reg [3:0] next_state;
  reg [15:0] addr_stalled;

  wire mem_stall, Stall, mem_err, addr_err, victim, victim_flopped, cache_victim, can_victim;
  wire hit_c0, dirty_c0, valid_c0, cache_err_0, hit_c1, dirty_c1, valid_c1, cache_err_1;
  wire [2:0] cache_offset;
  wire [3:0] curr_state, busy;
  wire [4:0] tag_out_c0, tag_out_c1, selectedTagOut;
  wire [15:0] cache_out_0, cache_out_1, mem_out, data_in_mem, cache_in, mem_addr;

  // Module error is just the or of all submodules
  assign err = cache_err_0 | cache_err_1 | mem_err | signal_error | addr_err;

  // make sure address is fine
  assign addr_err = addr_stalled[0]; // if address 0 is ever high then error because we are not byte addressable.
  
  // stalling if mem_stall or stall_flag from fsm
  assign Stall = mem_stall | stall_flag;

  // choose correct cache for data out
  assign DataOut = (cacheOutSel) ? cache_out_1 : cache_out_0;

  assign data_in_mem = DataOut;
  assign selectedTagOut = (cacheOutSel) ? tag_out_c1 : tag_out_c0;

  // calculate cache offset. 
  assign cache_offset = write_mem ? {mem_off, 1'b0} : (cache_sel) ? {cache_off, 1'b0} : addr_stalled[2:0];

  assign cache_in = cache_sel ? mem_out : DataIn;

  // stupid hack to not drop first request of third test. 
  // ask taylor about this?
  always @ (*) begin
    casex (next_state)
      4'b0000: begin
        addr_stalled = addr_stalled;
      end
      default: begin
        addr_stalled = Addr;
      end
    endcase
  end

  // acquire memory address
  assign mem_addr = write_mem ? {selectedTagOut, addr_stalled[10:3], mem_off, 1'b0} : {addr_stalled[15:3], mem_off, 1'b0};

  /* data_mem = 1, inst_mem = 0 *
  * needed for cache parameter */
  parameter mem_type = 0;
  cache #(0 + mem_type) c0(
          // Outputs
          .tag_out              (tag_out_c0),
          .data_out             (cache_out_0),
          .hit                  (hit_c0),
          .dirty                (dirty_c0),
          .valid                (valid_c0),
          .err                  (cache_err_0),

          // Inputs
          .enable               (en), // caches will always be end at the same time.
          .clk                  (clk),
          .rst                  (rst),
          .createdump           (createdump),
          .tag_in               (addr_stalled[15:11]),
          .index                (addr_stalled[10:3]),
          .offset               (cache_offset), // we will never be accessing 2 different locations in a cache
          .data_in              (cache_in),
          .comp                 (comp), // same comp input is fine as long as when high write is high on both
          .write                (write_0), // our write signals are unique, only en access writes on victim
          .valid_in             (1'b1));   

  cache #(1 + mem_type) c1(
          // Outputs
          .tag_out              (tag_out_c1),
          .data_out             (cache_out_1),
          .hit                  (hit_c1),
          .dirty                (dirty_c1),
          .valid                (valid_c1),
          .err                  (cache_err_1),

          // Inputs
          .enable               (en),
          .clk                  (clk),
          .rst                  (rst),
          .createdump           (createdump),
          .tag_in               (addr_stalled[15:11]),
          .index                (addr_stalled[10:3]),
          .offset               (cache_offset),
          .data_in              (cache_in),
          .comp                 (comp),
          .write                (write_1),
          .valid_in             (1'b1));

  // writes for both caches. 
  assign write_0 = signal_writeback ? (!wb_cache) : can_victim ? ((!cache_victim) & write) : ((!victim) & write);
  assign write_1 = signal_writeback ? wb_cache : can_victim ? ((cache_victim) & write) : ((victim) & write);

  // see if the cache can be a victim
  assign can_victim = (!valid_c0 | !valid_c1) | ( (valid_c0 & valid_c1) & (!dirty_c0 | !dirty_c1) );

  // choose a cache victim
  assign cache_victim = (!valid_c0) ? 1'b0 : 
                        (!valid_c1) ? 1'b1 :
                        (valid_c0 & !dirty_c0) ? 1'b0 :
                        (valid_c1 & !dirty_c1);

  // choose which cache to writeback from
  assign wb_cache = (valid_c0 & hit_c0) ? 1'b0 : valid_c1 & hit_c1; 

  // victim flop
  dff victim_ff (.q(victim), .d(victim_flopped), .clk(clk), .rst(rst));
  // logical stuff
  assign victim_flopped = (which_victim) ? !victim : victim;

  four_bank_mem mem(
          // Outputs
          .data_out          (mem_out),
          .stall             (mem_stall),
          .busy              (busy),
          .err               (mem_err),

          // Inputs
          .clk               (clk),
          .rst               (rst),
          .createdump        (createdump),
          .addr              (mem_addr),
          .data_in           (data_in_mem), // We writeback directly back from cache
          .wr                (write_mem),
          .rd                (read_mem));
		  
		  
 // Instantiate 4-bit flip flop for state machine
 dff curr_state_ff [3:0] (.q(curr_state), .d(next_state), .clk(clk), .rst(rst)); 	  
  /********************************************************************************
    A state flop for each of the possible states:

    0000: Idle_State              Default State

    0110: Check_Cache             Main Control State

    0001: Read_1                  Read First Block State
    0010: Read_2                  Read Second Block State
    0011: Read_3                  Read Third Block State

    0100: Wait_for_mem1           Buffer State to wait for Memory
    0101: Wait_for_mem2           Buffer State to wait for Memory
     
    0111: Write_Mem               Write to Memory State

    1000: Cache_Done              Cache Done State
    1001: Cache_Write             Cache_Write
  *********************************************************************************/


  always @ (*) begin
    casex ({curr_state, Rd, Wr, valid_c0, hit_c0, dirty_c0, valid_c1, hit_c1, dirty_c1, busy})
/****************************************************************
  ___    _ _          ____  _        _       
 |_ _|__| | | ___    / ___|| |_ __ _| |_ ___ 
  | |/ _` | |/ _ \   \___ \| __/ _` | __/ _ \
  | | (_| | |  __/    ___) | || (_| | ||  __/
 |___\__,_|_|\___|___|____/ \__\__,_|\__\___|
                |_____|     
/****************************************************************
      Function:      
      Stay in state while Wr and Rd are low
****************************************************************/
      16'b0000_00_xxx_xxx_xxxx : begin
        // next_state -> Idle_State
        next_state = 4'b0000; 
		
		// Signals not Asserted
        en = 1'b0; 
        comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        stall_flag = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/*****************************************************************
      Function:      
      Transition to Check_Cache when Wr goes high and Rd is low
******************************************************************/
      16'b0000_01_xxx_xxx_xxxx : begin
        // next_state -> Check_Cache
        next_state = 4'b0110; 

        // Signals Asserted
        en = 1'b1;  
        comp = 1'b1;
        write = 1'b1;
		stall_flag = 1'b1;
		which_victim = 1'b1;
        signal_writeback = 1'b1; 
		
		// Signals not Asserted
        Done = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        signal_error = 1'b0;
      end
/******************************************************************
      Function:      
      Transition to Check_Cache when Rd goes high and Wr is low
*****************************************************************/
      16'b0000_10_xxx_xxx_xxxx : begin
        // next_state -> Check_Cache
        next_state = 4'b0110;

        // Signals Asserted
        en = 1'b1;
        comp = 1'b1;
		stall_flag = 1'b1;
		which_victim = 1'b1;
		
		// Signals not Asserted
        write = 1'b0;
        Done = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end

/****************************************************************
   ____ _               _        ____           _          
  / ___| |__   ___  ___| | __   / ___|__ _  ___| |__   ___ 
 | |   | '_ \ / _ \/ __| |/ /  | |   / _` |/ __| '_ \ / _ \
 | |___| | | |  __/ (__|   <   | |__| (_| | (__| | | |  __/
  \____|_| |_|\___|\___|_|\_\___\____\__,_|\___|_| |_|\___|
                           |_____|                         
/****************************************************************
      Function:
      Transition back to Idle_State on Rd, hit, valid (either cache)
****************************************************************/
      16'b0110_10_11x_0xx_xxxx, 16'b0110_10_11x_11x_xxxx, 16'b0110_10_11x_10x_xxxx,
      16'b0110_00_11x_0xx_xxxx, 16'b0110_00_11x_11x_xxxx, 16'b0110_00_11x_10x_xxxx : begin 
		// next_state -> Idle_State
        next_state = 4'b0000;
		
		// Signals Asserted
        en = 1'b1;
		Done = 1'b1;
		CacheHit = 1'b1;
		
		// Signals not Asserted
        comp = 1'b0;
        write = 1'b0;
        stall_flag = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Transition back to Idle_State on Wr, valid, hit, dirty (either cache)
****************************************************************/
      16'b0110_10_x0x_11x_xxxx, 16'b0110_10_01x_11x_xxxx,
      16'b0110_00_x0x_11x_xxxx, 16'b0110_00_01x_11x_xxxx : begin 
        // next_state -> Idle_State
        next_state = 4'b0000;
        
		Done = 1'b1;
        en = 1'b1;
		CacheHit = 1'b1;
		cacheOutSel = 1'b1;
		
        comp = 1'b0;
        write = 1'b0;
        stall_flag = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Transition back to Idle_State on Rd, valid, hit, ~dirty
****************************************************************/
        16'b0110_01_110_0xx_xxxx, 16'b0110_01_110_110_xxxx, 16'b0110_01_110_100_xxxx : begin 
        // next_state -> Idle_State
        next_state = 4'b0000;
		
        // Signals Asserted
        en = 1'b1;
		Done = 1'b1;
		CacheHit = 1'b1;

        // Signals not Asserted
		comp = 1'b0;
        write = 1'b0;
        stall_flag = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Cache Miss (1)
****************************************************************/
      16'b0110_01_x0x_110_xxxx, 16'b0110_01_01x_110_xxxx : begin 
		// next_state -> Idle_State
        next_state = 4'b0000; 
        
		// Signals Asserted
		CacheHit = 1'b1;
        en = 1'b1;
		cacheOutSel = 1'b1;
		Done = 1'b1;
		
		// Signals not Asserted
        comp = 1'b0;
        write = 1'b0;
        stall_flag = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Output cache0 data
****************************************************************/
      16'b0110_01_111_0xx_xxxx, 16'b0110_01_111_110_xxxx, 16'b0110_01_110_111_xxxx, 
	  16'b0110_01_111_111_xxxx, 16'b0110_01_111_10x_xxxx, 16'b0110_01_110_101_xxxx  : begin 
        // next_state -> Idle_State
        next_state = 4'b0000; 
        
        // Signals Asserted
        en = 1'b1;
		stall_flag = 1'b1;
		CacheHit = 1'b1;
		Done = 1'b1;
		
		// Signals not Asserted
        comp = 1'b0;
        write = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Cache Miss on Cache 1
****************************************************************/
      16'b0110_01_x0x_111_xxxx, 16'b0110_01_01x_111_xxxx : begin 
        // next_state -> Idle_State
        next_state = 4'b0000; 
        
		// Signals Asserted
        en = 1'b1;
		Done = 1'b1;
		stall_flag = 1'b1;
		cacheOutSel = 1'b1;
		CacheHit = 1'b1;
		
		// Signals not Asserted
        comp = 1'b0;
        write = 1'b0;
        read_mem = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/****************************************************************
      Function:
      Transition to Read_1 if Rd, valid, hit (and other stuff lol)
****************************************************************/
      16'b0110_10_0xx_xxx_xxxx, 16'b0110_10_xxx_0xx_xxxx,
      16'b0110_10_100_xxx_xxxx, 16'b0110_10_xxx_100_xxxx,
      16'b0110_01_0xx_xxx_xxxx, 16'b0110_01_xxx_0xx_xxxx,
      16'b0110_01_100_xxx_xxxx, 16'b0110_01_xxx_100_xxxx : begin
        // next_state -> Read_1
        next_state = 4'b0001; 

		// Signals Asserted
        en = 1'b1;
		stall_flag = 1'b1;
		read_mem = 1'b1;
		
		// Signals not Asserted
        write = 1'b0;
        comp = 1'b0;
        Done = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end

/****************************************************************
      Function:
      Transition to Write_Mem if Rd|Wr, valid, ~hit, dirty (evict)
****************************************************************/
      16'b0110_xx_101_101_xxxx : begin
        // next_state -> Write_Mem
        next_state = 4'b0111;
		
		// Signals Asserted
		stall_flag = 1'b1;
        en = 1'b1;
		
		// Write Bank 0
		write_mem = 1'b1;
        mem_off = 2'b00;
		
		// Signals not Asserted
        comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        read_mem = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        cache_off = 2'b00;
		which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;

        // select mem_in, for evicting from the cache
        cacheOutSel = victim;
      end

/****************************************************************
 __        __    _ _           __  __                
 \ \      / / __(_) |_ ___    |  \/  | ___ _ __ ___  
  \ \ /\ / / '__| | __/ _ \   | |\/| |/ _ \ '_ ` _ \ 
   \ V  V /| |  | | ||  __/   | |  | |  __/ | | | | |
    \_/\_/ |_|  |_|\__\___|___|_|  |_|\___|_| |_| |_|
                         |_____|                          
/****************************************************************
      Function:
      Stay in Write_Mem if busy[0] = 1
****************************************************************/
      16'b0111_xx_xxx_xxx_0001 : begin
        // next_state -> Write_Mem
        next_state = 4'b0111;
		
		// Signals Asserted
        en = 1'b1;
		stall_flag = 1'b1; 

        // Mem Bank 1
        write_mem = 1'b1;
		mem_off = 2'b01;
		
		// Signals not Asserted
		comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        cache_sel = 1'b0;
        CacheHit = 1'b0;
        cache_off = 2'b00;
		read_mem = 1'b0;
		which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;

        // select mem_in, for evicting from the cache
        cacheOutSel = victim;
      end
/****************************************************************
      Function:
      Stay in Write_Mem if busy[0] = 1 & busy[1] = 1
****************************************************************/
      16'b0111_xx_xxx_xxx_0011 : begin
		// next_state -> Write_Mem
        next_state = 4'b0111;
		
	    // Signals Asserted
		en = 1'b1;
        stall_flag = 1'b1; 

        // Mem Bank 2
        write_mem = 1'b1;
		mem_off = 2'b10;

        // Signals not Asserted
		comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        cache_sel = 1'b0;
        cache_off = 2'b00;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
        
        // select mem_in, for evicting from the cache
        cacheOutSel = victim;
      end
/****************************************************************
      Function:
      Stay in Write_Mem if busy[0] = 1 & busy[1] = 1 & busy[2] = 1
****************************************************************/
      16'b0111_xx_xxx_xxx_0111 : begin
		// next_state -> Write_Mem
        next_state = 4'b0111; 

		// Signals Asserted
		en = 1'b1;
        stall_flag = 1'b1; 

        // Mem Bank 3
        write_mem = 1'b1;
		mem_off = 2'b11;
        
		// Signals not Asserted
		comp = 1'b0;
        write = 1'b0; 
        Done = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        cache_sel = 1'b0;
        cache_off = 2'b00;
		which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
        
        // select mem_in, for evicting from the cache
        cacheOutSel = victim;
      end
/****************************************************************
      Function:
      Transition to Read_1 if busy[0] = 0 
****************************************************************/
      16'b0111_xx_xxx_xxx_1110 : begin
        // next_state -> Read_1
        next_state = 4'b0001;
		
		// Signals Asserted
		en = 1'b1;
        stall_flag = 1'b1; 

        // Read Bank 0
        read_mem = 1'b1;
        mem_off = 2'b00;

		// Signals not Asserted
		comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
      
/****************************************************************
 |  _ \ ___  __ _  __| |   / |
 | |_) / _ \/ _` |/ _` |   | |
 |  _ <  __/ (_| | (_| |   | |
 |_| \_\___|\__,_|\__,_|___|_|
                      |_____|                           
/****************************************************************
      Function:
      Read from Bank 1
****************************************************************/
      16'b0001_xx_xxx_xxx_xxxx : begin
        // next_state -> Read_2
        next_state = 4'b0010; 
		
		// Signals Asserted
        stall_flag = 1'b1;
		en = 1'b1;

        // Read from Mem1
        read_mem = 1'b1;
        mem_off = 2'b01;
        
		// Signals not Asserted
        Done = 1'b0;
        comp = 1'b0;
        write = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end

/****************************************************************
  ____                _     ____  
 |  _ \ ___  __ _  __| |   |___ \ 
 | |_) / _ \/ _` |/ _` |     __) |
 |  _ <  __/ (_| | (_| |    / __/ 
 |_| \_\___|\__,_|\__,_|___|_____|
                      |_____|                            
/****************************************************************
      Function:
      Read from Bank 2
****************************************************************/
      16'b0010_xx_xxx_xxx_xxxx : begin
		// next_state -> Read_3
        next_state = 4'b0011; 
		
		// Signals Asserted
		en = 1'b1;
        write = 1'b1;
        stall_flag = 1'b1; 

        // Cache select offset 00
        cache_sel = 1'b1;
        cache_off = 2'b00;

        // Read from Mem2
        read_mem = 1'b1;
        mem_off = 2'b10;

		// Signals not Asserted
		comp = 1'b0; 
        Done = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
      
/****************************************************************
  ____                _     _____ 
 |  _ \ ___  __ _  __| |   |___ / 
 | |_) / _ \/ _` |/ _` |     |_ \ 
 |  _ <  __/ (_| | (_| |    ___) |
 |_| \_\___|\__,_|\__,_|___|____/ 
                      |_____|                          
/****************************************************************
      Function:
      Read from Bank 3
****************************************************************/
      16'b0011_xx_xxx_xxx_xxxx : begin
		// next_state -> Wait_for_mem1
        next_state = 4'b0100; 
	  
        // Signals Asserted
		en = 1'b1;
        write = 1'b1;
        stall_flag = 1'b1;

        // Cache select offset 01
        cache_sel = 1'b1;
        cache_off = 2'b01;

        // Read from Mem3
        read_mem = 1'b1;
        mem_off = 2'b11;

		// Signals not Asserted
		comp = 1'b0;
        Done = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
      
/**********************************************************************
 __        __    _ _        __                                      _ 
 \ \      / /_ _(_) |_     / _| ___  _ __  _ __ ___   ___ _ __ ___ / |
  \ \ /\ / / _` | | __|   | |_ / _ \| '__|| '_ ` _ \ / _ \ '_ ` _ \| |
   \ V  V / (_| | | |_    |  _| (_) | |   | | | | | |  __/ | | | | | |
    \_/\_/ \__,_|_|\__|___|_|  \___/|_|___|_| |_| |_|\___|_| |_| |_|_|
                     |_____|         |_____|                                                  
/*********************************************************************
      Function:
      Transitions unconditionally to Wait_for_mem2
********************************************************************/
      16'b0100_xx_xxx_xxx_xxxx : begin
		// next_state -> Wait_for_mem2
        next_state = 4'b0101;      
	  
		// Signals Asserted
		en = 1'b1;
        write = 1'b1;
        stall_flag = 1'b1; 

        // Cache select offset 10
        cache_sel = 1'b1;
        cache_off = 2'b10;

		// Signals not Asserted
        Done = 1'b0;
        comp = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        mem_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
      
/**********************************************************************
 __        __    _ _        __                                      ____  
 \ \      / /_ _(_) |_     / _| ___  _ __  _ __ ___   ___ _ __ ___ |___ \ 
  \ \ /\ / / _` | | __|   | |_ / _ \| '__|| '_ ` _ \ / _ \ '_ ` _ \  __) |
   \ V  V / (_| | | |_    |  _| (_) | |   | | | | | |  __/ | | | | |/ __/ 
    \_/\_/ \__,_|_|\__|___|_|  \___/|_|___|_| |_| |_|\___|_| |_| |_|_____|
                     |_____|         |_____|                                                                             
/*********************************************************************
      Function:
      Transitions unconditionally to Cache_Done
********************************************************************/
      16'b0101_xx_xxx_xxx_xxxx : begin
		// next_state -> Cache_Done
        next_state = 4'b1000; 
        
		// Signals Asserted
		en = 1'b1;
        write = 1'b1;
        stall_flag = 1'b1;

        // Cache select offset 11
        cache_sel = 1'b1;
        cache_off = 2'b11;

		// Signals not Asserted
		comp = 1'b0; 
        Done = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        mem_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
 
/**********************************************************************
   ____           _              ____                   
  / ___|__ _  ___| |__   ___    |  _ \  ___  _ __   ___ 
 | |   / _` |/ __| '_ \ / _ \   | | | |/ _ \| '_ \ / _ \
 | |__| (_| | (__| | | |  __/   | |_| | (_) | | | |  __/
  \____\__,_|\___|_| |_|\___|___|____/ \___/|_| |_|\___|
                           |_____|                                                                          
/*********************************************************************
      Function:
      Transitions to Cache_Write back if ~Rd & Wr  |  Rd & Wr
********************************************************************/
      16'b1000_01_xxx_xxx_xxxx, 16'b1000_11_xxx_xxx_xxxx : begin
		// next_state -> Cache_Write
        next_state = 4'b1001; 
		
		// Signals Asserted
		en = 1'b1;
        comp = 1'b1;
        write = 1'b1; 
        stall_flag = 1'b1;
		signal_writeback = 1'b1;
	
		// Signals not Asserted
        Done = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_error = 1'b0;
      end
/*********************************************************************
      Function:
      Transitions to Cache_Write back if Rd & ~Wr  |  ~Rd & ~Wr
********************************************************************/
      16'b1000_10_xxx_xxx_xxxx, 16'b1000_00_xxx_xxx_xxxx : begin
		// next_state -> Cache_Write
        next_state = 4'b1001;
		
		// Signals Asserted
        comp = 1'b1;
        stall_flag = 1'b1;
		en = 1'b1;
		
		// Signals not Asserted
        Done = 1'b0;
		write = 1'b0; 
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end

/**********************************************************************
   ____           _          __        __    _ _       
  / ___|__ _  ___| |__   ___ \ \      / / __(_) |_ ___ 
 | |   / _` |/ __| '_ \ / _ \ \ \ /\ / / '__| | __/ _ \
 | |__| (_| | (__| | | |  __/  \ V  V /| |  | | ||  __/
  \____\__,_|\___|_| |_|\___|___\_/\_/ |_|  |_|\__\___|
                           |_____|                                                                                              
/*********************************************************************
      Function:
      Transitions unconditionally to Idle (this is the last state)
********************************************************************/
      16'b1001_xx_xxx_00x_xxxx,16'b1001_xx_xxx_01x_xxxx,16'b1001_xx_xxx_10x_xxxx : begin 
		// next_state -> Idle_State
        next_state = 4'b0000;
	  
		// Signals Asserted
        Done = 1'b1;
        en = 1'b1;
		
		// Signals not Asserted
        comp = 1'b0;
        stall_flag = 1'b0;
        write = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        cacheOutSel = 1'b0;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
/*********************************************************************
      Function:
      Transitions unconditionally to Idle (this is the last state)
********************************************************************/	 
      16'b1001_xx_xxx_11x_xxxx : begin 
		// next_state -> Idle_State
        next_state = 4'b0000;
	  
		// Signals Asserted
        Done = 1'b1;
        en = 1'b1;
		cacheOutSel = 1'b1; // valid hit 
		
		// Signals not Asserted
        comp = 1'b0;
        stall_flag = 1'b0;
        write = 1'b0;
        read_mem = 1'b0;
        CacheHit = 1'b0;
        write_mem = 1'b0;
        cache_sel = 1'b0;
        mem_off = 2'b00;
        cache_off = 2'b00;
        which_victim = 1'b0;
        signal_writeback = 1'b0;
        signal_error = 1'b0;
      end
    endcase
  end
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
