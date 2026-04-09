# Processeur 16 bits avec Bootloader (FPGA)

## Présentation

Ce projet implémente un processeur 16 bits à architecture Von Neumann en VHDL, synthétisable sur FPGA. Il intègre une unité de contrôle basée sur une machine à états finis (FSM), une unité arithmétique et logique (UAL), une mémoire RAM interne, un bootloader UART pour le chargement dynamique des programmes, ainsi que des périphériques mémoire-mappés.

Le projet inclut également :
- un assembleur personnalisé en C++ avec analyse lexicale et syntaxique simplifiée
- un mini compilateur permettant la traduction d’un langage de haut niveau (mini-C) vers le jeu d’instructions du processeur

## Fonctionnalités principales

- Processeur 16 bits Von Neumann
- FSM : FETCH / DECODE / EXECUTE
- UAL étendue : NOR, ADD, SUB, INC, AND, OR, XOR, NOT, DEC, PASS, CLEAR
- Double accumulateur (ACCU1, ACCU2)
- RAM interne 64 mots × 16 bits
- Bootloader UART
- Sauts conditionnels : Carry, Equal, Negative

## Jeu d’instructions

### Format

[15:12] Opcode / sel_UAL  
[11] Accumulateur  
[5:0] Adresse  

### CPU

1000 STA  
1001 JUMP  
1100 JCC  
1010 JCE  
1011 JCN  

### UAL

0000 NOR  
0100 ADD  
0001 SUB  
0010 INC  
0011 NOT  
0101 SUB A-B  
0110 AND  
0111 OR  
1000 XOR  
1001 PASS A  
1010 PASS B  
1011 DEC  
1111 CLEAR  

## Exemple

@a = 5  
@b = 3  
@c = 0  

ACCU = mem[@a]  
ACCU = ACCU ADD mem[@b]  
STA @c  

## Compilation

g++ -o assembleur assembleur.cpp  
./assembleur < programme.asm > programme.bin  

## Auteur
Nasr-allah HITAR 
## Encadrant : 
Camille LEROUX(madellimac) suite au Module Conception d'un processeur Very-RISC
