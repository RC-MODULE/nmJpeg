MEMORY
{
  INTERNAL_NMC_BANK0 : ORIGIN = 0x00000800, LENGTH = 0x0001F800
  INTERNAL_NMC_BANK1 : ORIGIN = 0x00020000, LENGTH = 0x00020000
  INTERNAL_NMC_BANK2 : ORIGIN = 0x200000000, LENGTH = 0x00020000
  INTERNAL_NMC_BANK3 : ORIGIN = 0x200020000, LENGTH = 0x00020000

  EXTERNAL_MEM_BANK0 : ORIGIN = 0x40040000, LENGTH = 0x03FC0000
  EXTERNAL_MEM_BANK1 : ORIGIN =0x280000000, LENGTH = 0x04000000
}

SECTIONS
{
  .text_int : ALIGN(0x8)
  {
    *(text);
  } > INTERNAL_NMC_BANK0
 
  .text_jpeg : ALIGN(0x8)
  {
    *(text);
  } > INTERNAL_NMC_BANK0
  
  .data_jpeg : ALIGN(0x8)
  {
    *(.data_jpeg);
  } > INTERNAL_NMC_BANK0
 
 .data_jpeg_opt0 : ALIGN(0x8)
  {
    *(.data_jpeg_opt0);
  } > INTERNAL_NMC_BANK0
 
 .data_jpeg_opt1 : ALIGN(0x8)
  {
    *(.data_jpeg_opt1);
  } > INTERNAL_NMC_BANK1
 
  .text_ddr : ALIGN(0x8)
  {
    *(.text.*);
  } > EXTERNAL_MEM_BANK0

  .jpegout  : ALIGN(0x8)
  {
   *(.jpegout);
  } > EXTERNAL_MEM_BANK0
  
  .init : ALIGN(0x8)
  {
    *(.init);
  } > INTERNAL_NMC_BANK0
  
  .fini : ALIGN(0x8)
  {
    *(.fini);
  } > INTERNAL_NMC_BANK0
  
  .data_imu0 : ALIGN(0x8)
  {
    *(.data_imu0);
    *(.data_imu0.bss);
  } > INTERNAL_NMC_BANK0
  
  .data_imu1 : ALIGN(0x8)
  {
    *(.data_imu1);
    *(.data_imu1.bss);
  } > INTERNAL_NMC_BANK1
  
  .data_imu2 : ALIGN(0x8)
  {
    *(.data_imu2);
    *(.data_imu2.bss);
  } > INTERNAL_NMC_BANK2
  
  .data_imu3 : ALIGN(0x8)
  {
    *(.data_imu3);
    *(.data_imu3.bss);
  } > INTERNAL_NMC_BANK3
  

  
  .data_ddr : ALIGN(0x8)
  {
    *(.data_ddr);
    *(.data_ddr.bss);
  } > EXTERNAL_MEM_BANK0
  .data : ALIGN(0x8)
  {
    *(.data);
  } > INTERNAL_NMC_BANK2
  .bss : ALIGN(0x8)
  {
    *(.bss);
  } > INTERNAL_NMC_BANK2
  .stack : ALIGN(0x8)
  {
    *(.stack);
  } > INTERNAL_NMC_BANK3
  

/************rpc . important ALIGN(0x8) in both *****/
  .rpc_services.bss : ALIGN(0x8)
  {
    *(.rpc_services.bss);
  } > EXTERNAL_MEM_BANK0
  .rpc_services : ALIGN(0x8)
  {
    *(.rpc_services);
  } > EXTERNAL_MEM_BANK0
/************rpc***************/
  
  .heap : ALIGN(0x8)
  {
    *(.heap);
    . = ORIGIN(INTERNAL_NMC_BANK0) + LENGTH(INTERNAL_NMC_BANK0);
    __HEAP_0_END = .;
  } > INTERNAL_NMC_BANK0

  .heap1 : ALIGN(0x8)
  {
    *(.heap1);
    . = ORIGIN(INTERNAL_NMC_BANK1) + LENGTH(INTERNAL_NMC_BANK1);
    __HEAP_1_END = .;
  } > INTERNAL_NMC_BANK1

  .heap2 : ALIGN(0x8)
  {
    *(.heap2);
    . = ORIGIN(INTERNAL_NMC_BANK2) + LENGTH(INTERNAL_NMC_BANK2);
    __HEAP_2_END = .;
  } > INTERNAL_NMC_BANK2

  .heap3 : ALIGN(0x8)
  {
    *(.heap3);
    . = ORIGIN(INTERNAL_NMC_BANK3) + LENGTH(INTERNAL_NMC_BANK3);
    __HEAP_3_END = .;
  } > INTERNAL_NMC_BANK3
  
  
}