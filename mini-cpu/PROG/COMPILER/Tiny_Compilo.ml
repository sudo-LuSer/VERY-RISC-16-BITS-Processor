open Str

let zeros = "00000000"

let const_def = regexp "@\\([a-zA-Z0-9_]+\\)[ ]*=[ ]*\\([0-9]+\\|0x[0-9A-Fa-f]+\\)"
let label_def = regexp "@\\([a-zA-Z0-9_]+\\):"
let sta_instr = regexp "STA *@\\([a-zA-Z0-9_]+\\)"
let jcc_instr = regexp "JCC(@\\([a-zA-Z0-9_]+\\))"
let jmp_instr = regexp "JMP(@\\([a-zA-Z0-9_]+\\))"
let jce_instr = regexp "JCE(@\\([a-zA-Z0-9_]+\\))"
let jcn_instr = regexp "JCN(@\\([a-zA-Z0-9_]+\\))"

let alu_instr = regexp "ACCU *= *ACCU *\\(NOR\\|ADD\\|SUB\\|AND\\|OR\\|XOR\\) *mem\\[@\\([a-zA-Z0-9_]+\\)\\]"
let unary_instr = regexp "ACCU *= *\\(NOT\\|CLR\\) *ACCU"
let mov_instr = regexp "ACCU *= *mem\\[@\\([a-zA-Z0-9_]+\\)\\]"

let mem_reg = Hashtbl.create 32

let to_bin n =
  let rec aux n acc =
    if n = 0 then acc else aux (n lsr 1) (string_of_int (n land 1) ^ acc)
  in
  let s = if n = 0 then "0" else aux n "" in
  String.make (6 - String.length s) '0' ^ s

let read_file filename =
  let ic = open_in filename in
  let rec loop pc acc =
    try
      let line = input_line ic in
      let line = Str.replace_first (regexp ";.*$") "" line |> String.trim in

      if line = "" then loop pc acc

      else if string_match const_def line 0 then
        let name = matched_group 1 line in
        let v = matched_group 2 line in
        let value = int_of_string v in
        Hashtbl.add mem_reg name (to_bin value);
        loop pc acc

      else if string_match label_def line 0 then
        let name = matched_group 1 line in
        Hashtbl.add mem_reg name (to_bin pc);
        loop pc acc

      else
        loop (pc+1) (acc @ [line])

    with End_of_file ->
      close_in ic;
      acc
  in
  loop 0 []

let compile instrs =
  List.iter (fun instr ->

    if string_match sta_instr instr 0 then
      print_endline ("1000" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else if string_match jmp_instr instr 0 then
      print_endline ("1001" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else if string_match jcc_instr instr 0 then
      print_endline ("1100" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else if string_match jce_instr instr 0 then
      print_endline ("1010" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else if string_match jcn_instr instr 0 then
      print_endline ("1011" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else if string_match alu_instr instr 0 then
      let op = matched_group 1 instr in
      let addr = Hashtbl.find mem_reg (matched_group 2 instr) in
      let codeop =
        if op = "NOR" then "0000"
        else if op = "ADD" then "0100"
        else if op = "SUB" then "0101"
        else if op = "AND" then "0110"
        else if op = "OR" then "0111"
        else if op = "XOR" then "1000"
        else "0000"
      in
      print_endline (codeop ^ zeros ^ addr)

    else if string_match unary_instr instr 0 then
      let op = matched_group 1 instr in
      let codeop = if op = "NOT" then "0011" else "1111" in
      print_endline (codeop ^ zeros ^ "000000")

    else if string_match mov_instr instr 0 then
      print_endline ("1010" ^ zeros ^ Hashtbl.find mem_reg (matched_group 1 instr))

    else
      print_endline "ERROR"

  ) instrs

let () =
  let instrs = read_file "asm.txt" in
  compile instrs