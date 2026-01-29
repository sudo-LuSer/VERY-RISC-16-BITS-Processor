# Processeur 16 bits avec Bootloader (FPGA)

## Présentation

Ce projet implémente un processeur 16 bits à Architecture Von Neumann en VHDL, synthétisable sur FPGA. Il intègre une unité de contrôle basée sur une machine à états finis (FSM), une unité arithmétique et logique (UAL), une mémoire RAM interne, un bootloader UART pour le chargement dynamique des programmes, ainsi que des périphériques mémoire‑mappés.

Le projet inclut également un assembleur personnalisé en C++ avec analyseur lexical, permettant de traduire un langage assembleur lisible en code machine 16 bits.

---

## Fonctionnalités principales

- Processeur 16 bits Harvard
- FSM pour le cycle FETCH / DECODE / EXECUTE
- UAL : NOR, ADD, SUB, INC
- Double accumulateur (ACCU1, ACCU2)
- RAM interne 64 mots × 16 bits
- Bootloader UART pour chargement de programmes
- Sauts conditionnels basés sur drapeaux (Carry, Equal, Negative)
- Assembleur C++ avec analyseur lexical et résolution de labels
- Périphériques mémoire‑mappés : LEDs, afficheur 7 segments
- Outils de débogage matériel (scan mémoire)

---

## Architecture du système

### Modules principaux

| Module | Description |
|--------|------------|
| CPU_Bootloader.vhd | Composant racine |
| Control_unit.vhd | FSM de contrôle |
| Processing_unit.vhd | UAL et registres |
| RAM_SP_64_8.vhd | RAM principale |
| Boot_loader | Chargement UART |
| CTRL_LED.vhd | Contrôle LEDs |
| CTRL_SeptSeg.vhd | Afficheur 7 segments |

---

## Jeu d’instructions

### Format d’instruction

```
[15:12] Opcode
[11]    Sélecteur accumulateur
[5:0]   Adresse mémoire
```

### Instructions supportées

| Opcode | Instruction | Fonction |
|--------|------------|---------|
| 0000 | NOR | Opération logique |
| 0100 | ADD | Addition |
| 0001 | SUB | Soustraction |
| 0010 | INC | Incrément |
| 1000 | STA | Stockage mémoire |
| 1001 | JUMP | Saut inconditionnel |
| 1100 | JCC | Jump if Carry |
| 1010 | JCE | Jump if Equal |
| 1011 | JCN | Jump if Negative |

---

## Test de primalité

Le projet inclut un programme assembleur permettant de vérifier si un nombre est premier. L’algorithme repose sur une division successive par des entiers croissants et exploite les instructions arithmétiques, les comparaisons implicites via drapeaux, et les sauts conditionnels.

### Objectifs du programme PRIME

- Lire un entier en mémoire
- Tester la divisibilité par des diviseurs successifs
- Déterminer si le nombre est premier ou composé
- Écrire le résultat en mémoire ou sur LEDs

### Fichier

```
programmes/PRIME.asm
```

Ce programme sert à valider la fiabilité du processeur, des drapeaux d’état, des branchements conditionnels et du chemin de données.

---

## Assembleur et analyseur lexical

Un assembleur personnalisé en C++ est fourni. Il intègre :

- Un analyseur lexical
- Un parseur d’instructions assembleur
- La gestion des labels
- La résolution d’adresses mémoire
- La génération du code machine 16 bits

### Exemple de syntaxe

```assembly
@START:
ACCU1 = 0
ACCU1 = ACCU1 ADD mem[@input]
STA @result
JCE(@END)
```

---

## Structure du projet

```
projet_processeur/
├── vhdl/
├── assembleur/
├── programmes/
└── documentation/
```

---

## Compilation et utilisation

### Synthèse FPGA

```bash
vivado -mode batch -source synth.tcl
```

### Compilation assembleur

```bash
g++ -o assembleur Analyseur_lexical.cpp
./assembleur < programme.asm > programme.bin
```

### Chargement via UART

```bash
./send_prog.sh programme.bin /dev/ttyUSB0
```

---

## Limitations

- Mémoire limitée à 64 mots
- Pas de pile ni de sous‑programmes
- Pas d’interruptions matérielles

---

## Perspectives

- Extension mémoire
- Ajout d’instructions (MUL, DIV, SHIFT)
- Pipeline avancé
- Interruptions et pile

---

## Auteur

Projet académique en architecture processeur, VHDL et co‑design matériel/logiciel.

