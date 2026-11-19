# code for seq_det_tb.v
  ...
     module seq_det_tb();
                
   //Testbench global variables
   reg  seq_in,clock,reset;
   wire det_o;
                
   //Parameter constant for CYCLE
   parameter CYCLE = 10;
                
   //DUT Instantiation
   seq_det SQD(seq_in,clock,reset,det_o);

   //Step1 : Generate clock, using parameter "CYCLE"  
    always
    begin
            #(CYCLE/2);
            clock=1'b1;
            #(CYCLE/2);
            clock=1'b0;
    end

   /*Step2 : Write a task named "initialize" to initialize 
             the input din of sequence detector*/
            task initialize;
                    begin
                            seq_in=0;
                    end
            endtask

                                         
   //Delay task
   task delay();
      begin
              #10;
      end
   endtask

       /*Step3 : Write a task named "RESET" to reset the design,
             use delay task for adding delays*/
            task rst_dut();
                    begin
                            @(negedge clock);
                            reset=1'b0;
                            @(negedge clock);
                            reset=1'b1;
                    end
            endtask
   /*Step4 : Write a task named "stimulus" which provides input to
             design on negedge of clock*/
            task stimulus(i);
                    begin
                                @(negedge clock)
                            seq_in=i;
                    end
            endtask
                        
   /*Process to generate stimulus by calling the tasks and 
   passing the sequence in an overlapping mode*/                
   initial
      begin
         initialize;
              rst_dut;
                        stimulus(1);
                        stimulus(0);
                        stimulus(0);
                        stimulus(1);
                        stimulus(0);
                        stimulus(1);
                        stimulus(1);
                        rst_dut;
                        stimulus(1);
                        stimulus(0);
                        stimulus(0);
                        stimulus(1);
                        delay;    
      end

       //Waveform dump
   /*initial
    begin
     $fsdbDumpvars(0,seq_det_tb);
    end*/

   //Process to monitor the changes in the variables
   initial 
      $monitor("Reset=%b, state=%b, Din=%b, Output Dout=%b",
               reset,SQD.state,seq_in,det_o);
                                                                
   /*Process to display a string after the sequence is detected and dout is asserted.
   SQD.state is used here as a path hierarchy where SQD is the instance name acting
   like a handle to access the internal register "state" */
   always@(SQD.state or det_o)
      begin
         if(SQD.state==2'b11 && det_o==1)
            $display("Correct output at state %b", SQD.state);
      end
                
endmodule   
...
